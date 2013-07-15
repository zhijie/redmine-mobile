//
//  OZLProjectDetailViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLProjectDetailViewController.h"

@interface OZLProjectDetailViewController () {

}

@end

@implementation OZLProjectDetailViewController

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
    [_IDLabel setText:[NSString stringWithFormat:@"%d",_projectData.index]];
    [_nameLabel setText:_projectData.name];
    if (_projectData.parentId < 0) {
        [_parentIDlabel setText:@"--"];
    }else {
        [_parentIDlabel setText:[NSString stringWithFormat:@"%d",_projectData.parentId]];
    }
    [_createTimeLabel setText:_projectData.createdOn];
    [_updateTimeLabel setText:_projectData.updatedOn];

    [_descriptionTextview setEditable:NO];
    [_descriptionTextview setText:_projectData.description];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setIDLabel:nil];
    [self setNameLabel:nil];
    [self setParentIDlabel:nil];
    [self setCreateTimeLabel:nil];
    [self setUpdateTimeLabel:nil];
    [self setDescriptionTextview:nil];
    [super viewDidUnload];
}
@end
