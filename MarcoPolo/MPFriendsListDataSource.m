//
//  MPFriendsListDataSource.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/30/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPFriendsListDataSource.h"

// Models
#import "MPFacebookUser.h"
#import "MPLocation.h"

// Views
#import "MPFriendTableViewCell.h"


@implementation MPFriendsListDataSource


#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reusableCellIdentifier = @"PersonCellIdentifier";
    
    MPFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    
    if (!cell) {
        cell = [[MPFriendTableViewCell alloc] initWithReuseIdentifier:reusableCellIdentifier];
    }
    
    MPFacebookUser *user = self.dataArray[indexPath.row];
    [cell setupCellWithName:user.name
                   location:user.currentLocation.name
                   imageURL:user.profilePictureURL];
    
    return cell;
}

@end
