//
//  LeftPanelViewController.m
//  SlideMenuApp
//
//  Created by keshava on 3/11/15.
//  Copyright (c) 2015 keshava. All rights reserved.
//

#import "LeftPanelViewController.h"

#import "ServiceOrdersViewController.h"
#import "InstalledProductsViewController.h"

#import "SFAuthenticationManager.h"


@interface LeftPanelViewController ()

@end
static NSString *CellIdentifier = @"CellIdentifier";

@implementation LeftPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableDataArray = [[NSMutableArray alloc]initWithObjects:@"Work Orders",@"Installed Products",@"Logout", nil];
    
    serviceOrdersView = [[ServiceOrdersViewController alloc]init];
    installedProductsView = [[InstalledProductsViewController alloc]init];
    escalationView = [[EscalationsViewController alloc]init];
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableDataArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    }
    if (indexPath.row == 1) {
        
        
    }
    if (indexPath.row == 2) {
        
        
    }
    if (indexPath.row == 3) {
        
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Logout ?"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Yes",@"No",nil];
        [alertView show];

//        [self.revealController setFrontViewController:stockTransferView];
//        [self.revealController showViewController:stockTransferView];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[SFAuthenticationManager sharedManager] logout];
        
    }
    else if (buttonIndex == 1)
    {
        [alertView dismissWithClickedButtonIndex:1 animated:TRUE];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
