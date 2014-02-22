//
//  MPFacebookManager.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPFacebookManager.h"

// Models
#import "MPFacebookUser.h"
#import "MPLocation.h"

// *** Third Party SDKS ***
//
// Facebook SDK
#import <FacebookSDK/FBRequestConnection.h>
#import <FacebookSDK/FBUtility.h>

@implementation MPFacebookManager

- (void)queryFBFriendsForInfoAndLocationWithCompletion:(MPResultErrorBlock)completion
{
    __weak typeof(self) weakSelf = self;
    
    NSString *friendsQuery = @"SELECT uid, name, pic_square, current_location.id FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
    NSString *locationsQuery = @"SELECT page_id, name, location FROM page WHERE page_id IN (SELECT current_location.id FROM #friendsQuery)";
    
    NSString* fqlQueryString = [NSString stringWithFormat:
                                @"{\"friendsQuery\":\"%@\",\"locationsQuery\":\"%@\"}",friendsQuery, locationsQuery];
    
    
    [FBRequestConnection startWithGraphPath:@"fql"
                                 parameters:@{@"q": fqlQueryString}
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
                              [weakSelf processFBQueryData:result completion:completion];
                          }];
}

- (void)processFBQueryData:(NSDictionary *)friendsData completion:(MPResultErrorBlock)completion
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
    
    if (completion) {
        completion(fbUsersArray, nil);
    }
}

@end
