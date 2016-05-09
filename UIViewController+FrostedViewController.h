//
//  UIViewController+FrostedViewController.h
//  Streaker
//
//  Created by Mcom Media on 09/05/2016.
//  Copyright © 2016 Workstreak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController_FrostedViewController : UIViewController

@end

#import <UIKit/UIKit.h>

@class FrostedViewController;

@interface UIViewController (FrostedViewController)

@property (strong, readonly, nonatomic) FrostedViewController *frostedViewController;

- (void)re_displayController:(UIViewController *)controller frame:(CGRect)frame;
- (void)re_hideController:(UIViewController *)controller;

@end
