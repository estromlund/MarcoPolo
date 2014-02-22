//
//  MPFriendTableViewCell.h
//  MarcoPolo
//
//  Created by Erik Stromlund on 2/22/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPFriendTableViewCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupCellWithName:(NSString *)name
                 location:(NSString *)location
                 imageURL:(NSURL *)imageURL;

@end
