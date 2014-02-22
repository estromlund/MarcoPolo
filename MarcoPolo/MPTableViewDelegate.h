//
//  MPTableViewDelegate.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 2/22/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPTableViewDelegate : NSObject<UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
