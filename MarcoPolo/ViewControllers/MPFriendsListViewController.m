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

// Table View
#import "MPFriendsListDataSource.h"
#import "MPTableViewDelegate.h"

// Managers
#import "MPFacebookManager.h"
#import "MPLocationManager.h"

// Apple SDKS
#import <CoreLocation/CLLocation.h>

// *** Third Party SDKS ***
//
// Facebook SDK
#import <FacebookSDK/FBLoginView.h>

// AFNetworking
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface MPFriendsListViewController () <FBLoginViewDelegate, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MPFriendsListDataSource *dataSource;
@property (nonatomic, strong) MPTableViewDelegate *tableViewDelegate;

@property (nonatomic, strong) MPFacebookManager *facebookManager;
@property (nonatomic, strong) FBLoginView *facebookLoginView;
@property (nonatomic, strong) NSArray *facebookResults;

@end


@implementation MPFriendsListViewController

#pragma mark - View Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.dataSource = [[MPFriendsListDataSource alloc] init];
        self.tableViewDelegate = [[MPTableViewDelegate alloc] init];
        
        self.facebookManager = [[MPFacebookManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [self setupFBLoginView];
    [self setupTableView];
    
    [[MPLocationManager sharedManager] getLocationWithCompletionBlock:^(CLLocation *location) {
        self.currentLocation = location;
        
        // We may or may not have facebook results at this point
        // If we do not, then the facebook completion handler will take care of finishing this
        if (self.facebookResults) {
            [self updateDataSourceWithArray:self.facebookResults];
        }
    }];
    
    if ([[FBSession activeSession] isOpen]) {
        [self doFacebookSearch];
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
    }
}

- (void)setupFBLoginView
{
    self.facebookLoginView = [[FBLoginView alloc] init];
    self.facebookLoginView.readPermissions = @[@"friends_location"];
    self.facebookLoginView.delegate = self;
    
    self.facebookLoginView.frame = CGRectOffset(self.facebookLoginView.frame,
                                          (self.view.center.x - (self.facebookLoginView.frame.size.width / 2)),
                                          (self.view.center.y - (self.facebookLoginView.frame.size.height / 2)));
    [self.view addSubview:self.facebookLoginView];
}

- (void)setupTableView
{
    NSUInteger statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGRect tableViewFrame = CGRectMake(0,
                                       statusBarHeight,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height - statusBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.tableViewDelegate;
    [self.view addSubview:self.tableView];
}


#pragma mark - <FBLoginDelegate>

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    [self doFacebookSearch];
    self.facebookLoginView.hidden = YES;
    self.tableView.hidden = NO;
}

#pragma mark - Private Methods

- (void)updateDataSourceWithArray:(NSArray *)dataArray
{
    self.dataSource.dataArray = [self arraySortedByDistanceFromArray:dataArray];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSArray *)arraySortedByDistanceFromArray:(NSArray *)array
{
    CLLocation *currentLocation = self.currentLocation;
    NSArray *sortedArray = [array sortedArrayWithOptions:NSSortConcurrent
                                         usingComparator:^NSComparisonResult(MPFacebookUser *obj1, MPFacebookUser *obj2) {
                                             CLLocation *firstLocation = obj1.currentLocation.location;
                                             CLLocation *secondLocation = obj2.currentLocation.location;
                                             
                                             CLLocationDistance dist1 = [firstLocation distanceFromLocation:currentLocation];
                                             CLLocationDistance dist2 = [secondLocation distanceFromLocation:currentLocation];
                                             
                                             return [@(dist1) compare:@(dist2)];
                                         }];
    return sortedArray;
}

- (void)doFacebookSearch
{
    [self.facebookManager queryFBFriendsForInfoAndLocationWithCompletion:^(NSArray *result, NSError *error) {
        if (result) {
            self.facebookResults = result;
            
            // We may or may not have a current location at this point
            // If we do not, then the location completion handler will take care of finishing this
            if (self.currentLocation) {
                [self updateDataSourceWithArray:result];
            }
        } else {
            [UIAlertView showWithTitle:@"Error" message:error.localizedDescription];
        }
    }];
}

@end
