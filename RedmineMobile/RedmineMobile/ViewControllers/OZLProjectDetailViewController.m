//
//  OZLProjectDetailViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.

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
