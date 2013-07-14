//
//  OZLProjectListViewController.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OZLProjectListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *projectsTableview;
- (IBAction)showAccountView:(id)sender;
@end
