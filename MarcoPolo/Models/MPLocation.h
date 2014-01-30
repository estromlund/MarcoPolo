//
//  MPLocation.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

// Apple SDKs
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MPLocation : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) CLLocation *location;

- (instancetype)initWithName:(NSString *)name
                    latitude:(CLLocationDegrees)latitude
                   longitude:(CLLocationDegrees)longitude;

@end
