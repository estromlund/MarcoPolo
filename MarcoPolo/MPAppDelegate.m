//
//  MPAppDelegate.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 1/29/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "MPAppDelegate.h"

// View Controllers
#import "MPFriendsListViewController.h"

// Facebook
#import <FacebookSDK/FBAppCall.h>


@implementation MPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    MPFriendsListViewController *friendsListViewController = [[MPFriendsListViewController alloc] init];
    self.window.rootViewController = friendsListViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}

@end
