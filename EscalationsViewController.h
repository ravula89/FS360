//
//  EscalationsViewController.h
//  FS360
//
//  Created by BiznusSoft on 9/9/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceOrdersViewController.h"
#import "InitialViewController.h"
#import "ASActionView.h"

@class ServiceOrdersViewController;
@interface EscalationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate>
{
    NSString * userId;
    
    BOOL _isShowingMenu;
    
    NSMutableArray * escalationsArray;
    NSMutableArray * WOEscalationsArray;
    
    IBOutlet UITableView *leftMenuTableView;
    
    
    IBOutlet UIView *timeIntervalView;
    
    IBOutlet UIButton *timeIntervalBtn;

    // Escalations Details
   

    IBOutlet UIScrollView *backgroundScrollView;
    
    IBOutlet UITableView *escalationsTableView;
    
    
    IBOutlet UILabel *escalationNameLabel;
    IBOutlet UILabel *accountLabel;
    
    IBOutlet UILabel *caseLabel;
    IBOutlet UILabel *assetLabel;
    
    IBOutlet UILabel *installedProductLabel;
    
    IBOutlet UILabel *workOrderLabel;
    
    IBOutlet UILabel *siteLabel;
    
    IBOutlet UILabel *typeLabel;
    
    IBOutlet UILabel *escalationOwnerLabel;
    
    IBOutlet UILabel *partNumberLabel;
    
    IBOutlet UILabel *caseOwnerLabel;
    
    IBOutlet UILabel *statusLabel;
    
    IBOutlet UILabel *FSELabel;
    
    IBOutlet UILabel *casePriorityLabel;
    
    IBOutlet UILabel *problemDescriptionLabel;
    
    IBOutlet UILabel *escalationSymptomsLabel;
    
    IBOutlet UILabel *endDateLabel;
    
    IBOutlet UILabel *timeOpenLabel;
    
    IBOutlet UILabel *serialNumberLabel;
    
    IBOutlet UILabel *escalationResolutionLabel;
    
    
    IBOutlet UIView *newEscalationsView;
    
    // New Escalations Details

    IBOutlet UIScrollView *newEscalationScrollview;
    
    
    IBOutlet UITextField *caseField;
    
    IBOutlet UITextField *accountField;
    
    IBOutlet UITextField *assetField;
    
    IBOutlet UITextField *installedProductField;
    
    IBOutlet UITextField *casePriorityField;
    
    IBOutlet UITextField *caseOwnerField;
    
    IBOutlet UIButton *statusButton;
    IBOutlet UIButton *typeButton;
    IBOutlet UIButton *escalationSymptomsButton;
    IBOutlet UITextField *problemDescriptionField;
    
    IBOutlet UITextField *workOrderField;
    
    
    
    
    __weak IBOutlet UILabel *escalationNotFoundLabel;
    UIPickerView *escalationPickerView;
    NSMutableArray *pickerStatusArray;
    NSMutableArray *pickerTypeArray;
    NSMutableArray *pickerSymptomsArray;

    NSMutableArray * tableDataArray;

    
    ASActionView * actionView;
    NSString *pickerTitle;
    

    
}


@property (nonatomic, strong) NSString * userId;


@property (nonatomic, retain) UIPickerView *escalationPickerView;
@property (nonatomic, retain)NSMutableArray *pickerStatusArray;
@property (nonatomic, retain)NSMutableArray *pickerTypeArray;
@property (nonatomic, retain)NSMutableArray *pickerSymptomsArray;

@property(nonatomic,assign)BOOL _isShowingMenu;

@property(nonatomic,assign) NSString * workOrderId;
@property(nonatomic,assign) NSString * workOrderName;



- (IBAction)escalationCancelBtnACtion:(id)sender;

- (IBAction)newEscalationSaveBtnAction:(id)sender;

- (IBAction)newEscalationCancelBtnACtion:(id)sender;


- (IBAction)statusBtnAction:(id)sender;

- (IBAction)typeBtnAction:(id)sender;

- (IBAction)escalationSymptomsBtnAction:(id)sender;

- (IBAction)timeIntervalBtnAction:(id)sender;

- (IBAction)setTimeIntervalBtnAction:(id)sender;

@end
