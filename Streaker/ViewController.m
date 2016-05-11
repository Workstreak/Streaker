//
//  ViewController.m
//  Streaker
//
//  Created by Mcom Media on 09/05/2016.
//  Copyright © 2016 Workstreak. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add a button to the center of the view to show the timeline
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Show Timeline" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = self.view.center;
    [button addTarget:self action:@selector(showTimeline) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)showTimeline {
    // Create an API client and data source to fetch Tweets for the timeline
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    TWTRCollectionTimelineDataSource *datasource = [[TWTRCollectionTimelineDataSource alloc] initWithCollectionID:@"725994508928741376" APIClient:client];
    TWTRTimelineViewController *controller = [[TWTRTimelineViewController alloc] initWithDataSource:datasource];
    // Create done button to dismiss the view controller
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissTimeline)];
    controller.navigationItem.leftBarButtonItem = button;
    // Create a navigation controller to hold the
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self showDetailViewController:navigationController sender:self];
}

- (void)dismissTimeline {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];

}
@end
