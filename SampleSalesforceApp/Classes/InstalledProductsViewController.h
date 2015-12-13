//
//  InstalledProductsViewController.h
//  FS360
//
//  Created by BiznusSoft on 7/31/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

@interface InstalledProductsViewController : UIViewController<SFRestDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>
{
    
    NSString * userId;

    
    IBOutlet UIScrollView *backgroundScrollView;
    
    IBOutlet UIView *availableModDetailsView;
    
    IBOutlet UILabel *availableModDetailsLabel;
    
    IBOutlet UIButton *availableModCheckBoxButton;
    
    IBOutlet UIButton *installedDateButton;
    
    IBOutlet UIView *timeIntervalView;
    
    IBOutlet UIButton *timeIntervalBtn;

    
    IBOutlet UITableView *leftMenuTableView;
    IBOutlet UITableView *installedProductsTableView;
    IBOutlet UIView *installedProductsDetailsView;
    
    IBOutlet UITableView *installedModTableView;
    IBOutlet UISegmentedControl *installedModSegmentControl;
   
    IBOutlet UIView *datePickerView;
    
    IBOutlet UIDatePicker *datePicker;
    
    
    // Installed Mod Detais
    
    IBOutlet UIView *InstalledModDetaisView;
    IBOutlet UILabel *installedModNameLabel;
    
    IBOutlet UIButton *installedModInstallButton;
    
    
    IBOutlet UILabel *installedModInstalledDateLabel;
    
    IBOutlet UILabel *installedModModNameLabel;
    
    
    IBOutlet UILabel *installedModModNumberLabel;
    
    
    IBOutlet UIButton *installedModModRequiredButton;
    IBOutlet UILabel *installedModDocTitleLabel;
    
    NSMutableArray * WOInstalledModArray;
    NSMutableArray * WOAvailableModArray;

    int installedModCount,installedModCount1,availableModCount,availableModCount1;

    
    BOOL _isShowingMenu;
    
    BOOL _isPushing;
    
    BOOL _isGettingData;

    NSMutableArray * installedProductsArray;
    NSMutableArray * installedModsArray;
    NSMutableArray * availableModsArray;
  
    NSMutableArray * tableDataArray;

    
    
    // Installed Products Info
    
    IBOutlet UILabel *accountNameLabel;
    
    IBOutlet UILabel *serialNumberLabel;

    IBOutlet UILabel *assetNameLabel;
    
    IBOutlet UILabel *assetUniqueFieldLabel;
    
    IBOutlet UILabel *latittudeLabel;
    
    IBOutlet UILabel *longitudeLabel;
    
    IBOutlet MKMapView *installedProductsMapView;
    
}

@property (nonatomic, strong) NSString * userId;

@property(nonatomic,assign) NSString * installedProductsId;
@property(nonatomic,assign) NSString * installedProductsName;

@property(nonatomic,assign)BOOL _isShowingMenu;

@property(nonatomic,assign)BOOL _isPushing;

@property(nonatomic,assign) BOOL _isGettingData;


@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)installedModSegmentControlAction:(id)sender;

- (IBAction)availableModCloseBtnAction:(id)sender;
- (IBAction)availableModCheckBoxBtnAction:(id)sender;

- (IBAction)installedDateBtnAction:(id)sender;
- (IBAction)availableModSubmitBtnAction:(id)sender;

- (IBAction)datePickerSetBtnAction:(id)sender;
- (IBAction)datePickerCancelBtnAction:(id)sender;

- (IBAction)updateLocationBtnAction:(id)sender;

- (IBAction)timeIntervalBtnAction:(id)sender;

- (IBAction)setTimeIntervalBtnAction:(id)sender;



//@property (nonatomic, strong) IBOutlet UITableView *installedProductsTableView;

@end
