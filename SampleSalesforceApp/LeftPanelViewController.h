//
//  LeftPanelViewController.h
//  SlideMenuApp
//
//  Created by keshava on 3/11/15.
//  Copyright (c) 2015 keshava. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftPanelViewController <NSObject>

@end

@class CenterViewController, AccountsViewController,ServiceOrdersViewController,InstalledProductsViewController,EscalationsViewController;

@interface LeftPanelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * tableDataArray;
    
    ServiceOrdersViewController * serviceOrdersView;
    InstalledProductsViewController * installedProductsView;
    EscalationsViewController * escalationView;
}

@property(nonatomic,strong)CenterViewController *container;
@property (nonatomic, assign) id<LeftPanelViewController> delegate;

//@property (nonatomic, strong) IBOutlet UITableView *leftTableView;

@end
