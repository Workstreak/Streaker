//
//  FrostedViewController.m
//  Streaker
//
//  Created by Mcom Media on 09/05/2016.
//  Copyright © 2016 Workstreak. All rights reserved.
//

#import "FrostedViewController.h"
#import "FrostedContainerViewController.h"
#import "UIImage+FrostedViewController.h"
#import "UIView+FrostedViewController.h"
#import "UIViewController+FrostedViewController.h"
#import "commonFunctions.h"

@interface FrostedViewController ()

@property (assign, readwrite, nonatomic) CGFloat imageViewWidth;
@property (strong, readwrite, nonatomic) UIImage *image;
@property (strong, readwrite, nonatomic) UIImageView *imageView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (strong, readwrite, nonatomic) FrostedContainerViewController *containerViewController;
@property (strong, readwrite, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, readwrite, nonatomic) BOOL automaticSize;
@property (assign, readwrite, nonatomic) CGSize calculatedMenuViewSize;

@end

@implementation FrostedViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.wantsFullScreenLayout = YES;
#pragma clang diagnostic pop
    _panGestureEnabled = YES;
    _animationDuration = 0.35f;
    _backgroundFadeAmount = 0.3f;
    _blurTintColor = UIKitIsFlatMode() ? nil : [UIColor colorWithWhite:1 alpha:0.75f];
    _blurSaturationDeltaFactor = 1.8f;
    _blurRadius = 10.0f;
    _containerViewController = [[FrostedContainerViewController alloc] init];
    _containerViewController.frostedViewController = self;
    _menuViewSize = CGSizeZero;
    _liveBlur = UIKitIsFlatMode();
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_containerViewController action:@selector(panGestureRecognized:)];
    _automaticSize = YES;
}

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController
{
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self re_displayController:self.contentViewController frame:self.view.bounds];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.contentViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.contentViewController;
}

#pragma mark -
#pragma mark Setters

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (!_contentViewController) {
        _contentViewController = contentViewController;
        return;
    }
    
    [_contentViewController removeFromParentViewController];
    [_contentViewController.view removeFromSuperview];
    
    if (contentViewController) {
        [self addChildViewController:contentViewController];
        contentViewController.view.frame = self.containerViewController.view.frame;
        [self.view insertSubview:contentViewController.view atIndex:0];
        [contentViewController didMoveToParentViewController:self];
    }
    _contentViewController = contentViewController;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    if (_menuViewController) {
        [_menuViewController.view removeFromSuperview];
        [_menuViewController removeFromParentViewController];
    }
    
    _menuViewController = menuViewController;
    
    CGRect frame = _menuViewController.view.frame;
    [_menuViewController willMoveToParentViewController:nil];
    [_menuViewController removeFromParentViewController];
    [_menuViewController.view removeFromSuperview];
    _menuViewController = menuViewController;
    if (!_menuViewController)
        return;
    
    [self.containerViewController addChildViewController:menuViewController];
    menuViewController.view.frame = frame;
    [self.containerViewController.containerView addSubview:menuViewController.view];
    [menuViewController didMoveToParentViewController:self];
}

- (void)setMenuViewSize:(CGSize)menuViewSize
{
    _menuViewSize = menuViewSize;
    self.automaticSize = NO;
}

#pragma mark -

- (void)presentMenuViewController
{
    [self presentMenuViewControllerWithAnimatedApperance:YES];
}

- (void)presentMenuViewControllerWithAnimatedApperance:(BOOL)animateApperance
{
    if ([self.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(frostedViewController:willShowMenuViewController:)]) {
        [self.delegate frostedViewController:self willShowMenuViewController:self.menuViewController];
    }
    
    self.containerViewController.animateApperance = animateApperance;
    if (self.automaticSize) {
        if (self.direction == FrostedViewControllerDirectionLeft || self.direction == FrostedViewControllerDirectionRight)
            self.calculatedMenuViewSize = CGSizeMake(self.contentViewController.view.frame.size.width - 50.0f, self.contentViewController.view.frame.size.height);
        
        if (self.direction == FrostedViewControllerDirectionTop || self.direction == FrostedViewControllerDirectionBottom)
            self.calculatedMenuViewSize = CGSizeMake(self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height - 50.0f);
    } else {
        self.calculatedMenuViewSize = CGSizeMake(_menuViewSize.width > 0 ? _menuViewSize.width : self.contentViewController.view.frame.size.width,
                                                 _menuViewSize.height > 0 ? _menuViewSize.height : self.contentViewController.view.frame.size.height);
    }
    
    if (!self.liveBlur) {
        if (UIKitIsFlatMode() && !self.blurTintColor) {
            self.blurTintColor = [UIColor colorWithWhite:1 alpha:0.75f];
        }
        self.containerViewController.screenshotImage = [[self.contentViewController.view re_screenshot] re_applyBlurWithRadius:self.blurRadius tintColor:self.blurTintColor saturationDeltaFactor:self.blurSaturationDeltaFactor maskImage:nil];
    }
    
    [self re_displayController:self.containerViewController frame:self.contentViewController.view.frame];
    self.visible = YES;
}

- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler
{
    if (!self.visible) {//when call hide menu before menuViewController added to containerViewController, the menuViewController will never added to containerViewController
        return;
    }
    if (!self.liveBlur) {
        self.containerViewController.screenshotImage = [[self.contentViewController.view re_screenshot] re_applyBlurWithRadius:self.blurRadius tintColor:self.blurTintColor saturationDeltaFactor:self.blurSaturationDeltaFactor maskImage:nil];
        [self.containerViewController refreshBackgroundImage];
    }
    [self.containerViewController hideWithCompletionHandler:completionHandler];
}

- (void)resizeMenuViewControllerToSize:(CGSize)size
{
    if (!self.liveBlur) {
        self.containerViewController.screenshotImage = [[self.contentViewController.view re_screenshot] re_applyBlurWithRadius:self.blurRadius tintColor:self.blurTintColor saturationDeltaFactor:self.blurSaturationDeltaFactor maskImage:nil];
        [self.containerViewController refreshBackgroundImage];
    }
    [self.containerViewController resizeToSize:size];
}

- (void)hideMenuViewController
{
    [self hideMenuViewControllerWithCompletionHandler:nil];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if ([self.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(frostedViewController:didRecognizePanGesture:)])
        [self.delegate frostedViewController:self didRecognizePanGesture:recognizer];
    
    if (!self.panGestureEnabled)
        return;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self presentMenuViewControllerWithAnimatedApperance:NO];
    }
    
    [self.containerViewController panGestureRecognized:recognizer];
}

#pragma mark -
#pragma mark Rotation handler

- (BOOL)shouldAutorotate
{
    return self.contentViewController.shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if ([self.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(frostedViewController:willAnimateRotationToInterfaceOrientation:duration:)])
        [self.delegate frostedViewController:self willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.visible) {
        if (self.automaticSize) {
            if (self.direction == FrostedViewControllerDirectionLeft || self.direction == FrostedViewControllerDirectionRight)
                self.calculatedMenuViewSize = CGSizeMake(self.view.bounds.size.width - 50.0f, self.view.bounds.size.height);
            
            if (self.direction == FrostedViewControllerDirectionTop || self.direction == FrostedViewControllerDirectionBottom)
                self.calculatedMenuViewSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 50.0f);
        } else {
            self.calculatedMenuViewSize = CGSizeMake(_menuViewSize.width > 0 ? _menuViewSize.width : self.view.bounds.size.width,
                                                     _menuViewSize.height > 0 ? _menuViewSize.height : self.view.bounds.size.height);
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!self.visible) {
        self.calculatedMenuViewSize = CGSizeZero;
    }
}

@end
