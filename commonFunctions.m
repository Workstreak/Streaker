//
//  commonFunctions.m
//  Streaker
//
//  Created by Mcom Media on 09/05/2016.
//  Copyright © 2016 Workstreak. All rights reserved.
//

#import "commonFunctions.h"
#import <UIKit/UIKit.h>

BOOL FrostedViewControllerUIKitIsFlatMode(void)
{
    static BOOL isUIKitFlatMode = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (floor(NSFoundationVersionNumber) > 993.0) {
            // If your app is running in legacy mode, tintColor will be nil - else it must be set to some color.
            if (UIApplication.sharedApplication.keyWindow) {
                isUIKitFlatMode = [UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(tintColor)];
            } else {
                // Possible that we're called early on (e.g. when used in a Storyboard). Adapt and use a temporary window.
                isUIKitFlatMode = [[UIWindow new] respondsToSelector:@selector(tintColor)];
            }
        }
    });
    return isUIKitFlatMode;
}