//
//  MPFacebookUser.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBGraphObject, MPLocation;


@interface MPFacebookUser : NSObject

@property (nonatomic, copy,   readonly) NSString *name;
@property (nonatomic, strong, readonly) NSURL *profilePictureURL;

@property (nonatomic, strong)           MPLocation *currentLocation;


- (instancetype)initWithFBGraphUser:(FBGraphObject *)graphUser;

@end
