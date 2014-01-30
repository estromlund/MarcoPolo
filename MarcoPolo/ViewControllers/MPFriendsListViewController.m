//
//  MPFriendsListTableViewController.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/29/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPFriendsListViewController.h"

// Models
#import "MPFacebookUser.h"
#import "MPLocation.h"

// Apple SDKS
#import <CoreLocation/CLLocation.h>

// *** Third Party SDKS ***
//
// Facebook SDK
#import <FacebookSDK/FBLoginView.h>
#import <FacebookSDK/FBRequestConnection.h>
#import <FacebookSDK/FBUtility.h>

// AFNetworking
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface MPFriendsListViewController () <FBLoginViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FBLoginView *fbLoginView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *friendsData;

@end

typedef void(^MPVoidBlock)(void);


@implementation MPFriendsListViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [self setupFBLoginView];
    [self setupTableView];
    
    if ([[FBSession activeSession] isOpen]) {
        [self queryFBFriendsListForCurrentLocations];
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
    }
}

- (void)setupFBLoginView
{
    self.fbLoginView = [[FBLoginView alloc] init];
    self.fbLoginView.readPermissions = @[@"friends_location"];
    self.fbLoginView.delegate = self;
    
    self.fbLoginView.frame = CGRectOffset(self.fbLoginView.frame,
                                          (self.view.center.x - (self.fbLoginView.frame.size.width / 2)),
                                          (self.view.center.y - (self.fbLoginView.frame.size.height / 2)));
    [self.view addSubview:self.fbLoginView];
}

- (void)setupTableView
{
    CGRect tableViewFrame = CGRectInset(self.view.frame, 0, 20);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - <FBLoginDelegate>

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    [self queryFBFriendsListForCurrentLocations];
    self.fbLoginView.hidden = YES;
    self.tableView.hidden = NO;
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.friendsData.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reusableCellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusableCellIdentifier];
    }
    
    MPFacebookUser *user = self.friendsData[indexPath.row];
    cell = [self setupCell:cell forUser:user];
    
    return cell;
}

- (UITableViewCell *)setupCell:(UITableViewCell *)cell forUser:(MPFacebookUser *)user
{
    cell.textLabel.text = user.name;
    
    if (user.currentLocation) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%f, %f)", user.currentLocation.name,
                                     user.currentLocation.location.coordinate.latitude,
                                     user.currentLocation.location.coordinate.longitude];
    }
    
    if (user.profilePictureURL) {
        [cell.imageView setImageWithURL:user.profilePictureURL];
    }
    
    return cell;
}


#pragma mark - Private Methods

- (void)queryFBFriendsListForCurrentLocations
{
    __weak typeof(self) weakSelf = self;
    
    NSString *friendsQuery = @"SELECT uid, name, current_location.id FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
    NSString *locationsQuery = @"SELECT page_id, name, location FROM page WHERE page_id IN (SELECT current_location.id FROM #friendsQuery)";
    
    NSString* fqlQueryString = [NSString stringWithFormat:
                                @"{\"friendsQuery\":\"%@\",\"locationsQuery\":\"%@\"}",friendsQuery, locationsQuery];
    
    
    [FBRequestConnection startWithGraphPath:@"fql"
                                 parameters:@{@"q": fqlQueryString}
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              [weakSelf processFBQueryData:result completion:^{
                                  [weakSelf.tableView reloadData];
                              }];
                          }];
}

- (void)processFBQueryData:(NSDictionary *)friendsData completion:(MPVoidBlock)completion
{
    NSArray *resultData = friendsData[@"data"];
    
    NSArray *fbFriendsArray = nil;
    NSArray *fbLocationsArray = nil;
    
    for (NSDictionary *resultDict in resultData) {
        if ([resultDict[@"name"] isEqualToString:@"friendsQuery"]) {
            fbFriendsArray = resultDict[@"fql_result_set"];
        } else if ([resultDict[@"name"] isEqualToString:@"locationsQuery"]) {
            fbLocationsArray = resultDict[@"fql_result_set"];
        }
    }
    
    NSMutableArray *fbUsersArray = [NSMutableArray array];
    for (FBGraphObject *graphUser in fbFriendsArray) {
        
        // Only take users with locations
        if (![graphUser[@"current_location"] isKindOfClass:[NSDictionary class]] ||
            !graphUser[@"current_location"][@"id"]) {
            continue;
        }
        
        MPFacebookUser *user = [[MPFacebookUser alloc] initWithFBGraphUser:graphUser];
        
        // Add location if user has one
        NSNumber *locationID = graphUser[@"current_location"][@"id"];
        if (locationID) {
            for (NSDictionary *dictionary in fbLocationsArray) {
                if ([dictionary[@"page_id"] isEqualToNumber:locationID]) {
                    MPLocation *location = [[MPLocation alloc] initWithName:dictionary[@"name"]
                                                                   latitude:[dictionary[@"location"][@"latitude"] doubleValue]
                                                                  longitude:[dictionary[@"location"][@"longitude"] doubleValue]];
                    user.currentLocation = location;
                    [fbUsersArray addObject:user];
                    break;
                }
            }
        }
    }
    
    self.friendsData = fbUsersArray;
    
    if (completion) {
        completion();
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
