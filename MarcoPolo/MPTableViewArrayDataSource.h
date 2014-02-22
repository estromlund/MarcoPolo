//
//  MPTableViewArrayDataSource.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 2/22/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPTableViewArrayDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end
