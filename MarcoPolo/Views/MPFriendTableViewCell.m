//
//  MPFriendTableViewCell.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 2/22/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPFriendTableViewCell.h"

// Frameworks
#import <AFNetworking/UIImageView+AFNetworking.h>

static const NSUInteger contentBuffer = 5;


@interface MPFriendTableViewCell ()

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end


@implementation MPFriendTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat cellHeight = self.frame.size.height;
    
    if (!self.profileImageView) {
        self.profileImageView = ({
            CGFloat imageSize = cellHeight - 2 * contentBuffer;
            
            CGRect frame = CGRectMake(contentBuffer, contentBuffer, imageSize, imageSize);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView;
        });
        [self.contentView addSubview:self.profileImageView];
    }
    
    
    CGFloat labelX = CGRectGetMaxX(self.profileImageView.frame) + contentBuffer;
    CGFloat labelWidth = self.frame.size.width - labelX;
    
    if (!self.nameLabel) {
        self.nameLabel = ({
            CGFloat labelHeight = (cellHeight / 2) - contentBuffer;
            
            CGRect frame = CGRectMake(labelX, contentBuffer, labelWidth, labelHeight);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label;
        });
        [self.contentView addSubview:self.nameLabel];
    }
    
    if (!self.locationLabel) {
        self.locationLabel = ({
            CGFloat labelY = CGRectGetMaxY(self.nameLabel.frame) + contentBuffer;
            CGFloat labelHeight = (cellHeight / 2) - contentBuffer;
            CGFloat labelWidth = self.frame.size.width - labelX;
            
            CGRect frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label;
        });
        [self.contentView addSubview:self.locationLabel];
    }
}

- (void)setupCellWithName:(NSString *)name
                 location:(NSString *)location
                 imageURL:(NSURL *)imageURL
{
    self.nameLabel.text = name;
    self.locationLabel.text = location;
    [self.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"PlaceholderProfileImage"]];
}

- (void)prepareForReuse
{
    self.profileImageView.image = nil;
    self.nameLabel.text = nil;
    self.locationLabel.text = nil;
}

@end
