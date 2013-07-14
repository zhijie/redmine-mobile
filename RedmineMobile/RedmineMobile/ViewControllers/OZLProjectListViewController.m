//
//  OZLProjectListViewController.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLProjectListViewController.h"
#import "PPRevealSideViewController.h"
#import "OZLProjectViewController.h"

@interface OZLProjectListViewController ()

@end

@implementation OZLProjectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showProjectView
{
    
    OZLProjectViewController *c = [[OZLProjectViewController alloc] initWithNibName:@"OZLProjectViewController" bundle:nil];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
    
}
@end
