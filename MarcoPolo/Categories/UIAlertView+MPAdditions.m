//
//  UIAlertView+MPAdditions.m
//  MarcoPolo
//
//  Created by Erik Stromlund on 2/22/14.
//  Copyright (c) 2014 FathomWorks LLC. All rights reserved.
//

#import "UIAlertView+MPAdditions.h"

@implementation UIAlertView (MPAdditions)

+ (void)showWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
