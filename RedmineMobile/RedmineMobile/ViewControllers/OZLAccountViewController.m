//
//  OZLAccountViewController.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2013 Zhijie Lee(onezeros.lee@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OZLAccountViewController.h"
#import "PPRevealSideViewController.h"
#import "OZLProjectListViewController.h"
#import "OZLSingleton.h"
#import "OZLConstants.h"
#import "OZLNetwork.h"

@interface OZLAccountViewController (){
    float _sideviewOffset;
}

@end

@implementation OZLAccountViewController

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
//    [self changeSideViewOffset:40];

//    UIBarButtonItem* projectListBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showProjectList)];
//    [self.navigationItem setLeftBarButtonItem:projectListBtn];

    _redmineHomeURL.text = [[OZLSingleton sharedInstance] redmineHomeURL];
    _redmineUserKey.text = [[OZLSingleton sharedInstance] redmineUserKey];
    _username.text = [[OZLSingleton sharedInstance] redmineUserName];
    _password.text = [[OZLSingleton sharedInstance] redminePassword];

    UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [self.view addGestureRecognizer:tapper];
}

-(void)backgroundTapped
{
    [self.view endEditing:YES];
}

- (void) preloadLeft {
    OZLProjectListViewController *c = [[OZLProjectListViewController alloc] initWithNibName:@"OZLProjectListViewController" bundle:nil];
    [self.revealSideViewController preloadViewController:c
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:_sideviewOffset];
    PP_RELEASE(c);
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];
}

- (void) showProjectList {
    [self.navigationController popViewControllerAnimated:YES];

//    OZLProjectListViewController *c = [[OZLProjectListViewController alloc] initWithNibName:@"OZLProjectListViewController" bundle:nil];
//    [c setNeedRefresh:YES];
//    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:c];
//    [self.revealSideViewController pushViewController:navigationController onDirection:PPRevealSideDirectionLeft withOffset:_sideviewOffset animated:YES];
//    PP_RELEASE(c);
}

- (IBAction)changeSideViewOffset:(int)offset {
    _sideviewOffset = offset;
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionRight];
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionLeft];
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionTop];
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRedmineHomeURL:nil];
    [self setRedmineUserKey:nil];
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}
- (IBAction)onOk:(id)sender {
    [[OZLSingleton sharedInstance] setRedmineUserKey:_redmineUserKey.text];
    [[OZLSingleton sharedInstance] setRedmineHomeURL:_redmineHomeURL.text];
    [[OZLSingleton sharedInstance] setRedmineUserName:_username.text];
    [[OZLSingleton sharedInstance] setRedminePassword:_password.text];
    [[OZLSingleton sharedInstance] setLastProjectID:-1];

    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:NOTIFICATION_REDMINE_ACCOUNT_CHANGED object:nil];
    
    [self showProjectList];
}
@end
