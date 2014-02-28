//
//  MPLocationManager.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Apple SDK
#import <CoreLocation/CLLocation.h>


// Typedefs
typedef void(^MPLocationResultCompletionBlock)(CLLocation *location);


@interface MPLocationManager : NSObject

+ (instancetype)sharedManager;

- (void)getLocationWithCompletionBlock:(MPLocationResultCompletionBlock)completionBlock;

@end
