//
//  MPLocation.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPLocation.h"


@interface MPLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) CLLocation *location;

@end


@implementation MPLocation

- (instancetype)initWithName:(NSString *)name
                    latitude:(CLLocationDegrees)latitude
                   longitude:(CLLocationDegrees)longitude
{
    self = [super init];
    if (self) {
        self.name = name;
        
        self.location = [[CLLocation alloc] initWithLatitude:latitude
                                                   longitude:longitude];
    }
    return self;
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    
}

@end
