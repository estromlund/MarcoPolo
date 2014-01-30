//
//  MPFacebookUser.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPFacebookUser.h"

// Models
#import "MPLocation.h"

// Facebook SDK
#import <FacebookSDK/FBGraphObject.h>

@interface MPFacebookUser ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSURL *profilePictureURL;

@end


@implementation MPFacebookUser

- (instancetype)initWithFBGraphUser:(FBGraphObject *)graphUser
{
    self = [super init];
    if (self) {
        if (graphUser[@"name"]) {
            self.name = graphUser[@"name"];
        }
        
//        if (graphUser[@"location"]) {
//            self.currentLocation = [[MPLocation alloc] initWithName:graphUser[@"location"][@"name"]
//                                                           latitude:0
//                                                           longitude:0];
//        }
        
        if (graphUser[@"picture"]) {
            self.profilePictureURL = [NSURL URLWithString:graphUser[@"picture"][@"data"][@"url"]];
        }
    }
    return self;
}

@end
