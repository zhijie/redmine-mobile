//
//  OZLAccountViewController.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLAccountViewController.h"
#import "PPRevealSideViewController.h"
#import "OZLProjectListViewController.h"
#import "OZLSingleton.h"
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
    [self changeSideViewOffset:40];
    
    UIBarButtonItem* projectListBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showLeft)];
    [self.navigationItem setLeftBarButtonItem:projectListBtn];

    _redmineHomeURL.text = [[OZLSingleton sharedInstance] redmineHomeURL];
    _redmineUserKey.text = [[OZLSingleton sharedInstance] redmineUserKey];
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

- (void) showLeft {
    OZLProjectListViewController *c = [[OZLProjectListViewController alloc] initWithNibName:@"OZLProjectListViewController" bundle:nil];
    [self.revealSideViewController pushViewController:c onDirection:PPRevealSideDirectionLeft withOffset:_sideviewOffset animated:YES];
    PP_RELEASE(c);
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
    [super viewDidUnload];
}
- (IBAction)onOk:(id)sender {
    [[OZLSingleton sharedInstance] setRedmineUserKey:_redmineUserKey.text];
    [[OZLSingleton sharedInstance] setRedmineHomeURL:_redmineHomeURL.text];
    
    [self showLeft];
}
@end
