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


static NSString * const MP_FBGraphUserNameKey = @"name";
static NSString * const MP_FBGraphUserProfilePhotoKey = @"pic_square";


@interface MPFacebookUser ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSURL *profilePictureURL;

@end


@implementation MPFacebookUser

- (instancetype)initWithFBGraphUser:(FBGraphObject *)graphUser
{
    self = [super init];
    if (self) {
        if (graphUser[MP_FBGraphUserNameKey]) {
            self.name = graphUser[MP_FBGraphUserNameKey];
        }
        
        if (graphUser[MP_FBGraphUserProfilePhotoKey]) {
            self.profilePictureURL = [NSURL URLWithString:graphUser[MP_FBGraphUserProfilePhotoKey]];
        }
    }
    return self;
}

@end
