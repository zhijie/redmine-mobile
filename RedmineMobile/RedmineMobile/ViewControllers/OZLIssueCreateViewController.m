//
//  OZLIssueCreateViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLIssueCreateViewController.h"

@interface OZLIssueCreateViewController ()

@end

@implementation OZLIssueCreateViewController

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

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)];
    [self.navigationItem setRightBarButtonItem:saveBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
}
@end
