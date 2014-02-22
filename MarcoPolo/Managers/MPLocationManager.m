//
//  MPLocationManager.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPLocationManager.h"

// Apple SDK
#import <CoreLocation/CoreLocation.h>


@interface MPLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) MPLocationResultCompletionBlock locationFoundCompletionBlock;

@end


@implementation MPLocationManager


#pragma mark - Class Methods

+ (instancetype)sharedManager
{
    static MPLocationManager *locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[self alloc] init];
    });
    
    return locationManager;
}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)getLocationWithCompletionBlock:(MPLocationResultCompletionBlock)completionBlock
{
    self.locationFoundCompletionBlock = completionBlock;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *passedLocation = locations[0];

    // Only use if less than 5 minutes old, otherwise return and wait for next hit
    if ([passedLocation.timestamp timeIntervalSinceNow] < 60 * 5) {
        [manager stopUpdatingLocation];
        
        if (self.locationFoundCompletionBlock) {
            self.locationFoundCompletionBlock(passedLocation);
            self.locationFoundCompletionBlock = nil;
        }
    }
}
@end
