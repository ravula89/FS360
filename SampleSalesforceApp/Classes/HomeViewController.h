//
//  HomeViewController.h
//  FS360
//
//  Created by BiznusSoft on 7/31/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

#import "ServiceOrdersViewController.h"
#import "InstalledProductsViewController.h"


#import "LeftPanelViewController.h"


@interface HomeViewController : UIViewController<SFRestDelegate>

- (IBAction)serviceOrdersBtnAction:(id)sender;



- (IBAction)logoutBtnAction:(id)sender;
//- (IBAction)installedProductsBtnAction:(id)sender;


@end
