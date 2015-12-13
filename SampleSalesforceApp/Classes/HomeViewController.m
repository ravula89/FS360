//
//  HomeViewController.m
//  FS360
//
//  Created by BiznusSoft on 7/31/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import "HomeViewController.h"
#import "ServiceOrdersViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "SFAuthenticationManager.h"


@interface HomeViewController ()
{
    AccountsViewController * accountsView;
    ServiceOrdersViewController* serviceOrdersView;
    InstalledProductsViewController * installedProductsView;
    LeftPanelViewController * leftView;
    NSString *userId;
    
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userId =  [SFAuthenticationManager sharedManager].idCoordinator.idData.userId;
    NSLog(@"UserId:%@",userId);

//    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name FROM User LIMIT 10"];
    
//    SFRestRequest * request = [[SFRestAPI sharedInstance]requestForQuery:@"select id,name,FConnect__Technician_used__c from FConnect__Service_Order__c"];
    
//    [[SFRestAPI sharedInstance] send:request delegate:self];

    leftView = [[LeftPanelViewController alloc]init];
    serviceOrdersView = [[ServiceOrdersViewController alloc]init];
    installedProductsView = [[InstalledProductsViewController alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [super viewWillAppear:animated];
}


#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSArray *records = [jsonResponse objectForKey:@"records"];
    NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
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


- (IBAction)serviceOrdersBtnAction:(id)sender {
    
    serviceOrdersView._isGettingData = YES;
    serviceOrdersView.userId = userId;
    [self.navigationController pushViewController:serviceOrdersView animated:YES];

}



//- (IBAction)installedProductsBtnAction:(id)sender {
//    
//    installedProductsView._isGettingData = YES;
//    
//    installedProductsView.userId = userId;
//
//    [self.navigationController pushViewController:installedProductsView animated:YES];
//}


- (IBAction)logoutBtnAction:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Logout ?"
                                                        message:nil delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Yes",@"No",nil];
    [alertView show];

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


@end
