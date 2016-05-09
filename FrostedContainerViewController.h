//
//  FrostedContainerViewController.h
//  Streaker
//
//  Created by Mcom Media on 09/05/2016.
//  Copyright © 2016 Workstreak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FrostedViewController;

@interface FrostedContainerViewController : UIViewController

@property (strong, readwrite, nonatomic) UIImage *screenshotImage;
@property (weak, readwrite, nonatomic) FrostedViewController *frostedViewController;
@property (assign, readwrite, nonatomic) BOOL animateApperance;
@property (strong, readonly, nonatomic) UIView *containerView;

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)hide;
- (void)resizeToSize:(CGSize)size;
- (void)hideWithCompletionHandler:(void(^)(void))completionHandler;
- (void)refreshBackgroundImage;

@end