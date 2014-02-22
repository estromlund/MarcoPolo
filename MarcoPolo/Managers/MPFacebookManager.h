//
//  MPFacebookManager.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPFacebookManager : NSObject

- (void)queryFBFriendsForInfoAndLocationWithCompletion:(MPResultErrorBlock)completion;

@end
