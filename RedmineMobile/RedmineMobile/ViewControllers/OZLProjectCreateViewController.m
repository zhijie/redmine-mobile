//
//  OZLProjectCreateViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLProjectCreateViewController.h"
#import "MBProgressHUD.h"
#import "OZLNetwork.h"
#import "MLTableAlert.h"

@interface OZLProjectCreateViewController () {
    MBProgressHUD * _HUD;
    
}

@end

@implementation OZLProjectCreateViewController

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


    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Loading...";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {

    if (_name.text.length == 0) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"Project name can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        
        return;
    }
    if (_identifier.text.length == 0) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"Project identifier can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        return;
    }
    

    OZLModelProject* projectData = [[OZLModelProject alloc] init];
    projectData.name = _name.text;
    projectData.identifier = _identifier.text;
    //TODO: is_public is not processed yet

    projectData.description = _description.text;
    projectData.homepage = _homepageUrl.text;
    if (_parentProject) {
        projectData.parentId = _parentProject.index;
    }

    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"Creating Project...";
    [_HUD show:YES];
    [OZLNetwork createProject:projectData withParams:nil andBlock:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"create project error: %@",error.description);
        }else {
            
        }
        [_HUD hide:YES];
    }];
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setIdentifier:nil];
    [self setHomepageUrl:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 4) {//parent project
        // create the alert
        MLTableAlert* tableAlert = [MLTableAlert tableAlertWithTitle:@"Parent Project" cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                                      {
                                          return  _projectList.count;
                                      }
                                                              andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                                      {
                                          static NSString *CellIdentifier = @"CellIdentifier";
                                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                                          if (cell == nil)
                                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

                                          if (indexPath.row == 0) {
                                              cell.textLabel.text = @"None";
                                          }else {
                                              cell.textLabel.text = [[_projectList objectAtIndex:indexPath.row - 1] name];
                                          }
                                          return cell;
                                      }];

        // Setting custom alert height
        tableAlert.height = 350;

        // configure actions to perform
        [tableAlert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            UITableViewCell* parentCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (selectedIndex.row == 0) {
                _parentProject = nil;
                parentCell.detailTextLabel.text = @"None";
            }else {
                _parentProject = [_projectList objectAtIndex:selectedIndex.row - 1];
                parentCell.detailTextLabel.text = _parentProject.name;
            }
            [parentCell.detailTextLabel sizeToFit];
        } andCompletionBlock:^{
            
        }];
        
        // show the alert
        [tableAlert show];
    }
}
@end
