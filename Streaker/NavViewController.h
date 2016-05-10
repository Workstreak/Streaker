//
//  NavViewController.h
//  Streaker
//
//  Created by Mcom Media on 09/05/2016.
//  Copyright © 2016 Workstreak. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FrostedViewController.h"

@interface NavViewController : UINavigationController

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender;
@end