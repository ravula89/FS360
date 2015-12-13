//
//  ServiceOrdersViewController.m
//  FS360
//
//  Created by BiznusSoft on 7/31/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import "ServiceOrdersViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "Base64.h"
#import "DBManager.h"
#import "SFUtils.h"
#import "SignatureViewController.h"
#import "AppDelegate.h"
#import "SFSDKReachability.h"
#import "SFAuthenticationManager.h"
#import "FSWorkOrder.h"
#import "OrderViewDetails.h"
#import "ActivitiesTableViewCell.h"

#define kActivitiesTableViewCellIdentifier @"ActivitiesTableViewCellIdentifier"

@interface ServiceOrdersViewController () <SignatureViewControllerDelegate , FSAddPartViewDelegate,FSAddNewPartViewDelegate>
{
    InstalledProductsViewController * installedProductsView;
    EscalationsViewController * escalationView;
    LeftPanelViewController * leftView;
    SignatureViewController * signatureView;
    
    BOOL success;
    BOOL serviceChecked;
    BOOL travelChecked;
    
    UILabel * nameLabel;
    UILabel * timeDurationLabel;
    UILabel * casestatuslabel;
    UIButton * activateButton;
    
    
    UIImageView * imageView;
    NSMutableArray * captureImagesArray;
    
    NSArray *records;
    NSArray * activityRecordsArray;
    NSArray * reqMeterialRecordsArray;
    NSArray * RMARecordsArray;
    NSArray * assignedTechnicianRecordsArray;
    NSArray * ordersRecordsArray;
    NSArray * otherPartsUsedRecordsArray;
    NSArray * timeRecordsArray;
    NSArray * expensesRecordsArray;
    
    int activitiesCount ;
    int reqMeterialsCount ;
    int timeCount, resultsCount, partsUsedCount, orderProductsCount;
    
    int selectedRow;
    int selectedActivityRow, selectedOrderRow;
    int selectedServiceRow;
    int selectedServiceResultRow;
    
    BOOL _isEditing;
    BOOL caseInfo;
    BOOL addressInfo;
    
    BOOL expensesOverCheckboxSelected, newOrderCheckboxSelected;
    
    BOOL _closeWOInfo,_closeWOClosureInfo,_closeWOBillableInfo,_closeWOPrinterInfo;
    
    BOOL _isSync,_isSync1;
    BOOL _isOfflineWO,_isOfflineTravel,_isOfflineService;
    BOOL _isActivitiesSelected,_isOrdersSelected;
    
    UILabel *syncTimeLabel;
    
    NSDateFormatter *formatter;
    NSString *startServiceString;
    NSString *startTravelString;
    NSString *endTravelString;
    NSString *endServiceString;

    NSData * encodeImage;
    NSData * encodeSignature;
    NSDictionary * imageDict;
    NSDictionary * signatureDict;
    
    NSDictionary * dict;
    
    NSDictionary * productsDict;
    NSDictionary * activitiesDict;
    NSDictionary * activitiesDict1;
    NSString * serviceAndTravelString;
    
    NSString * technicianId;
    NSString * pricebookId;
    NSInteger tempPartUsedValue;
    NSInteger tempNewPartUsedValue;
    FSWorkOrder *workOrder;
}

@end

@implementation ServiceOrdersViewController
@synthesize captureImageView,captureSignatureView;
@synthesize _isShowingMenu,_isPushing,_isGettingData,userId;
@synthesize lastContactPoint1, lastContactPoint2, currentPoint;
@synthesize imageFrame;
@synthesize fingerMoved;
@synthesize navbarHeight;
@synthesize activityNameSelectPickerView,pickerActionTakenArray,pickerProductArray,pickerModelArray,pickerSymptomArray,pickerAreaUnitsArray;
@synthesize pickerNewOrderPriorityArray,pickerNewOrderShippingMethodArray,pickerNewServiceResultsProductArray,pickerNewServiceResultsSystemsArray,pickerNewServiceResultsSubSystemArray,pickerNewServiceResultsRootCauseArray;
@synthesize addParts;
@synthesize addNewParts;
// Cleaning Database and Execute Salesforce Query

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    selectedOrderRow = -1;
   
    NSLog(@"techId:%@",userId);
    [activitiesTableView registerNib:[UINib nibWithNibName:@"ActivitiesTableViewCell"  bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kActivitiesTableViewCellIdentifier];
    
    addParts = [[FSAddPartView alloc]init];
    addNewParts = [[FSAddNewPartView alloc]init];
    tableDataArray = [[NSMutableArray alloc]initWithObjects:@"Work Orders",@"Installed Products",@"Logout", nil];
    
    serviceOrderScrollView.contentSize = CGSizeMake(0, 1000);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    _isShowingMenu = NO;
    serviceChecked = NO;
    travelChecked = NO;
    
   
//    activitiesTableView.frame = CGRectMake(750, 115, 270, 200);
    
    //    [[DBManager getSharedInstance]executeQuery];
    //
    //    [[DBManager getSharedInstance]deleteActivitiesDB];
    //
    //    [[DBManager getSharedInstance]deleteOrderProductsDB];
    //
    //    [[DBManager getSharedInstance]deleteServiceResultsDB];
    //
    //    [[DBManager getSharedInstance]deleteOtherPartsUsedDB];
    //
    //    [[DBManager getSharedInstance]deleteRMADB];
    //
    //    [[DBManager getSharedInstance]deletegetTimeDB];
    //
    //    [[DBManager getSharedInstance]deleteAttachmentsDB];
    //
    //    technicianIdArray = [[DBManager getSharedInstance]getTechnicianDetails];
    
    //    serviceOrdersArray = [[DBManager getSharedInstance]readInformationFromDatabase];
    //
    //    activitiesArray = [[DBManager getSharedInstance]getActivities];
    //
    //    serviceResultsArray = [[DBManager getSharedInstance]getServiceResultsDetails];
    //
    //    otherPartsUsedArray = [[DBManager getSharedInstance] getOtherPartsUsedDetails];
    //
    //    orderProductsArray = [[DBManager getSharedInstance]getOrderProducts];
    //
    //    RMAArray = [[DBManager getSharedInstance]getRMADetails];
    //
    //    timeArray = [[DBManager getSharedInstance]getTime];
    //
    //    attachmentsArray = [[DBManager getSharedInstance]getAttachments];
    //
    //
    //    if (!_isPushing && serviceOrdersArray .count == 0) {
    
    //        NSString *theRequest = [NSString stringWithFormat:@"Select id,name,(Select id,name from FCOnnect__Group_Members__r) from FConnect__Employees__c where FConnect__SF_User__c= '%@'", userId];
    //
    //        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:theRequest];
    //
    //        [[SFRestAPI sharedInstance] send:request delegate:self];
    //
    //    }
    //    if (_isPushing && serviceOrdersArray .count > 0) {
    //
    //                [self showingServiceOrderDetails];
    //
    //    }
    //
    //    if (!_isPushing && _isSync) {
    //
    //        _isGettingData = NO;
    //
    ////        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    //        [[DBManager getSharedInstance]executeQuery];
    //
    //        [[DBManager getSharedInstance]deleteActivitiesDB];
    //
    //        [[DBManager getSharedInstance]deleteOrderProductsDB];
    //
    //        [[DBManager getSharedInstance]deleteServiceResultsDB];
    //
    //        [[DBManager getSharedInstance]deleteOtherPartsUsedDB];
    //
    //        [[DBManager getSharedInstance]deleteRMADB];
    //
    //        [[DBManager getSharedInstance]deletegetTimeDB];
    //
    //        [[DBManager getSharedInstance]deleteAttachmentsDB];
    //
    //        NSString *theRequest = [NSString stringWithFormat:@"Select id,name,(Select id,name from FCOnnect__Group_Members__r) from FConnect__Employees__c where FConnect__SF_User__c= '%@'", userId];
    //
    //        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:theRequest];
    //
    //        [[SFRestAPI sharedInstance] send:request delegate:self];
    //
    //
    //
    //}
    
    _isEditing = NO;
    _isSync = NO;
    
    installedProductsView = [[InstalledProductsViewController alloc]init];
    
    escalationView = [[EscalationsViewController alloc]init];
    
    leftView = [[LeftPanelViewController alloc]init];
    
    signatureView = [[SignatureViewController alloc]init];
    
    captureImagesArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
 
}


-(void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"orderArray:%@",orderArray);

    
    formatter=[[NSDateFormatter alloc] init];

    [self activitiesBtnAction:nil];
    
    [self.timeAndServiceResultsSegmentControl setHidden:YES];
    
    serviceOrderScrollView.contentSize = CGSizeMake(0, 1000);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_isSync) {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
          //  syncTimeLabel.text = appDelegate.myString;
//            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"dd/MM/yyyy HH:mm aa";
            NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
            syncTimeLabel.text =stringFromDate;
            
            
        }
    });
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        
        //        backgroundScrollView.contentSize = CGSizeMake(1200, 1200);
    }
    
    //    [[DBManager getSharedInstance]executeQuery];
    //
    //    [[DBManager getSharedInstance]deleteActivitiesDB];
    //
    //    [[DBManager getSharedInstance]deleteOrderProductsDB];
    //
    //    [[DBManager getSharedInstance]deleteServiceResultsDB];
    //
    //    [[DBManager getSharedInstance]deleteOtherPartsUsedDB];
    //
    //    [[DBManager getSharedInstance]deleteRMADB];
    //
    //    [[DBManager getSharedInstance]deletegetTimeDB];
    //
    //    [[DBManager getSharedInstance]deleteAttachmentsDB];
    //
    //    serviceOrdersArray = nil;
    
    //    [serviceOrdersArray removeAllObjects];
    
    //
    //    if(_isSync)
    //    {
    //
    //        serviceOrdersArray = [[NSMutableArray alloc]init];
    //        activitiesArray = [[NSMutableArray alloc]init];
    //        orderProductsArray = [[NSMutableArray alloc]init];
    //        serviceResultsArray = [[NSMutableArray alloc]init];
    //        otherPartsUsedArray = [[NSMutableArray alloc]init];
    //        RMAArray = [[NSMutableArray alloc]init];
    //        timeArray = [[NSMutableArray alloc]init];
    //        attachmentsArray = [[NSMutableArray alloc]init];
    //
    //    }
    
    serviceOrdersArray = [[DBManager getSharedInstance]readInformationFromDatabase];
    
    activitiesArray = [[DBManager getSharedInstance]getActivities];
    
    orderArray = [[DBManager getSharedInstance]getOrderDetails];

    
    serviceResultsArray = [[DBManager getSharedInstance]getServiceResultsDetails];
    
    otherPartsUsedArray = [[DBManager getSharedInstance] getOtherPartsUsedDetails];
    
    pricebookEntryArray = [[DBManager getSharedInstance] getPricebookEntryDetails];
    
    assignedTechnicianArray = [[DBManager getSharedInstance]getAssignedTechnicianDetails];

    orderProductsArray = [[DBManager getSharedInstance]getOrderProducts];
    
    orderArray = [[DBManager getSharedInstance]getOrderDetails];

    RMAArray = [[DBManager getSharedInstance]getRMADetails];
    
    timeArray = [[DBManager getSharedInstance]getTime];
    
    attachmentsArray = [[DBManager getSharedInstance]getAttachments];
    
    
    if (!_isPushing && serviceOrdersArray .count == 0) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *theRequest = [NSString stringWithFormat:@"Select id,name,(Select id,name from FCOnnect__Group_Members__r) from FConnect__Employees__c where FConnect__SF_User__c= '%@'", userId];
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:theRequest];
        
        [[SFRestAPI sharedInstance] send:request delegate:self];
        
        //        serviceOrdersArray = [[DBManager getSharedInstance]readInformationFromDatabase];
        //
        //        activitiesArray = [[DBManager getSharedInstance]getActivities];
        //
        //        serviceResultsArray = [[DBManager getSharedInstance]getServiceResultsDetails];
        //
        //        otherPartsUsedArray = [[DBManager getSharedInstance] getOtherPartsUsedDetails];
        //
        //        orderProductsArray = [[DBManager getSharedInstance]getOrderProducts];
        //
        //        RMAArray = [[DBManager getSharedInstance]getRMADetails];
        //
        //        timeArray = [[DBManager getSharedInstance]getTime];
        //
        //        attachmentsArray = [[DBManager getSharedInstance]getAttachments];
        
        //    expensesArray = [[DBManager getSharedInstance]getTime];
        
    }
    
    
    if (_isPushing && serviceOrdersArray .count > 0) {
        
        [self showingServiceOrderDetails];
        
        
    }
    
    
    
    if (!_isPushing && _isSync) {
        
        serviceOrdersArray = [[NSMutableArray alloc]init];
        activitiesArray = [[NSMutableArray alloc]init];
        orderProductsArray = [[NSMutableArray alloc]init];
        serviceResultsArray = [[NSMutableArray alloc]init];
        otherPartsUsedArray = [[NSMutableArray alloc]init];
        pricebookEntryArray = [[NSMutableArray alloc]init];
        orderArray = [[NSMutableArray alloc]init];
        RMAArray = [[NSMutableArray alloc]init];
        timeArray = [[NSMutableArray alloc]init];
        attachmentsArray = [[NSMutableArray alloc]init];
        
        _isGettingData = NO;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[DBManager getSharedInstance]executeQuery];
        
        [[DBManager getSharedInstance]deleteActivitiesDB];
        
        [[DBManager getSharedInstance]deleteOrderProductsDB];
        
        [[DBManager getSharedInstance]deleteOrderDB];

        [[DBManager getSharedInstance]deleteServiceResultsDB];
        
        [[DBManager getSharedInstance]deleteOtherPartsUsedDB];
        
        [[DBManager getSharedInstance]deleteRMADB];
        
        [[DBManager getSharedInstance]deletegetTimeDB];
        
        [[DBManager getSharedInstance]deleteAttachmentsDB];
        
        [[DBManager getSharedInstance]deleteAssignedTechnicianDB];
      
        NSString *theRequest = [NSString stringWithFormat:@"Select id,name,(Select id,name from FCOnnect__Group_Members__r) from FConnect__Employees__c where FConnect__SF_User__c= '%@'", userId];
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:theRequest];
        
        [[SFRestAPI sharedInstance] send:request delegate:self];
        
    }
    
    
    [serviceTableView reloadData];
    [activitiesTableView reloadData];
    [timeAndExpensesTableView reloadData];
    
    [self ShowNavigationBar];
    
    // Test Here:
    
//    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy HH:mm aa";
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    syncTimeLabel.text =stringFromDate;

    
    
    [timeIntervalBtn setTitle:@"15 min" forState:UIControlStateNormal];
    
}

// Adding Navigationbar Buttons

-(void)ShowNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    
//    CGRect frame = CGRectMake(0, 10, 180, 30);
//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:frame];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    titleLabel.text = @"Work Orders";
//    titleLabel.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = titleLabel;
//    
//    self.title = @"Work Orders";
//    
   //self.navigationItem.hidesBackButton = YES;
    
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    menuBtn.frame = CGRectMake(0, 0, 32, 32);
    menuBtn.showsTouchWhenHighlighted=YES;
    [menuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    [arrLeftBarItems addObject:barButtonItem];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setImage:[UIImage imageNamed:@"home_button.png"] forState:UIControlStateNormal];
    homeBtn.frame = CGRectMake(0, 0, 32, 32);
    homeBtn.showsTouchWhenHighlighted=YES;
    [homeBtn addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    [arrLeftBarItems addObject:barButtonItem2];
    
    UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,70)];
    workLabel.text = @"Work Orders";
    workLabel.textColor = [UIColor whiteColor];
    workLabel.font = [UIFont boldSystemFontOfSize:18.0];
    workLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:workLabel];
    [arrLeftBarItems addObject:barButtonItem3];
    
//    CGRect frame = CGRectMake(0, 10, 180, 30);
//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:frame];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    titleLabel.text = @"Work Orders";
//    titleLabel.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = titleLabel;
//    
//    self.title = @"Work Orders";
//    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
//    [arrLeftBarItems addObject:titleLabel];
    self.navigationItem.leftBarButtonItems=arrLeftBarItems;
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,40,30)];
    emptyLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn1 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel];
    [arrRightBarItems addObject:rightBarBtn1];
    
    UIButton * setTimeIntervalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setTimeIntervalButton setImage:[UIImage imageNamed:@"timeSync.png.jpg"] forState:UIControlStateNormal];
    setTimeIntervalButton.frame = CGRectMake(100, 0, 32, 32);
    setTimeIntervalButton.showsTouchWhenHighlighted=YES;
    [setTimeIntervalButton addTarget:self action:@selector(timeIntervalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:setTimeIntervalButton];
    [arrRightBarItems addObject:rightBarBtn2];
    
    UILabel *emptyLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,40,30)];
    emptyLabel1.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn3 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel1];
    [arrRightBarItems addObject:rightBarBtn3];
    
    UIButton *productsRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [productsRefreshBtn setImage:[UIImage imageNamed:@"download.png.jpg"] forState:UIControlStateNormal];
    productsRefreshBtn.frame = CGRectMake(0,0,30, 30);
    productsRefreshBtn.showsTouchWhenHighlighted=YES;
    [productsRefreshBtn addTarget:self action:@selector(refreshButtonAction1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn4 = [[UIBarButtonItem alloc] initWithCustomView:productsRefreshBtn];
    [arrRightBarItems addObject:rightBarBtn4];
    
    
    UILabel *emptyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,30)];
    emptyLabel2.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn5 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel2];
    [arrRightBarItems addObject:rightBarBtn5];
    
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"normalSync.png.jpg"] forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(0, 0, 30, 30);
    refreshBtn.showsTouchWhenHighlighted=YES;
    [refreshBtn addTarget:self action:@selector(refreshButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn6 = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    [arrRightBarItems addObject:rightBarBtn6];
    
    
    UILabel *emptyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,30)];
    emptyLabel3.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn7 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel3];
    [arrRightBarItems addObject:rightBarBtn7];
    
    
    
    syncTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,115,30)];
    syncTimeLabel.textColor = [UIColor whiteColor];
    syncTimeLabel.font = [UIFont fontWithName:@"Arial" size:12];
    UIBarButtonItem *rightBarBtn8 = [[UIBarButtonItem alloc] initWithCustomView:syncTimeLabel];
    [arrRightBarItems addObject:rightBarBtn8];
    
    UILabel *syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,65,30)];
    syncLabel.text = @"Last Sync:";
    syncLabel.textColor = [UIColor whiteColor];
    syncLabel.font = [UIFont fontWithName:@"Arial" size:12];
    UIBarButtonItem *rightBarBtn9 = [[UIBarButtonItem alloc] initWithCustomView:syncLabel];
    [arrRightBarItems addObject:rightBarBtn9];
    
    UILabel *FS360Label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,75,30)];
    FS360Label.text = @"FS360Admin,";
    FS360Label.textColor = [UIColor whiteColor];
    FS360Label.font = [UIFont fontWithName:@"Arial" size:12];
    UIBarButtonItem *rightBarBtn10 = [[UIBarButtonItem alloc] initWithCustomView:FS360Label];
    [arrRightBarItems addObject:rightBarBtn10];
    
    UILabel *emptyLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,30)];
    emptyLabel3.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn11 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel4];
    [arrRightBarItems addObject:rightBarBtn11];
    
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    
}


// Going to HomeViewController

-(void)homeButtonAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Showing Timeinterval

-(void)timeIntervalButtonAction:(id)sender {
    
    [timeIntervalView setHidden:NO];
    
}


-(void)callWorkOrderRequest {
    
    NSString * technician = [technicianIdArray objectAtIndex:0];
    
    NSLog(@"%@",technician);
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"TechnicianId"];
    
    NSLog(@"%@",savedValue);
    
    NSString *theRequest = [NSString stringWithFormat:@"Select Id, Name, FConnect__latitude__c, FConnect__longitude__c, Android_Id__c, FConnect__Account_Name__c, FConnect__Account__c,  Case_Name__c, ContactName__c, FConnect__Site_Name__c,  FConnect__Bill_To_Address__c, contact_Phone__c, OwnerId, RecordTypeId, FConnect__Priority__c, FConnect__Status__c, FConnect__Initial_Failure_Codes__c, Contact__c, FConnect__Problem_Description__c, FConnect__Problem__c, Contact_Email__c, FConnect__Installed_Product__c, CaseStatus__c, Case__c, casePriority__c, Owner__c, Regional_Coordinator__c, Symptom__c, Subject__c, Serial_Number__c, Product__c, Severity__c, Model_Item__c, CaseDescription__c, SAP_Sold_To_Bill_To_AccountText__c, Service_Type__c, Primary_Address__c, SAP_Bill_To_Address__c, Sub_Region__c, Asset__c, FConnect__Billable__c, Billing_Status__c, Action_Taken__c, Latitude__c, Longitude__c,  Expenses_over_50__c, AreaPrinted__c, AreaUnit__c, InkUsage__c, PrintTime__c, (SELECT Id, Name, Activity_Name__c, FConnect__Activity__c, FConnect__Priority__c, FConnect__Actual_Duration_HH_MM__c, FConnect__Estimated_Duration__c, FConnect__Planned_End_Date_Time__c, FConnect__Planned_Start_DateTime__c, FConnect__Billable__c, Android_Id__c, FConnect__Service_Order__c FROM FConnect__Activities__r), (SELECT Id, Priority__c, ShippingMethod__c, PrinterDown__c, Description, Send_to_SAP__c, Error_Message__c, OrderNumber, AccountId, Asset_del__c, Case__c, ShipToContactId, Work_Order__c, EffectiveDate, Status, Pricebook2Id, Android_Id__c FROM Orders__r), (select Id, Part_Name__c, OrderId, PricebookEntryId, Work_Order__c, Quantity, Unused_Quantity__c, Used_Quantity__c, Material_Part_Number__c,  UnitPrice,  Android_Id__c from Order_Products__r), (select Id, Order_Product__c, Part_Number__c, RMA_Required__c, RMA_Tracking_Number__c, Description__c, Quantity__c, Work_Order__c from RMA__r), (select id,name, Technician__c, SF_User_ID__c, Estimated_Start_Date__c, Estimated_End_Date__c FROM Assigned_Technician__r ) FROM FConnect__Service_Order__c  where (CaseStatus__c!='99 - Closed' OR  CaseStatus__c!='Closed – Pending Manager Approval') and id IN (select work_order__c from Assigned_Technician__c where Technician__C= '%@')",savedValue];
    
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:theRequest];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}


#pragma mark - UIActionSheetDelegate

// Setting Time Interval

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"15 min"]) {
        
        [timeIntervalBtn setTitle:@"15 min" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"30 min"]) {
        
        [timeIntervalBtn setTitle:@"30 min" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"1 hour"]) {
        
        [timeIntervalBtn setTitle:@"1 hour" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"3 hours"]) {
        
        [timeIntervalBtn setTitle:@"3 hours" forState:UIControlStateNormal];
    }
    
}

// Updated data Pushing to Salesforce Server

-(void)refreshButtonAction:(id)sender {
    
    filteredArray = nil;
    
    _isSync = YES;
    _isPushing = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_isOfflineWO) {
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineCloseWOData"]) {
                
                NSArray *offlineArray =  [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineCloseWOData"];
                
                for (NSDictionary *offlineDict in offlineArray) {
                    
                    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"FConnect__Service_Order__c" objectId:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"] fields:offlineDict];
                    [[SFRestAPI sharedInstance] send:request delegate:self];
                }
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OfflineCloseWOData"];
                
            }
            
        }
        
        if (_isOfflineTravel) {
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineTravelData"]) {
                
                NSArray *offlineArray =  [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineTravelData"];
                
                for (NSDictionary *offlineDict in offlineArray) {
                    
                    SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"FConnect__Time__c" fields:offlineDict];
                    
                    [[SFRestAPI sharedInstance] send:request delegate:self];
                }
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OfflineTravelData"];
                
            }

        }

        if (_isOfflineService) {
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineServiceData"]) {
                
                NSArray *offlineArray =  [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineServiceData"];
                
                for (NSDictionary *offlineDict in offlineArray) {
                    
                    SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"FConnect__Time__c" fields:offlineDict];
                    
                    [[SFRestAPI sharedInstance] send:request delegate:self];
                }
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OfflineServiceData"];
                
            }
            
            
        }
        
        
        //        NSString *imageString = [encodeImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //
        //        NSString *signatureString = [encodeSignature base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //
        //        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] != SFSDKReachabilityNotReachable) {
        //
        //            if (imageString.length != 0) {
        //
        //                imageDict = @{ @"ParentId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"], @"Name":@"image.png", @"Body":imageString };
        //
        //                SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Attachment" fields:imageDict];
        //
        //                [[SFRestAPI sharedInstance] send:request delegate:self];
        //            }
        //
        //            if (signatureString.length != 0) {
        //                signatureDict =  @{ @"ParentId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"], @"Name":@"sign.png", @"Body":signatureString };
        //                SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Attachment" fields:signatureDict];
        //
        //                [[SFRestAPI sharedInstance] send:request delegate:self];
        //            }
        //
        //        }
        //
        //        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == SFSDKReachabilityNotReachable) {
        //
        //            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"]) {
        //
        //                NSMutableArray *array = [[NSMutableArray alloc] init];
        //
        //                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"] isKindOfClass:[NSArray class]]) {
        //
        //                    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"];
        //
        //                    [array addObjectsFromArray:dataArray];
        //
        //                    if (imageString.length != 0) {
        //
        //                    [array addObject:imageDict];
        //
        //                    }
        //                    if (signatureString.length != 0) {
        //
        //                        [array addObject:signatureDict];
        //
        //                    }
        //
        //                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"OfflineData"];
        //                }
        //
        //            } else {
        //
        //                if (imageString.length != 0) {
        //
        //                    [[NSUserDefaults standardUserDefaults] setObject:@[imageDict] forKey:@"OfflineData"];
        //                }
        //
        //                if (signatureString.length != 0) {
        //
        //                [[NSUserDefaults standardUserDefaults] setObject:@[signatureDict] forKey:@"OfflineData"];
        //                }
        //            }
        //
        //            [[NSUserDefaults standardUserDefaults] synchronize];
        //        }
        //
        ////        NSData* decodeImage = [Base64 decode:imageString ];;
        ////        captureImageView.image = [UIImage imageWithData:decodeImage];
        ////        NSData* decodeSignature = [Base64 decode:imageString ];;
        ////        captureSignatureView.image = [UIImage imageWithData:decodeSignature];
        //
        [self viewWillAppear:YES];
        //
    });
    
    
//    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy HH:mm aa";
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    syncTimeLabel.text =stringFromDate;
    
}

-(void)refreshButtonAction1:(id)sender {
    
    _isSync1 = YES;
    _isPushing = NO;
    
    //MB Progress Added Here:
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         dispatch_async(dispatch_get_main_queue(), ^{
        [self callPricebookIdService];
        //[self viewWillAppear:YES];
    });
//    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy HH:mm aa";
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    syncTimeLabel.text =stringFromDate;

}

// Showing Menu

-(void)showMenu {
    
    if (_isShowingMenu) {
        
        _isShowingMenu = NO;
        
        [leftMenuTableView setHidden:YES];
        
        serviceTableView.frame = CGRectMake(0, 65, 300, 700);
        serviceOrderScrollView.frame = CGRectMake(300, 65, 450, 700);
        self.segmentedControl.frame = CGRectMake(750, 80, 250, 29);
        activitiesTableView.frame = CGRectMake(750, 115, 270, 200);
        timeLabel.frame = CGRectMake(750, 315, 300, 30);
        self.timeAndServiceResultsSegmentControl.frame = CGRectMake(750, 315, 250, 29);
        
        timeAndExpensesTableView.frame = CGRectMake(750, 355, 270, 300);
        return;
    }
    
    _isShowingMenu = YES;
    [leftMenuTableView setHidden:NO];
    
    serviceTableView.frame = CGRectMake(202, 65, 300, 700);
    serviceOrderScrollView.frame = CGRectMake(502, 65, 450, 700);
    self.segmentedControl.frame = CGRectMake(952, 80, 250, 29);
    activitiesTableView.frame = CGRectMake(952, 115, 270, 200);
    timeLabel.frame = CGRectMake(952, 315, 250, 30);
    self.timeAndServiceResultsSegmentControl.frame = CGRectMake(952, 315, 250, 29);
    
    timeAndExpensesTableView.frame = CGRectMake(952, 355, 270, 300);
    
}

// Showing Time Interval List

//- (IBAction)newServiceOrderBtnAction:(id)sender {

//}

- (IBAction)activitiesBtnAction:(id)sender {
    
    _isActivitiesSelected =  YES;
    _isOrdersSelected = NO;

    NSIndexPath * indexPath;
    
    [newServiceResultsBtn setHidden:YES];
    
    [self activitiesRowClicked:indexPath];
    
//    _activitiesButton.backgroundColor = [UIColor blueColor];
    
//    _ordersButton.backgroundColor = [UIColor brownColor];

    _activitiesButton.backgroundColor = [UIColor colorWithRed:66.0f/255.0f green:172.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    _ordersButton.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:74.0f/255.0f blue:106.0f/255.0f alpha:1.0f];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [newOrderButton setHidden:YES];
        
        activitiesTableView.frame = CGRectMake(750, _ordersButton.frame.size.height+_ordersButton.frame.origin.y, 270, 200);

        [orderProductsView setHidden:YES];
        [newOrderView setHidden:YES];
        
        [timeLabel setHidden:YES];
        [timeAndExpensesTableView setHidden:YES];
        
        [activitiesTableView reloadData];
    });

}


- (IBAction)ordersBtnAction:(id)sender {
    
    activitiesTableView.frame = CGRectMake(750, newOrderButton.frame.size.height+newOrderButton.frame.origin.y, 270, 200);

    _isOrdersSelected = YES;
    
    _isActivitiesSelected =  NO;

    NSIndexPath * indexPath;
    
    [newServiceResultsBtn setHidden:YES];
    
    [self activitiesRowClicked:indexPath];
    
   
//    _ordersButton.backgroundColor = [UIColor blueColor];
//    _activitiesButton.backgroundColor = [UIColor brownColor];

    _ordersButton.backgroundColor = [UIColor colorWithRed:66.0f/255.0f green:172.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    _activitiesButton.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:74.0f/255.0f blue:106.0f/255.0f alpha:1.0f];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [timeLabel setHidden:YES];
        [timeAndExpensesTableView setHidden:YES];
        
        [newOrderButton setHidden:NO];
        
        [activitiesTableView reloadData];
        
    });

}

- (IBAction)timeIntervalBtnAction:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"15 min", @"30 min", @"1 hour", @"3 hours", nil];
    
    [actionSheet showInView:self.view];
    
}


// Updating Salesforce Server with Time Interval

- (IBAction)setTimeIntervalBtnAction:(id)sender {
    
    if ([timeIntervalBtn.titleLabel.text isEqualToString:@"15 min"]) {
        
        [NSTimer scheduledTimerWithTimeInterval:900.0f
                                         target:self
                                       selector:@selector(someMethod:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    
    if ([timeIntervalBtn.titleLabel.text isEqualToString:@"30 min"]) {
        
        [NSTimer scheduledTimerWithTimeInterval:1800.0f
                                         target:self
                                       selector:@selector(someMethod:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    
    if ([timeIntervalBtn.titleLabel.text isEqualToString:@"1 hour"]) {
        
        [NSTimer scheduledTimerWithTimeInterval:3600.0f
                                         target:self
                                       selector:@selector(someMethod:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    
    if ([timeIntervalBtn.titleLabel.text isEqualToString:@"3 hours"]) {
        
        [NSTimer scheduledTimerWithTimeInterval:10800.0f
                                         target:self
                                       selector:@selector(someMethod:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    
    [timeIntervalView setHidden:YES];
    
}


-(void)someMethod:(id)sender {
    
    [self viewDidLoad];
}


- (IBAction)closeWorkOrderBtnAction:(id)sender {
    
    closeWorkOrderScrollView.contentSize = CGSizeMake(0, 1100);
    
    [closeWorkOrderScrollView setHidden:NO];
    
    [serviceOrdersInformationView bringSubviewToFront:closeWorkOrderScrollView];
    
}

// Showing Work Order Products

- (IBAction)closeWOProductBtnAction:(id)sender {
    
    pickerProductArray = [[NSMutableArray alloc] initWithObjects:@"ColorBurst RIP",@"Color Profiler",@"Digital StoreFront",@"EFI Business Intelligence",@"Fiery Applications",@"Fiery Central",@"Fiery Controller",@"Fiery Dashboard",@"Hagen",@"Ink",@"iQuote",@"Jetrion",@"Job Flow",@"Job Master",@"Logic",@"MicroPress",@"Monarch",@"OPS",@"PACE",@"Pace Integrated Products",@"Plant Manager",@"Prinance",@"Printchannel",@"PrintFlow",@"PrintLeader",@"PrintMe",@"PrintSmith",@"PrintStream",@"Prism",@"Prograph",@"Proofing",@"Proteus",@"PSI",@"Radius",@"Self Service (Entrac)",@"SendMe",@"SmartLinc",@"SSA",@"Technique",@"VUTEk",@"Wide Format",@"XF RIP",@"XMPie Standalone",@"Cretaprint",@"PC-Topp",@"Gamsys",@"Graphisoft",@"Lector", nil];
    
    [self showActionViewWithTitle:@"Select Product"];
    
    [actionView setHidden:NO];
    
}

// Showing Work Order Action Taken

- (IBAction)closeWOActionTakenBtnAction:(id)sender {
    
    pickerActionTakenArray = [[NSMutableArray alloc] initWithObjects:@"Aligned / Adjusted",@"Answered question",@"Clarification / Instructions given / User Error",@"Cleaned", @"Customer Resolved",@"Defect issue",@"De-Install",@"Documentation provided",@"Document provided",@"Duplicate Case",@"Escalated to Sales",@"Export - Import",@"Feature Request",@"Feature request / deferred to future release",@"Fixed in Hotfix",@"Fixed in Update",@"Fixed in version release",@"Fix installed",@"Fix provided / advised to install fix package",@"FSE Dispatch/Completed",@"Functions as specified",@"General setup/config",@"Guided/answered customer",@"Information provided",@"Install - No Issues",@"JIRA Issue",@"Latest updates installed",@"N/A - Customer failed to respond",@"N/A - Duplicate Case",@"N/A - Not Valid Case",@"N/A - SPAM",@"New License provided / Rehost",@"None",@"Not able to reproduce",@"Not OUR issue / 3rd party",@"Not supported OS / OS issues",@"Only Using Error",@"Other",@"Parts assistance",@"Parts needed",@"Proposed no fix",@"Provided training (billable)",@"Provided training (non-billable)",@"Provide information on upgrade",@"Redirected to reseller",@"Referred to billing",@"Referred to external party",@"Referred to ISP/IT/3rd Party",@"Referred to OEM/partner",@"Referred to sales",@"Referred to services",@"Referred to support",@"Refund / Credit",@"Reinserted",@"Replaced",@"Resolved",@"Resolved: Customer Actions",@"Resolved: FSE Actions",@"Resolved: FSE Info/Training",@"Resolved: ISE Actions",@"Resolved: ISE Info/Training",@"Resolved: WebEx Diagnosis",@"Resolved with assistance",@"Sales question / forwarded to sales",@"Shipped CDs",@"Sold support agreement",@"Tightened",@"Trained",@"Unclear documentation",@"Unreproducible / no issue / undetermined",@"Unresolved",@"Updated account information",@"Upgrade assistance",@"Uploaded",@"Usability",@"WebEx Scheduled",@"Referred to website",@"Sent an Offer / New Billable Service",@"Visit recommended", nil];
    
    [self showActionViewWithTitle:@"Select Action Taken"];
    
    [actionView setHidden:NO];
    
}

// Showing Work Order Model/Item

- (IBAction)closeWOModelBtnAction:(id)sender {
    
    pickerModelArray = [[NSMutableArray alloc] initWithObjects:@"3M",@"3rd Party Hosted",@"3rd Party HW",@"451",@"Accounting",@"Accounts",@"Accounts Payable",@"Accounts Receivable",@"Address Cleansing",@"Admin Console",@"Administrative",@"Apps",@"Archiving",@"ASP",@"ASP integrated MIS integrated",@"AutoCount",@"Avanti",@"Backup/Recover",@"Balance",@"Bank Rec",@"Bar Code Scanners",@"Basic",@"Batch",@"Bio",@"Business Intelligence",@"Business Rule",@"Calculation Engine",@"Canada Post",@"Canon",@"Canon MicroPress",@"Cards",@"Cash Drawer / Receipt Printer",@"Color Profiler",@"Color Profiler Suite",@"Colorproof eXpress",@"Colorproof for Epson",@"Colorproof XF",@"Command Workstation",@"Company Management",@"Complete Offering",@"Computer Rental",@"Configuration",@"Configurator Issue",@"Connect",@"Connection.Paket",@"Consumables",@"Contract Admin / Invoicing",@"Contract Management",@"Contract Price List",@"Copy/Print – MN4",@"Copy Station",@"Corona",@"Covalent",@"Credit Card Processing",@"CRM",@"Crystal Clear",@"Customer.Connect",@"Customer Management",@"Customer Portal",@"Customization Toolkit",@"Custom Work",@"Dashboard",@"Data Collection",@"DC Simple",@"Designer Edition",@"Designer Edition for HP",@"DHL",@"Digital Store Front",@"DocSend",@"DocSend Pro80",@"DocSend Server",@"DocStream",@"Documentation",@"Document Generation Service",@"DSF",@"Dye-sub Solvent",@"EFI Hosted",@"EFI XFlow",@"eGoods",@"EIS",@"Emailer Service",@"EOD Consolidation",@"ePaceStation",@"EP Cloud",@"EP Fax",@"EP Kiosk",@"EP Laptop",@"EP Manager",@"EP Photo",@"EP Register",@"eProducts",@"EP Server",@"eService",@"Estimating",@"Express",@"Express Interface",@"Express Rater",@"Express Shipper",@"FabriVu 3360",@"Facet RIP",@"FedEx",@"Fiery API",@"Fiery Central",@"Fiery Controller",@"Fiery Dashboard",@"Fiery Dashboard Trial",@"Fiery G210 RIP",@"Fiery Go",@"Fiery JDF Connector",@"Fiery proServer for KIP",@"Fiery proServer for VUTEk",@"Fiery Scan",@"Fiery Vue",@"Fiery XF",@"Fiery XF for Intec",@"Fiery XF for Jetrion",@"Fiery XF for OKI",@"Fiery XF for Rastek",@"Fiery XF for TetraPak",@"Fiery XF for TMS/AB",@"Fiery XF for VUTEk",@"File Issue",@"Fixed Assets",@"Flexera License",@"Flow",@"Focus",@"Foundation",@"Framework",@"Freightlink",@"FSC",@"Fulfillment",@"FXO-File and Job",@"Management",@"G5 USB Reader",@"General",@"General Admin Setup",@"General Ledger",@"Generic Carrier",@"GlobalScan NX",@"GoNet",@"GS2000",@"GS2000LX",@"GS2000LXPro",@"GS2000LX Pro Ultra Drop",@"GS2000Pro",@"GS2000Pro-CP",@"GS2000Pro-TF",@"GS3200",@"GS3250",@"GS3250LX",@"GS3250LXPro",@"GS3250LX Pro Ultra Drop",@"GS3250Pro",@"GS3250Pro-CP",@"GS3250Pro-TF",@"GS3250r",@"GS3250RLX",@"GS5000r",@"GS5500LXr Pro",@"GS5500LXrPro Ultra Drop",@"Gupta SQL-Base",@"H1625",@"H2000 Ultra Drop",@"H650",@"H652",@"H700",@"Hagen OA",@"Hagen PMS",@"Hardware",@"Hazardous",@"Hot Folders",@"HS 100",@"ICE",@"IKON",@"IKON Edox",@"IKON PowerPress",@"Information Console",@"Ink Delivery System",@"Integration",@"Inventory",@"Inventory Admin",@"Inventory Document",@"Generator",@"Inventory Management",@"Inventory Scan",@"Invoice Generation",@"iQ",@"iQ Manager",@"iTechnique",@"Item Templates",@"JDF",@"JDF.Connector",@"JMF Server",@"Job Billing",@"Job Control Center",@"Job Costing",@"Job Flow",@"Job Flow Trial",@"Job History",@"Job Importer",@"Job Master",@"Job Master Trial",@"Job Planning",@"Job Shipments",@"Konica Minolta",@"Konica Minolta",@"MicroPress",@"Kreativ.Connect",@"Kyocera Mita",@"Label",@"LDAP",@"Legacy",@"Licensing",@"Log.Connect",@"Logic",@"Logic LMS",@"Logic SQL",@"LTL",@"M500 Station",@"M500 Station (Cloud)",@"M505 Station",@"M505 Station (Cloud)",@"M510 Station",@"Machine Software",@"Macola",@"Mailing",@"Maintenance",@"Management",@"Manhattan",@"Manifest Information",@"Metrics",@"MiniNet 4C",@"MiniNet 4L",@"Minolta",@"MIS Console",@"Mobile",@"Monarch",@"Multi Currency",@"MyDC",@"Nashuatec (NRG)",@"Networking",@"Not Applicable",@"Not Set",@"Oce",@"Oki",@"Oki SendMe",@"OneFlow",@"OPC Website",@"Order Management",@"OrderWeb Issue",@"Other",@"Outlook Plug-In CRM",@"Pace",@"Pace Connect",@"Pace Visual Product", @"Builder",@"Paper Certification", @"Authority",@"Paper Monitor",@"Payroll",                                                @"Performance",@"Planner",@"Plant Manager",@"Portal",@"Premier",@"Premier Lite",@"Prepress Connector",@"PressVu UV 180/600",@"PressVu UV 200/600",@"PressVu UV 320/400",@"Price List Quoting",@"Prinance",@"Print Electronics",@"Printer",@"PrinterSite Exchange",@"PrinterSite Fulfillment",@"PrinterSite Internal",@"PrintFlow",@"PrintMe Client",@"PrintMe Cloud",@"PrintMe Connect",@"PrintMe EIP",@"PrintMe MEAP",@"PrintMe Mobile",@"PrintMe Mobile Trial",@"PrintMe SDK",@"PrintMe Station",@"PrintMe Terminal –", @"Hospitality Direct",@"PrintMe Terminal –", @"Terminal OEM",@"PrintSmith",@"PrintSmith Report", @"Writer",@"PrintSmith Site",@"PrintSmith Vision",@"PrintStream",@"PrintStream Order",     @"Fulfillment",@"Printy",@"Print Zone",@"Prism",@"Process Shipper",@"Production",@"Production", @"Scheduling",@"Prograph",@"Proofing",@"PSA",@"PSI",@"PSI Flexo",@"Purchase Order",@"Purchasing",@"Purge System",@"Purolator",@"QB Sync",@"QS2 Pro",@"QS3 Pro",@"QS Series",@"R3225",@"Radius",@"Radius Core",@"Radius Estimating",@"Radius Integrations",@"Radius Portal",@"Rates",@"Reports",@"Ricoh/Gestetner/Savin/Lanier",@"Ricoh Family MicroPress",@"Router Optimization",@"RP720",@"Sage 100",@"Sage 300",@"Sage 500",@"Sage X3",@"Sales Enquiries",@"Scheduler",@"Security",@"SeeQuence Compose",@"SeeQuence Impose",@"Self Hosted",@"Self hosted/standalone",@"Self hosted/standalone MIS", @"integrated",@"Seminar",@"SendMe",@"SendMe Server",@"Server",@"Sharp",@"Shipping and Delivery",@"Shop.Connect",@"Single Object Import",@"Site",@"Site Readiness", @"Preparation",@"SmartWare",@"Software",@"Solo",@"Solvent",@"SpeeDee",@"SSAC",@"Stratos i.Point",@"System",@"System Down",@"System Tools",@"T1000",@"T600",@"T660",@"Technical",@"ToolTips",@"Toshiba",@"Transport",@"Tricoder",@"TX3250R 8C",@"UltraVu 260",@"UltraVu II 150",@"UltraVu II 2360 Mod 1",@"UltraVu II 5330",@"UltraVu II X300",@"UltraVu II X360",@"Upgrade",@"Upgrade Wizard",@"UPS",@"User Interface",@"USPS",@"UV Curable",@"Uv Lamp",@"VeraCore",@"Virtual Fiery",@"Web.Connect",@"Web Control Center",@"Webmart Adapter",@"Website",@"WebTracker",@"White Curing System",@"WiFi Print Service",@"WindowBook",@"Workflow Issue",@"Works Instruction",@"Workstation",@"WorkWise",@"Xerox",@"XMPie",@"XSL Documents",@"Desktop/Frame",@"DMI",@"Gateway",@"Web Pages",@"Web Pages (Terminal)",@"Web Pages (Reports)",@"NT Service (pctopp.exe)",@"Label Services",@"CommCtrl (Transport)",@"On-Line Link",@"SQL Server",@"DOS",@"MTClient (Counter)",@"Windows Clients",@"Client (other)",@"Server (other)",@"BDE",                                                @"CO2 Schnittstelle", @"Lector", @"VLOG", @"Fiery for Lector", nil];
    
    [self showActionViewWithTitle:@"Select Model/Item"];
    
    [actionView setHidden:NO];
    
}

// Showing Work Order Symptoms

- (IBAction)closeWOSymptomBtnAction:(id)sender {
    
    pickerSymptomArray = [[NSMutableArray alloc] initWithObjects:@"Account",@"Activation Issue",@"Adapter FIH MN4",@"Adhesion",@"Administrative",@"Agent",@"Aggregate Supply Pump Time Out",@"Air Leak",@"Authorize.Net Issue",@"Bill Acceptor",@"Bill Acceptor Cleaner",@"Blipping",@"Blurry Print",@"Bulb Not Igniting",@"Cable",@"Cable FIH MiniNet 4",@"Cable Pod LapNet",@"Cable Pwr Extension 12 PC500",@"Cable RJ45 3' Blue",@"Cable RJ45 w/Strain 15' Blue",@"Cable USB A-B w/Strain 4'",@"Can not power up",@"Can not print",@"Card Associate Staples",@"Card Cash Express Pay",@"Card Configuration Staples",@"Card Convenience FedEx",@"Card Courtesy Staples",@"Card Dispenser",@"Card Reader",@"Card Reader (L)",@"Card Reader Cable",@"Card Reader Cleaner",@"Card Reader Issue",@"Card Reader PC500",@"Card Staff",@"Card SVC FedEx",@"Card Team Member FedEx",@"Carriage X Drive - Error / Failure",@"Carriage Z Lift - Error / Failure",@"CF Card Issue",@"Clients",@"Cloud Service",@"Coin Acceptor",@"Coin Hopper",@"Color Match",@"Communication error",@"Connectors",@"Copier Issue",@"Copier Test Box MiniNet 2",@"Copier test box MiniNet 4",@"Curing System Not Working",@"Customer Application / Operation Question",@"Customer not entitled",@"Customer Request",@"Damaged Part",@"Dashboard",@"Database Problem",@"Defective Cable",@"De-Install",@"Display Issue",@"DockNet",@"Documentation",@"Environment",@"Environment/Server",@"Envrt/System Issue",@"EP PC Access",@"Error Indicated - Non-recoverable",@"Error Indicated - Recoverable",@"ES100",@"Escalation to other groups",@"Fiery XF",@"Fiery XF Malfunction",@"Fiery XF ProServer Failure",@"FIH Cable",@"Form / Fit / Alignment - Incorrect",@"FSE Dispatch/Completed",@"Functionality Issue Fiery Apps",@"Functionality Issues Connectors",@"Functionality Issues CPS",@"Functionality Issues EFI Apps",@"Functionality Issues General",@"Functionality Issues Proofing",@"Functionality Issues Web Submission",@"Function - Intermittent Failure",@"Function - Not Working / Missing",@"Function - Unexpected behavior",@"G5 Card Reader",@"Hard Drive Issue",@"Hardware Issue",@"Head Dripping",@"Icaro",@"Image Shifting",@"Information Request",@"Ink - Adhesion",@"Ink - Cracking / Durability / Embossing",@"Ink - Curing",@"Ink - Fill errors",@"Ink Leaks",@"Ink - Leaks",@"Ink Rubbing",@"Install - Defective / Damaged parts",@"Install - DeInstallation",@"Install - Missing Parts",@"Install - No Issues",@"Install - Shipping Damage",@"Install - Site Configuration Error",@"Inter ASIC Banding",@"Intra ASIC Banding",@"IQ - Banding / Step Inconsistency",@"IQ - Corrupt output",@"IQ - Density / Color Shift",@"IQ - Jet Dropout / Wetting / Drips / Not firing",@"IQ - Misdirected nozzle / X-Deviation",@"IQ - Satellites / Grainy / Blurry",@"Jet-Outs",@"Key MiniNet 4/USB Reader (2)",@"Label Designer",@"Lamp - Can not power up",@"Lamp - Cuts out while printing",@"Lamp - Does not open / close properly / noisy",@"Lamp - Overheating",@"LCD Cleaner",@"Lock Assembly",@"Locked",@"Lock-Up - Can reboot via GUI",@"Lock-Up - System re-boot required",@"Maintenance",@"Manufacturability",@"Media - Tracking",@"Media - Wrinkling / Curling",@"Mercury",@"MiniNet 2",@"MiniNet 4C",@"MiniNet 4L",@"MiniNet 4X - Copy/Print",@"MiniNet RPS",@"Misalignment",@"Misdirected Nozzle(s)",@"MIS Integration",@"Misregistration",@"Missing ASIC(S)",@"Missing Specification or Document",@"Network Issue",@"New Opportunity",@"No Autostart",@"Not Applicable",@"Not Configured",@"Not Detected",@"Not Determined",@"Not functioning",@"On - site",@"Other",@"Overheating",@"Payment Methods",@"Performance Issue - Speed / Efficiency Loss",@"Poor Cure",@"Power Adapter 9V",@"Power Adapter MiniNet4",@"Power adaptor 10 V",@"Power adaptor 9V",@"Power Issue",@"PPC",@"Pressure/Vacuum Excessive Variation",@"Pricing Issue",@"Printer",@"Printer Issues",@"Printhead Not Printing",@"Print jobs",@"Print - Loss / Incomplete",@"PrintMessenger",@"Receipt Paper G3 Kiosk",@"Receipt Printer",@"RFID Errors",@"Safety - E-Stop / Smoke Alarm",@"Scada",@"Scanner",@"Security - Smartcard / Key Dongle",@"Serviceability",@"Shutters Not Opening",@"Site Administration",@"Site Functionality Issues",@"Site Readiness Preparation",@"Slow Heating",@"Software",@"Software Installation",@"Software Issues",@"Software License",@"Stand MiniNet 4",@"Substrate Bubbling",@"Substrate Loose",@"Substrate Tight",@"Sustrate Vibration",@"Sustrate Waves",@"SW Lock-up - Can reboot via GUI",@"SW Lock-up - System re-boot required",@"System Crash",@"System Freeze",@"Tax Issue",@"Temperature Fluctuations",@"Tight Substrate",@"Touchscreen Issue",@"Training",@"Training/docs/CDs needed",@"Undefined Classification",@"Uneven Print B/W Heads",@"Uneven Print W/In Head",@"Uneven Treatment",@"Upgrade",@"Using Program",@"VDP",@"WCC Issues",@"Web Break",@"Workstation",@"Wrong Customer ID",@"XFLOW", nil];
    
    [self showActionViewWithTitle:@"Select Symptom"];
    
    [actionView setHidden:NO];
    
}

// Showing Work Order Area Units

- (IBAction)closeWOAreaUnitsBtnAction:(id)sender {
    
    pickerAreaUnitsArray = [[NSMutableArray alloc]initWithObjects:@"Sq ft",@"Sq m", nil];
    
    [self showActionViewWithTitle:@"Select AreaUnits"];
    
    [actionView setHidden:NO];
    
}

// Showing Work Order Expenses

- (IBAction)expensesOverCheckBoxBtnAction:(id)sender {
    
    expensesOverCheckboxSelected = !expensesOverCheckboxSelected;
    if (expensesOverCheckboxSelected == NO)
        
        [expensesOver setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    else
        [expensesOver setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
}

//  Updating Close Work Order Fields and push to Salesforce

- (IBAction)closeWOSaveBtnAction:(id)sender {
    
    if (areaUnits.titleLabel.text.length > 0) {
        
        if (expensesOverCheckboxSelected) {
            
            dict = @{@"Subject__c":closeWOSubjectField.text,
                     @"FConnect__Problem_Description__c":closeWOProblemDescriptionField.text,
                     @"Expenses_over_50__c":@YES,
                     @"AreaPrinted__c":areaPrinted.text,
                     @"AreaUnit__c":areaUnits.titleLabel.text,
                     @"InkUsage__c":inkUsage.text,
                     @"PrintTime__c":printerTime.text,
                     @"Product__c":closeWOProductButton.titleLabel.text,
                     @"Action_Taken__c": closeWOActionTakenButton.titleLabel.text,
                     @"Model_Item__c":closeWOModelButton.titleLabel.text,
                     @"Symptom__c":closeWOSymptomButton.titleLabel.text,
                     };
        } else {
            
            dict = @{@"Subject__c":closeWOSubjectField.text,
                     @"FConnect__Problem_Description__c":closeWOProblemDescriptionField.text,
                     @"Expenses_over_50__c":@NO,
                     @"AreaPrinted__c":areaPrinted.text,
                     @"AreaUnit__c":areaUnits.titleLabel.text,
                     @"InkUsage__c":inkUsage.text,
                     @"PrintTime__c":printerTime.text,
                     @"Product__c":closeWOProductButton.titleLabel.text,
                     @"Action_Taken__c": closeWOActionTakenButton.titleLabel.text,
                     @"Model_Item__c":closeWOModelButton.titleLabel.text,
                     @"Symptom__c":closeWOSymptomButton.titleLabel.text,
                     };
        }
        
    } else {
        
        if (expensesOverCheckboxSelected) {
            
            dict = @{@"Subject__c":closeWOSubjectField.text,
                     @"FConnect__Problem_Description__c":closeWOProblemDescriptionField.text,
                     @"Expenses_over_50__c":@YES,
                     @"AreaPrinted__c":areaPrinted.text,
                     @"AreaUnit__c":areaUnits.titleLabel.text,
                     @"InkUsage__c":inkUsage.text,
                     @"PrintTime__c":printerTime.text,
                     @"Product__c":closeWOProductButton.titleLabel.text,
                     @"Action_Taken__c": closeWOActionTakenButton.titleLabel.text,
                     @"Model_Item__c":closeWOModelButton.titleLabel.text,
                     @"Symptom__c":closeWOSymptomButton.titleLabel.text,
                     };
            
        } else {
            
            dict = @{@"Subject__c":closeWOSubjectField.text,
                     @"FConnect__Problem_Description__c":closeWOProblemDescriptionField.text,
                     @"Expenses_over_50__c":@NO,
                     @"AreaPrinted__c":areaPrinted.text,
                     @"AreaUnit__c":areaUnits.titleLabel.text,
                     @"InkUsage__c":inkUsage.text,
                     @"PrintTime__c":printerTime.text,
                     @"Product__c":closeWOProductButton.titleLabel.text,
                     @"Action_Taken__c": closeWOActionTakenButton.titleLabel.text,
                     @"Model_Item__c":closeWOModelButton.titleLabel.text,
                     @"Symptom__c":closeWOSymptomButton.titleLabel.text,
                     };
        }
        
    }
    
    if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] != SFSDKReachabilityNotReachable) {
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"FConnect__Service_Order__c" objectId:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"] fields:dict];
        [[SFRestAPI sharedInstance] send:request delegate:self];
        
    }
    
    if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == SFSDKReachabilityNotReachable) {
        
        _isOfflineWO = YES;
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineCloseWOData"]) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineCloseWOData"] isKindOfClass:[NSArray class]]) {
                
                NSArray *dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineCloseWOData"];
                [array addObjectsFromArray:dataArray];
                
                [array addObject:dict];
                
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"OfflineCloseWOData"];
            }
            
        } else {
            
            [[NSUserDefaults standardUserDefaults] setObject:@[dict] forKey:@"OfflineCloseWOData"];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [closeWorkOrderScrollView setHidden:YES];
    
}


- (IBAction)closeWOCancelBtnAction:(id)sender {
    
    [closeWorkOrderScrollView setHidden:YES];
    
    //    [closeWOInfoView setHidden:YES];
    //    [closeWoClosureView setHidden:YES];
    //    [closeWoBillableView setHidden:YES];
    //    [closeWOPrinterInfoView setHidden:YES];
    //
    //    closeWOClosureInfoButton.frame = CGRectMake(0, closeWOInfoButton.frame.origin.y+closeWOInfoButton.frame.size.height, 450, 50);
    //    closeWOBillableInfoButton.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 50);
    //    closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
    //
    //    [closeWOInfoButton setImage:[UIImage imageNamed:@"wo_info.png"] forState:UIControlStateNormal];
    //    [closeWOClosureInfoButton setImage:[UIImage imageNamed:@"closure_info.png"] forState:UIControlStateNormal];
    //    [closeWOBillableInfoButton setImage:[UIImage imageNamed:@"billable_info.png"] forState:UIControlStateNormal];
    //    [closeWOPrinterInfoButton setImage:[UIImage imageNamed:@"printer_info.png"] forState:UIControlStateNormal];
    //    _closeWOInfo = YES;
    //    _closeWOClosureInfo = YES;
    //    _closeWOBillableInfo = YES;
    //    _closeWOPrinterInfo = YES;
    
    
}


- (IBAction)closeWOInfoBtnAction:(id)sender {
    
    _closeWOInfo = !_closeWOInfo;
    
    if (_closeWOInfo == NO) {
        
        [closeWOInfoButton setImage:[UIImage imageNamed:@"wo_info.png"] forState:UIControlStateNormal];
        
        [closeWOInfoView setHidden:YES];
        
        closeWOClosureInfoButton.frame = CGRectMake(0, closeWOInfoButton.frame.origin.y+closeWOInfoButton.frame.size.height, 450, 50);
        closeWOBillableInfoButton.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 50);
        closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
        
        if (_closeWOClosureInfo) {
            
            closeWoClosureView.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 200);
            closeWOBillableInfoButton.frame = CGRectMake(0, closeWoClosureView.frame.origin.y+closeWoClosureView.frame.size.height, 450, 50);
            closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
            
            if (_closeWOBillableInfo) {
                
                closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
                closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            } else {
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            }
            
        } else {
            
            if (_closeWOBillableInfo) {
                
                closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
                closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            } else {
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            }
            
        }
        
    } else {
        
        [closeWOInfoButton setImage:[UIImage imageNamed:@"_wo_info.png"] forState:UIControlStateNormal];
        
        closeWOInfoView.frame = CGRectMake(0, closeWOInfoButton.frame.origin.y+closeWOInfoButton.frame.size.height, 450, 100);
        closeWOClosureInfoButton.frame = CGRectMake(0, closeWOInfoView.frame.origin.y+closeWOInfoView.frame.size.height, 450, 50);
        closeWOBillableInfoButton.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 50);
        closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
        
        [closeWOInfoView setHidden:NO];
        
        if (_closeWOClosureInfo) {
            
            closeWoClosureView.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 200);
            closeWOBillableInfoButton.frame = CGRectMake(0, closeWoClosureView.frame.origin.y+closeWoClosureView.frame.size.height, 450, 50);
            closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
            
            if (_closeWOBillableInfo) {
                
                closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
                closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            } else {
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            }
            
        } else {
            
            if (_closeWOBillableInfo) {
                
                closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
                closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            } else {
                
                if (_closeWOPrinterInfo) {
                    closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
                }
                
            }
            
        }
        
    }
    
}


- (IBAction)closeWOClosureInfoBtnAction:(id)sender {
    
    _closeWOClosureInfo = !_closeWOClosureInfo;
    
    if (_closeWOClosureInfo == NO) {
        
        [closeWOClosureInfoButton setImage:[UIImage imageNamed:@"closure_info.png"] forState:UIControlStateNormal];
        
        closeWOBillableInfoButton.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 50);
        closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
        
        [closeWoClosureView setHidden:YES];
        
        if (_closeWOBillableInfo) {
            
            closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
            closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
            
            if (_closeWOPrinterInfo) {
                closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
            }
            
        } else {
            
            if (_closeWOPrinterInfo) {
                closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
            }
            
        }
        
    } else {
        
        [closeWOClosureInfoButton setImage:[UIImage imageNamed:@"_closure_info.png"] forState:UIControlStateNormal];
        
        closeWoClosureView.frame = CGRectMake(0, closeWOClosureInfoButton.frame.origin.y+closeWOClosureInfoButton.frame.size.height, 450, 200);
        closeWOBillableInfoButton.frame = CGRectMake(0, closeWoClosureView.frame.origin.y+closeWoClosureView.frame.size.height, 450, 50);
        closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
        
        [closeWoClosureView setHidden:NO];
        
        if (_closeWOBillableInfo) {
            
            closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
            closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
            
            if (_closeWOPrinterInfo) {
                closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
            }
            
        } else {
            
            if (_closeWOPrinterInfo) {
                closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
            }
            
        }
        
    }
    
}


- (IBAction)closeWOBillableInfoBtnAction:(id)sender {
    
    _closeWOBillableInfo = !_closeWOBillableInfo;
    
    if (_closeWOBillableInfo == NO) {
        
        [closeWOBillableInfoButton setImage:[UIImage imageNamed:@"billable_info.png"] forState:UIControlStateNormal];
        
        closeWOPrinterInfoButton.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 50);
        
        if (_closeWOPrinterInfo) {
            closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
        }
        
        [closeWoBillableView setHidden:YES];
        
    } else {
        
        [closeWOBillableInfoButton setImage:[UIImage imageNamed:@"_billable_info.png"] forState:UIControlStateNormal];
        
        closeWoBillableView.frame = CGRectMake(0, closeWOBillableInfoButton.frame.origin.y+closeWOBillableInfoButton.frame.size.height, 450, 70);
        closeWOPrinterInfoButton.frame = CGRectMake(0, closeWoBillableView.frame.origin.y+closeWoBillableView.frame.size.height, 450, 50);
        
        if (_closeWOPrinterInfo) {
            closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
        }
        
        [closeWoBillableView setHidden:NO];
    }
    
}


- (IBAction)closeWOPrinterInfoBtnAction:(id)sender {
    
    _closeWOPrinterInfo = !_closeWOPrinterInfo;
    
    if (_closeWOPrinterInfo == NO) {
        
        [closeWOPrinterInfoButton setImage:[UIImage imageNamed:@"printer_info.png"] forState:UIControlStateNormal];
        
        closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
        
        [closeWOPrinterInfoView setHidden:YES];
        
    } else {
        
        [closeWOPrinterInfoButton setImage:[UIImage imageNamed:@"_printer_info.png"] forState:UIControlStateNormal];
        
        closeWOPrinterInfoView.frame = CGRectMake(0, closeWOPrinterInfoButton.frame.origin.y+closeWOPrinterInfoButton.frame.size.height, 450, 200);
        
        [closeWOPrinterInfoView setHidden:NO];
        
    }
    
}


- (IBAction)serviceBtnAction:(id)sender {
    
    [startTravelView setHidden:NO];
    [serviceButton setHidden:NO];
    [travelButton setHidden:YES];
    
}


- (IBAction)travelBtnAction:(id)sender {
    
    [startTravelView setHidden:NO];
    [travelButton setHidden:NO];
    [serviceButton setHidden:YES];
    
}

- (IBAction)serviceIconBtnAction:(id)sender {
    
    //    NSDate *date;
    //    NSString *startServiceTime;
    //    NSString *endServiceTime;
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeInterval startDateSeconds = [[NSDate date] timeIntervalSince1970];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSeconds];
    
//    formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"];
    
    startServiceString = [formatter stringFromDate:startDate];
    
    if(serviceChecked) {
        
        //        endServiceTime = [formatter stringFromDate:[NSDate date]];
        //        date = [formatter dateFromString:endServiceTime];
        
        //        NSLog(@"End Service:%@",endServiceTime);
        
        [sender setBackgroundImage:[UIImage imageNamed:@"start service.png"] forState:UIControlStateNormal];
        
        serviceChecked = NO;
        [startTravelView setHidden:YES];
        
    } else {
        
       
        NSDictionary * startServiceDict = @{@"FConnect__Start_Date_Time__c":startServiceString,
                                           @"FConnect__Activity__c":[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"],
                                           
                                           @"Name":@"Service",
                                           @"FConnect__Type__c":@"Service",
                                           @"FConnect__Comments__c":@"",
                                           @"FConnect__End_Date_Time__c":@"",
                                           @"FConnect__Duration_MM__c":@"0.0",
                                           @"FConnect__End_Date_Time__c":@"",
                                           @"Id":@""
                                           
                                           };
        
        [timeArray addObject:startServiceDict];

        //        startServiceTime = [formatter stringFromDate:[NSDate date]];
        
        //        NSLog(@"Start Service:%@",startServiceTime);
        
        [sender setBackgroundImage:[UIImage imageNamed:@"end service.png"] forState:UIControlStateNormal];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [timeAndExpensesTableView reloadData];
        });
        
        serviceChecked = YES;
        [startTravelView setHidden:YES];
        
        return;
        
    }
    
    if (WOActivitiesArray.count > 0) {
        
        NSString *savedTechnicianValue = [[NSUserDefaults standardUserDefaults]
                                          stringForKey:@"TechnicianId"];
        
        NSLog(@"%@",savedTechnicianValue);
        
        NSDictionary *serviceDict = [[NSDictionary alloc]init];
        
        serviceDict = @{@"FConnect__Service_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                        @"FConnect__Activity__c":[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"],
                        @"FConnect__Technician__c":savedTechnicianValue,
                        @"FConnect__Start_Date_Time__c":startServiceString,
                        @"FConnect__End_Date_Time__c":startServiceString
                        
                        };
        
        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] != SFSDKReachabilityNotReachable) {
            
            SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"FConnect__Time__c" fields:serviceDict];
            
            [[SFRestAPI sharedInstance] send:request delegate:self];
            
        }
        
        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == SFSDKReachabilityNotReachable) {
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineServiceData"]) {
                
                _isOfflineService = YES;

                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineServiceData"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineServiceData"];
                    [array addObjectsFromArray:dataArray];
                    
                    [array addObject:serviceDict];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"OfflineServiceData"];
                }
                
            } else {
                
                [[NSUserDefaults standardUserDefaults] setObject:@[serviceDict] forKey:@"OfflineServiceData"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"No Service Time" message:@"No Service Time to Save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
}


- (IBAction)travelIconBtnAction:(id)sender {
    
    NSDate *startTravelDate;
    
    if(travelChecked) {
        
//        formatter = [[NSDateFormatter alloc] init];

        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        endTravelString = [formatter stringFromDate:[NSDate date]];

//        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

        NSDate *endTravelDate = [formatter dateFromString:endTravelString];

        
        NSTimeInterval secs = [endTravelDate timeIntervalSinceDate:startTravelDate];
        
        NSLog(@"%f",secs);
        

        [sender setBackgroundImage:[UIImage imageNamed:@"start travel.png"] forState:UIControlStateNormal];
        
        travelChecked = NO;
        [startTravelView setHidden:YES];
        
    } else {
        
//        formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSLog(@"%@",[formatter stringFromDate:[NSDate date]]);
        
        startTravelString = [formatter stringFromDate:[NSDate date]];
        
//        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        startTravelDate = [formatter dateFromString:startTravelString];

        NSDictionary * startTravelDict = @{@"FConnect__Start_Date_Time__c":startTravelString,
                               @"FConnect__Activity__c":[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"],
                               @"Name":@"Travel",
                               @"FConnect__Type__c":@"Travel",
                               @"FConnect__Comments__c":@"",
                               @"FConnect__End_Date_Time__c":@"",
                               @"FConnect__Duration_MM__c":@"",
                               @"FConnect__End_Date_Time__c":@"",
                               @"Id":@""

                               };
        
        [timeArray addObject:startTravelDict];
        
        
        //        startTravelTime = [formatter stringFromDate:[NSDate date]];
        
        //        NSLog(@"Start Travel:%@",startTravelTime);
        
        [sender setBackgroundImage:[UIImage imageNamed:@"end travel.png"] forState:UIControlStateNormal];
        
        travelChecked = YES;
        [startTravelView setHidden:YES];
        
        [timeAndExpensesTableView reloadData];
        
        return;
        
    }
    
    if (WOActivitiesArray.count > 0) {
        
        NSDictionary *travelDict = [[NSDictionary alloc]init];
        
        NSString *savedTechnicianValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"TechnicianId"];
        
        NSLog(@"%@",savedTechnicianValue);
        
        travelDict = @{@"FConnect__Service_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                       @"FConnect__Activity__c":[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"],
                       @"FConnect__Technician__c":savedTechnicianValue,
                       @"FConnect__Start_Date_Time__c":startTravelString,
                       @"FConnect__End_Date_Time__c":endTravelString
                       };
        
        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] != SFSDKReachabilityNotReachable) {
            
            SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"FConnect__Time__c" fields:travelDict];
            
            [[SFRestAPI sharedInstance] send:request delegate:self];
            
        }
        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == SFSDKReachabilityNotReachable) {
            
            _isOfflineTravel = YES;

            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineTravelData"]) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineTravelData"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineTravelData"];
                    
                    [array addObjectsFromArray:dataArray];
                    
                    [array addObject:travelDict];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"OfflineTravelData"];
                }

            } else {
                
                [[NSUserDefaults standardUserDefaults] setObject:@[travelDict] forKey:@"OfflineTravelData"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"No Travel Time" message:@"No Travel Time to Save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
    
}


- (IBAction)startTravelCloseBtnAction:(id)sender {
    
    [startTravelView setHidden:YES];
    
}


- (IBAction)saveSignatureBtnAction:(id)sender {
    
    
    if (signatureBackgroundImageView.image == nil) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"No Signature" message:@"No Signature to Save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
    }
    
    
    //get reference to the button that requested the action
    UIButton *myButton = (UIButton *)sender;
    
    //check which button it is, if you have more than one button on the screen
    //you must check before taking necessary action
    if([myButton.titleLabel.text isEqualToString:@"Save"]){
        NSLog(@"Clicked on the bar button");
        
        [self saveSignatureImage];
        
    }
    
    [signatureBackgroundView setHidden:YES];
    
}

- (IBAction)cancelSignatureBtnAction:(id)sender {
    
    [signatureBackgroundView setHidden:YES];
    
    signatureBackgroundImageView.image = nil;
    
}

- (IBAction)clearSignatureBtnAction:(id)sender {
    
    signatureBackgroundImageView.image = nil;
    
}


- (IBAction)newServiceResultsBtnAction:(id)sender {
    
    newServiceResultsScrollView.contentSize = CGSizeMake(0, 900);
    
    if (serviceOrdersArray.count > 0) {
        
        newServiceResultsWorkOrderLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
        
    }
    if (WOServiceResultsArray.count > 0) {
        
        newServiceResultsOrderActivityLabel.text = [[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Name"];
        
    }
    
    [newServiceResultsView setHidden:NO];
    
    [serviceResultsInformationView setHidden:YES];
    
}


- (IBAction)newServiceResultsSaveBtnAction:(id)sender {
    
    NSDictionary *newServiceResultsDict = [[NSDictionary alloc]init];
    
    newServiceResultsDict = @{@"Product__c":newServiceResultsProductButton.titleLabel.text,
                              @"Sub_Systems__c":newServiceResultsSubSystems.titleLabel.text,
                              @"Duration__c":newServiceResultsDurationField.text,
                              @"Symp__c":newServiceResultsSymptomsButton.titleLabel.text,
                              @"System__c":newServiceResultsSystemButton.titleLabel.text,
                              @"Action_Taken__c":newServiceResultsActionTakenButton.titleLabel.text,
                              @"Root_Cause__c":newServiceResultsRootCauseButton.titleLabel.text,
                              @"Details__c":newServiceResultsDetailsField.text,
                              @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                              @"Order_Activity__c":[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"]
                              
                              };

    if (_isEditing) {
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Sub_Results__c" objectId:[[WOServiceResultsArray objectAtIndex:selectedRow]objectForKey:@"Id"] fields:newServiceResultsDict];
        [[SFRestAPI sharedInstance] send:request delegate:self];

        
    } else {
        
        //    NSTimeInterval startDateSeconds = [[NSDate date] timeIntervalSince1970];
        //    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSeconds];
        
        [formatter setDateFormat:@"MM-dd-yyyy"];
        NSString *newDateString = @"Sub Results";
        
        
        CFUUIDRef udid = CFUUIDCreate(NULL);
        NSString * udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
        
        NSString *newString = [udidString substringToIndex:8];
        
        
        NSArray *myStrings = [[NSArray alloc] initWithObjects:newDateString,newString, nil];
        
        NSString *joinedString = [myStrings componentsJoinedByString:@"  "];
        
        NSDictionary * newServiceResultsLocalDict = @{@"Product__c":@"",
                                                      @"Id":@"",
                                                      @"Name":joinedString,
                                                      @"CreatedDate__c":@"",
                                                      @"Sub_Systems__c":@"",
                                                      @"Duration__c":@"",
                                                      @"Symp__c":@"",
                                                      @"System__c":@"",
                                                      @"Action_Taken__c":@"",
                                                      @"Root_Cause__c":@"",
                                                      @"Details__c":@"",
                                                      @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                                                      @"Order_Activity__c":[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"]
                                                      };
        
        [serviceResultsArray addObject:newServiceResultsLocalDict];
        
        [timeAndExpensesTableView reloadData];
        
        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] != SFSDKReachabilityNotReachable) {
            
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Sub_Results__c" fields:newServiceResultsDict];
            
            [[SFRestAPI sharedInstance] send:request delegate:self];
            
        }
        
        if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == SFSDKReachabilityNotReachable) {
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"]) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"];
                    [array addObjectsFromArray:dataArray];
                    
                    [array addObject:newServiceResultsDict];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"OfflineData"];
                }
                
            } else {
                
                [[NSUserDefaults standardUserDefaults] setObject:@[newServiceResultsDict] forKey:@"OfflineData"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    
    
    [newServiceResultsView setHidden:YES];

    [newServiceResultsProductButton setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsSystemButton setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsSubSystems setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsRootCauseButton setTitle:@"" forState:UIControlStateNormal];
    newServiceResultsDurationField.text = @"";
    [newServiceResultsSymptomsButton setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsActionTakenButton setTitle:@"" forState:UIControlStateNormal];
    newServiceResultsDetailsField.text = @"";
    

    
}

- (IBAction)newServiceResultsCancelBtnAction:(id)sender {
    
    [newServiceResultsProductButton setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsSystemButton setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsSubSystems setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsRootCauseButton setTitle:@"" forState:UIControlStateNormal];
    newServiceResultsDurationField.text = @"";
    [newServiceResultsSymptomsButton setTitle:@"" forState:UIControlStateNormal];
    [newServiceResultsActionTakenButton setTitle:@"" forState:UIControlStateNormal];
    newServiceResultsDetailsField.text = @"";
    
    [newServiceResultsView setHidden:YES];
    
}

- (IBAction)newServiceResultsProductBtnAction:(id)sender {
    
    pickerNewServiceResultsProductArray=[[NSMutableArray alloc]initWithObjects:@"Cretaprint",@"Ink",@"XF RIP",@"Jetrion",@"VUTEk",@"Wide Format",nil];
    
    [self showActionViewWithTitle:@"New Service Result Product"];
    
    [actionView setHidden:NO];
    
    
}


- (IBAction)newServiceResultsSystemBtnAction:(id)sender {
    
    pickerNewServiceResultsSystemsArray = [[NSMutableArray alloc]init];
    
    if (newServiceResultsProductButton.titleLabel.text.length != 0) {
        
        if ([newServiceResultsProductButton.titleLabel.text isEqualToString:@"Cretaprint"]) {
            
            pickerNewServiceResultsSystemsArray =[[NSMutableArray alloc] initWithObjects:@"Customer",@"Electronics Box",@"Ink System",@"Media Transport",@"Movements",@"Printing Electronics",@"Safety",@"Software", nil];
            
        }
        if ([newServiceResultsProductButton.titleLabel.text isEqualToString:@"Ink"]||[newServiceResultsProductButton.titleLabel.text isEqualToString:@"XF RIP"]) {
            
            pickerNewServiceResultsSystemsArray = nil;
            
            pickerNewServiceResultsSystemsArray = [[NSMutableArray alloc] initWithObjects:@"Beam",@"Carriage",@"Chillers",@"Corona",@"Curing", @"System",@"Customer",@"DSP",@"Electronics Box",@"Finishing",@"Frame Assy",@"Ink Box",@"Ink System",@"Laser",@"Lamp System",@"Media Transport",@"Movements",@"Power Distribution",@"Printing Electronics",@"Print Zone",@"Safety",@"Software",@"T Box",@"Tools",@"Ventilation", nil];
            
            
        }
        if ([newServiceResultsProductButton.titleLabel.text isEqualToString:@"Jetrion"]) {
            
            pickerNewServiceResultsSystemsArray = nil;
            
            pickerNewServiceResultsSystemsArray = [[NSMutableArray alloc] initWithObjects:@"Chillers",@"Corona",@"Curing System",@"Customer",@"Finishing",@"Ink System",@"Laser",@"Media Transport",@"Power Distribution",@"Printing Electronics",@"Print Zone",@"Safety",@"Software",@"Tools",@"Ventilation", nil];
            
        }
        
        if ([newServiceResultsProductButton.titleLabel.text isEqualToString:@"VUTEk"]||[newServiceResultsProductButton.titleLabel.text isEqualToString:@"Wide Format"]) {
            
            pickerNewServiceResultsSystemsArray = nil;
            
            pickerNewServiceResultsSystemsArray = [[NSMutableArray alloc]initWithObjects:@"Beam",@"Carriage",@"Customer",@"DSP",@"Electronics Box",@"Frame Assy",@"Ink Box",@"Lamp System",@"Media Transport",@"Safety",@"Software",@"T Box",@"Tools",nil];
            
        }
        
    }
    
    [self showActionViewWithTitle:@"New Service Result System"];
    
    [actionView setHidden:NO];
    
    
}

- (IBAction)newServiceResultsSymptomsBtnAction:(id)sender {
    
    pickerNewServiceResultsSymptomsArray = [[NSMutableArray alloc] initWithObjects:@"Account",@"Activation Issue",@"Adapter FIH MN4",@"Adhesion",@"Administrative",@"Agent",@"Aggregate Supply Pump Time Out",@"Air Leak",@"Authorize.Net Issue",@"Bill Acceptor",@"Bill Acceptor Cleaner",@"Blipping",@"Blurry Print",@"Bulb Not Igniting",@"Cable",@"Cable FIH MiniNet 4",@"Cable Pod LapNet",@"Cable Pwr Extension 12 PC500",@"Cable RJ45 3' Blue",@"Cable RJ45 w/Strain 15' Blue",@"Cable USB A-B w/Strain 4'",@"Can not power up",@"Can not print",@"Card Associate Staples",@"Card Cash Express Pay",@"Card Configuration Staples",@"Card Convenience FedEx",@"Card Courtesy Staples",@"Card Dispenser",@"Card Reader",@"Card Reader (L)",@"Card Reader Cable",@"Card Reader Cleaner",@"Card Reader Issue",@"Card Reader PC500",@"Card Staff",@"Card SVC FedEx",@"Card Team Member FedEx",@"Carriage X Drive - Error / Failure",@"Carriage Z Lift - Error / Failure",@"CF Card Issue",@"Clients",@"Cloud Service",@"Coin Acceptor",@"Coin Hopper",@"Color Match",@"Communication error",@"Connectors",@"Copier Issue",@"Copier Test Box MiniNet 2",@"Copier test box MiniNet 4",@"Curing System Not Working",@"Customer Application / Operation Question",@"Customer not entitled",@"Customer Request",@"Damaged Part",@"Dashboard",@"Database Problem",@"Defective Cable",@"De-Install",@"Display Issue",@"DockNet",@"Documentation",@"Environment",@"Environment/Server",@"Envrt/System Issue",@"EP PC Access",@"Error Indicated - Non-recoverable",@"Error Indicated - Recoverable",@"ES100",@"Escalation to other groups",@"Fiery XF",@"Fiery XF Malfunction",@"Fiery XF ProServer Failure",@"FIH Cable",@"Form / Fit / Alignment - Incorrect",@"FSE Dispatch/Completed",@"Functionality Issue Fiery Apps",@"Functionality Issues Connectors",@"Functionality Issues CPS",@"Functionality Issues EFI Apps",@"Functionality Issues General",@"Functionality Issues Proofing",@"Functionality Issues Web Submission",@"Function - Intermittent Failure",@"Function - Not Working / Missing",@"Function - Unexpected behavior",@"G5 Card Reader",@"Hard Drive Issue",@"Hardware Issue",@"Head Dripping",@"Icaro",@"Image Shifting",@"Information Request",@"Ink - Adhesion",@"Ink - Cracking / Durability / Embossing",@"Ink - Curing",@"Ink - Fill errors",@"Ink Leaks",@"Ink - Leaks",@"Ink Rubbing",@"Install - Defective / Damaged parts",@"Install - DeInstallation",@"Install - Missing Parts",@"Install - No Issues",@"Install - Shipping Damage",@"Install - Site Configuration Error",@"Inter ASIC Banding",@"Intra ASIC Banding",@"IQ - Banding / Step Inconsistency",@"IQ - Corrupt output",@"IQ - Density / Color Shift",@"IQ - Jet Dropout / Wetting / Drips / Not firing",@"IQ - Misdirected nozzle / X-Deviation",@"IQ - Satellites / Grainy / Blurry",@"Jet-Outs",@"Key MiniNet 4/USB Reader (2)",@"Label Designer",@"Lamp - Can not power up",@"Lamp - Cuts out while printing",@"Lamp - Does not open / close properly / noisy",@"Lamp - Overheating",@"LCD Cleaner",@"Lock Assembly",@"Locked",@"Lock-Up - Can reboot via GUI",@"Lock-Up - System re-boot required",@"Maintenance",@"Manufacturability",@"Media - Tracking",@"Media - Wrinkling / Curling",@"Mercury",@"MiniNet 2",@"MiniNet 4C",@"MiniNet 4L",@"MiniNet 4X - Copy/Print",@"MiniNet RPS",@"Misalignment",@"Misdirected Nozzle(s)",@"MIS Integration",@"Misregistration",@"Missing ASIC(S)",@"Missing Specification or Document",@"Network Issue",@"New Opportunity",@"No Autostart",@"Not Applicable",@"Not Configured",@"Not Detected",@"Not Determined",@"Not functioning",@"On - site",@"Other",@"Overheating",@"Payment Methods",@"Performance Issue - Speed / Efficiency Loss",@"Poor Cure",@"Power Adapter 9V",@"Power Adapter MiniNet4",@"Power adaptor 10 V",@"Power adaptor 9V",@"Power Issue",@"PPC",@"Pressure/Vacuum Excessive Variation",@"Pricing Issue",@"Printer",@"Printer Issues",@"Printhead Not Printing",@"Print jobs",@"Print - Loss / Incomplete",@"PrintMessenger",@"Receipt Paper G3 Kiosk",@"Receipt Printer",@"RFID Errors",@"Safety - E-Stop / Smoke Alarm",@"Scada",@"Scanner",@"Security - Smartcard / Key Dongle",@"Serviceability",@"Shutters Not Opening",@"Site Administration",@"Site Functionality Issues",@"Site Readiness Preparation",@"Slow Heating",@"Software",@"Software Installation",@"Software Issues",@"Software License",@"Stand MiniNet 4",@"Substrate Bubbling",@"Substrate Loose",@"Substrate Tight",@"Sustrate Vibration",@"Sustrate Waves",@"SW Lock-up - Can reboot via GUI",@"SW Lock-up - System re-boot required",@"System Crash",@"System Freeze",@"Tax Issue",@"Temperature Fluctuations",@"Tight Substrate",@"Touchscreen Issue",@"Training",@"Training/docs/CDs needed",@"Undefined Classification",@"Uneven Print B/W Heads",@"Uneven Print W/In Head",@"Uneven Treatment",@"Upgrade",@"Using Program",@"VDP",@"WCC Issues",@"Web Break",@"Workstation",@"Wrong Customer ID",@"XFLOW", nil];
    
    [self showActionViewWithTitle:@"New Service Result Symptoms"];
    
    [actionView setHidden:NO];
}

- (IBAction)newServiceResultsActionTakenBtnAction:(id)sender {
    
    pickerNewServiceResultsActionTakenArray = [[NSMutableArray alloc] initWithObjects:@"Aligned / Adjusted",@"Answered question",@"Clarification / Instructions given / User Error",@"Cleaned", @"Customer Resolved",@"Defect issue",@"De-Install",@"Documentation provided",@"Document provided",@"Duplicate Case",@"Escalated to Sales",@"Export - Import",@"Feature Request",@"Feature request / deferred to future release",@"Fixed in Hotfix",@"Fixed in Update",@"Fixed in version release",@"Fix installed",@"Fix provided / advised to install fix package",@"FSE Dispatch/Completed",@"Functions as specified",@"General setup/config",@"Guided/answered customer",@"Information provided",@"Install - No Issues",@"JIRA Issue",@"Latest updates installed",@"N/A - Customer failed to respond",@"N/A - Duplicate Case",@"N/A - Not Valid Case",@"N/A - SPAM",@"New License provided / Rehost",@"None",@"Not able to reproduce",@"Not OUR issue / 3rd party",@"Not supported OS / OS issues",@"Only Using Error",@"Other",@"Parts assistance",@"Parts needed",@"Proposed no fix",@"Provided training (billable)",@"Provided training (non-billable)",@"Provide information on upgrade",@"Redirected to reseller",@"Referred to billing",@"Referred to external party",@"Referred to ISP/IT/3rd Party",@"Referred to OEM/partner",@"Referred to sales",@"Referred to services",@"Referred to support",@"Refund / Credit",@"Reinserted",@"Replaced",@"Resolved",@"Resolved: Customer Actions",@"Resolved: FSE Actions",@"Resolved: FSE Info/Training",@"Resolved: ISE Actions",@"Resolved: ISE Info/Training",@"Resolved: WebEx Diagnosis",@"Resolved with assistance",@"Sales question / forwarded to sales",@"Shipped CDs",@"Sold support agreement",@"Tightened",@"Trained",@"Unclear documentation",@"Unreproducible / no issue / undetermined",@"Unresolved",@"Updated account information",@"Upgrade assistance",@"Uploaded",@"Usability",@"WebEx Scheduled",@"Referred to website",@"Sent an Offer / New Billable Service",@"Visit recommended", nil];
    
    [self showActionViewWithTitle:@"New Service Result ActionTaken"];
    
    [actionView setHidden:NO];
    
}


- (IBAction)newServiceResultsSubSystemsBtnAction:(id)sender {
    
    if (newServiceResultsSystemButton.titleLabel.text.length != 0) {
        
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Beam"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Bearing",@"Carriage Belt",@"Encoder",@"Hard Stop",@"Idler Pulley",@"IGUS Track",@"Limit Switch",@"Planer Cables",@"Plumbing",@"Rail Beam",@"X-Drive Motor",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Carriage"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Analog Board",@"Backplane Board",@"Bearing",@"Cable",@"Camera",@"Carriage Fans",@"Carriage Lift",@"Carriage Lift Board",@"Crash SW Sensor",@"Digital Board",@"Edge Detector",@"Filter",@"Fuse",@"Hardware",@"Ink Float",@"Ink Heater Board",@"Ink Solenoid",@"Ink Tank",@"Jet",@"Jet Board",@"Jet Damper",@"Jet Pack Distribution Board",@"Jet Pack Hold Down",@"Jet Plate",@"Limit Sensor",@"Manometer",@"Optical Encoder",@"O-Ring",@"Plumbing",@"Power Board",@"Print Head Controller Board",@"Purge Valve",@"Static Eliminator PS",@"Vacuum Manifold",@"Venturi",nil];
            
        }
        
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Chillers"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Chiller Transformer",@"Filter",@"Fluids",@"Tubing / Connections",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Corona"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Air Gap",@"Controller",@"Discharge Roller",@"Electrodes / Cartridge",@"Power Supply",@"Transformer",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Curing System"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Bulb",@"Cable",@"Chill Rollers",@"EPS",@"Fan",@"Lamp Cables",@"LED Lamp",@"Microcontroller Muc",@"Nitrogen Membrane",@"Nitrogen Valve",@"Pneumatics Panel",@"Quartz Glass",@"Shutter",@"Shutter and Base Assy",@"Temperature Sensor",@"UV Lamp",@"Water / Oil Trap",nil];
            
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Customer"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Air Conditioning",@"Air Extraction",@"Ceramic Design",@"Ceramic Inks / Cleaner",@"Configuration",@"Environmental",@"Filter",@"Incoming Air",@"Incoming Power",@"Media",@"Network",@"Overpressure",@"Printer Location",@"Profile",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"DSP"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Cabling",@"LED Driver Assembly",@"Light Bar",@"Proofing Light",@"Sheet Metal",@"Tick Sensor",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Electronics Box"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Breakers",@"Bulkhead Connectors",@"Cable",@"CANOpen network",@"Contractors",@"Controller Board",@"DVD Drive",@"Fan",@"Fuse",@"Hardware",@"I/O Modules",@"Light Shield",@"Motherboard",@"Multi - Function Board",@"Pixel Board",@"PLC",@"PMAC",@"Power Board",@"Power Supply",@"Primary / Secondary PC",@"Pro Server",@"RIO Box",@"Router",@"Servo",@"Touch Panel / Keyboard / Mouse",@"Trigger card",@"USB Board",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Finishing"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Anilox Roller",@"Anvil Roller",@"Back Scorer",@"Compactor",@"Doctor Blade",@"Peristaltic Pump",@"Print Roller Mandrel",@"Scrapper Heater",@"Slitter",@"Touch Screen",@"UV Lamp",@"Varnish Print Roller",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Frame Assy"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Cable",@"End Cap",@"Exhaust Fan",@"Feet",@"Filter",@"Gas Piston",@"Ink/E-box Door",@"Ink Separator",@"Keyboard/Monitor/Mouse",@"Level",@"Main Door",@"Rear Door",@"Skin/Cover",@"Wheel",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Ink Box"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Cable",@"Capper",@"Controller Board",@"Coolant Pump",@"Coupler",@"Cyclonic Separator",@"Degasser",@"Fan",@"Ink",@"Ink Filter",@"Ink Float",@"Ink Pump",@"Ink Transition Board",@"Ink Translation Board",@"Klaxon Beeper",@"Light Shield",@"N2 Filter",@"PLC",@"Plumbing",@"Pneumatic",@"Port Server",@"Regulator",@"RFID",@"Router",@"Sensor",@"Solenoid/Valve",@"Solvent Bottle",@"Stirring Motor",@"Waste Tank",@"Waste Tray",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Ink System"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Bulk Tank",@"Circulation Pump",@"Damper",@"Drain/Supply Valve",@"Filter",@"Header Tank / Exchanger",@"Heater",@"Ink Arresting Filter",@"Ink Filter",@"Level Sensor",@"Maint Tank / Stirrers",@"Manifold",@"Pressure / Temperature sensor",@"Pressure PPC",@"Pumps",@"Reservoir",@"Supply/Drain Pump",@"Thermocouple",@"Tubing / Connections",@"Vacuum PPC",@"Vacuum Trap",@"Venturi",@"Waste Tank",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Laser"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Eolo / Mistral",@"Galvo",@"Laser Protection Glass",@"Laser Source",@"Mirror",@"Power Supply",@"RF Modulator",@"RF Power Supply",@"Scan Head",@"Sei 059",@"sei 125",@"Vacuum Table",@"Zeta Dynamic",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Lamp System"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Bulb",@"Cable"@"Fan",@"Fan/Lamp Controller Board",@"Filter",@"Lamp Brackets",@"Lamp Cables",@"LED Lamp",@"Quartz Glass",@"Shutter",@"Shutter and Base Assy",@"Static Eliminator Bar",@"UV Lamp",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Media Transport"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Antistatic Bar / Ionizer",@"Automated I/O Table",@"Backup Rollers",@"Bearings / Jacob Coupler",@"Belt Cleaning Tray",@"Belt Driver",@"Bladder",@"Brake",@"Buffer",@"Cable",@"Chain",@"Chuck",@"Dancer Roll",@"Drive Roll",@"Elevated",@"Encoder",@"Fence",@"Flojet Cleaning Pump",@"Foot Pedal",@"Gear",@"Hardware",@"I/O Table",@"Idler Roll",@"Input Guides",@"Media Belt",@"Media Belt Guide",@"Media Detection",@"Media Positioner",@"MEG",@"Mesh",@"NIP Roll",@"Parker Drive",@"Pinch Cylinder",@"Platen",@"Pressure Roll",@"Rear Control Panel",@"Rubber Scrapper",@"Sensor",@"Ski",@"Spindle",@"Stacker",@"Tension Motor",@"Vaccuum Hose",@"Vacuum Pump",@"Vacuum Table",@"Web Guide",@"Winder/Unwinder",@"X-Drive Motor",@"Y-Drive Motor",@"Z-Drive Motor",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Movements"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Bar In / Out",@"Cleaning Movement",@"Cleaning Suction System",@"ICLA Movement",@"Tray Movement",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Power Distribution"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Breakers",@"Cable",@"Contactor",@"Fuse",@"Interface Panel",@"Power Supply",@"Solid State Relay",@"Switches",@"Terminal Block",@"Transformer",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Printing Electronics"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Alhambra / Leon / Pegaso ID Card",@"Cable",@"Carriage Board",@"HDMI Cable",@"HIB",@"HPB / Converter",@"HPC",@"Jet",@"Jet to ID Card Adapter",@"PMB",@"Video Board",@"XAAR XUSB",@"XUSB",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Print Zone"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Alignment Adjusters",@"Aveo Card",@"Encoder",@"Gas Shocks",@"Global Skew Micrometer",@"HPC",@"ID Card",@"Jet Plate",@"Lift Cylinder",@"Locking Screws",@"Print Head",@"Roller Platen",@"Solid Platen",@"Stop Cap",@"Thermocouple",@"Tubing / Connections",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Safety"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"E-Cable",@"E-Stop",@"Interlock",@"Laser Protection",@"Main Power Disconnect",@"Packaging",@"Photocell / Microsensor Barrier",@"Print Module Cover",@"Smoke Detector",nil];
            
        }
        
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Software"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"External Software",@"Firmware",@"GUI",@"PLC",@"Print Server",@"Software",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"T Box"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Ballasts",@"Cable",@"Contactor",@"Fan",@"Filter",@"Power Supply",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Tools"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Fan",@"Image Plane",@"Installation Toolkit",@"Jet Recovery Station",@"Laser Alignment Tool",@"Level",@"Manometer",@"Roll to Roll",@"Sub Pixel Alignment",@"Un-Winder/Re-Winder",nil];;
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Ventilation"]) {
            
            pickerNewServiceResultsSubSystemArray = nil;
            
            pickerNewServiceResultsSubSystemArray = [[NSMutableArray alloc]initWithObjects:@"Blower / Fans",@"Damper",@"Hoses",nil];
            
        }
        
    }
    
    [self showActionViewWithTitle:@"New Service Result SubSystems"];
    
    [actionView setHidden:NO];
    
}


- (IBAction)newServiceResultsRootCauseBtnAction:(id)sender {
    
    if (newServiceResultsSystemButton.titleLabel.text.length != 0) {
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Beam"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Image Plane Issue",@"Loose Part",@"Maintenance",@"Out of Alignment",@"Part Failure",@"Process Issue",@"Unknown",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Carriage"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Environmental Issue - Heat/Contaminant",@"Expired Ink",@"Firmware Issue",@"Ink Contaminated",@"Loose Part",@"Maintenance",@"Nozzle Out Non-Recoverable",@"Nozzle Out Recoverable/Intermittent",@"out of Alignment",@"Part Failure",@"Process Issue",@"Solvent System Failure",@"Unknown",@"Vacuum System Failure",@"Wrong Ink",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Chillers"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Assembly Defect",@"Assembly Issue",@"Contaminated",@"Damaged",@"Documentation",@"Environmental",@"Environmental Issue - Heat Contaminant",@"General Error",@"Incoming Air Issue",@"Incoming Power Issue",@"Incorrect Settings",@"Loose Part",@"Maintenance",@"Missing Part",@"Out of Calibration",@"Overheating",@"Part Failure",@"Printer Location Issue",@"Printer Ventilation",@"Process/Training Issue",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Unknown",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Corona"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Alignment Issue",@"Assembly Defect",@"Assembly Issue",@"Contaminated",@"Damaged",@"Documentation",@"Environmental",@"Environmental Issue - Heat/Contaminant",@"Firmware Issue",@"General Error",@"Incoming Power Issue",@"Incorrect Firmware Version",@"Incorrect Settings",@"Loose Part",@"Maintenance",@"Media Issue",@"Missing Part",@"Out of Alignment",@"Out of Calibration",@"Overheating",@"Part Failure",@"Printer Location Issue",@"Printer Ventilation",@"Process/Training Issue",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Unknown",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Curing System"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Air System Failure",@"Assembly Defect",@"Assembly Issue",@"Contaminated",@"Cured Ink",@"CuringIssue",@"Damaged",@"Documentation",@"Environmental",@"Environmental Issue - Heat/Contaminant",@"Expired Ink",@"General Error",@"Incoming Power Issue",@"Incorrect Settings",@"Ink Contaminated",@"Loose Part",@"Maintenance",@"Media",@"Media Issue",@"Missing Part",@"Nitrogen System",@"Overheating",@"Part Failure",@"Printer Location Issue",@"Printer Ventilation",@"Process/Training Issue",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Unknown",@"Wrong Ink",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Customer"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Environmental",@"Incoming Air Issue",@"Incoming Power Issue",@"Maintenance",@"Media",@"Media Issue",@"No Internet/Network",@"Non Fiery XF RIP",@"Printer Location Issue",@"Printer Ventilation",@"Process/Training Issue",@"Unknown",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"DSP"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Ink Sticking to Platen",@"Loose Part",@"Media Issue",@"Missing Part",@"Out of Alignment",@"Part Failure",@"Process Issue",@"Registration Issue",@"Software Issue",@"Unknown",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Electronics Box"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Environmental Issue - Heat/Contaminant",@"Firmware Issue",@"Loose Part",@"Maintenance",@"Missing Part",@"Part Failure",@"Process Issue",@"Reseated Part",@"Unknown",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Finishing"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Air System Failure",@"Alignment Issue",@"Assembly Defect",@"Assembly Issue",@"Contaminated",@"Cured Ink",@"Curing Issue",@"Damaged",@"Documentation",@"Environmental",@"Environmental Issue - Heat/Contaminant",@"Expired Ink",@"Firmware Issue",@"General Error",@"Incoming Air Issue",@"Incoming Power Issue",@"Incorrect Firmware Version",@"Incorrect Settings",@"Incorrect Software Version",@"Ink Contaminated",@"Ink System Failure",@"Loose Part",@"Maintenance",@"Media",@"Media Issue",@"Missing Part",@"No Internet/ Network",@"Out Of Alignment",@"Out Of Calibration",@"Overheating",@"Part Failure",@"Printer Ventilation",@"Process/Training Issue",@"Registration Issue",@"Repeatability",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Software Issue",@"Tension Issue",@"Unknown",@"Wrong Ink",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Frame Assy"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Loose Part",@"Missing Part",@"Part Failure",@"Process Issue",@"Rust/Corrosion",@"Unknown",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Ink Box"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Air System Failure",@"Damaged",@"Environmental Issue - Heat/Contaminant",@"Expired Ink",@"Firmware Issue",@"Ink Contaminated",@"Loose Part",@"Maintenance",@"Nitrogen System",@"Part Failure",@"Process Issue",@"Unknown",@"Vacuum System Failure",@"Wrong Ink",@"Wrong Part",nil];
            
        }
        
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Ink System"] ||[newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Movements"] ||[newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Printing Electronics"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Unknown",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Lamp System"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Environmental",@"Loose Part",@"Maintenance",@"Nitrogen System",@"Overheating",@"Part Failure",@"Process Issue",@"Unknown",@"Wrong Part",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Laser"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Air System Failure",@"Alignment Issue",@"Assembly Defect",@"Assembly Issue",@"Contaminated",@"Damaged",@"Documentation",@"Environmental",@"Environmental Issue - Heat/Contaminant",@"Fiery XF Issue",@"Firmware Issue",@"General Error",@"Incoming Air Issue",@"Incoming Power Issue",@"Incorrect Firmware Version",@"Incorrect Settings",@"Incorrect Software Version",@"Loose Part",@"Maintenance",@"Media Issue",@"Missing Part",@"No Internet/ Network",@"Out Of Alignment",@"Out Of Calibration",@"Overheating",@"Part Failure",@"Printer Ventilation",@"Process/Training Issue",@"Registration Issue",@"Repeatability",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Software Issue",@"Tension Issue",@"Unknown",@"Vacuum Issue",@"Vacuum System Failure",@"Wrong Ink",@"Wrong Part",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Media Transport "]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Damaged",@"Environmental",@"Loose Part",@"Maintenance",@"Media Issue",@"Out of Alignment",@"Part Failure",@"Process Issue",@"Tension Issue",@"Unknown",@"Unwinder/Rewinder General",@"Vacuum Issue",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Power Distribution"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Assembly Defect",@"Assembly Issue",@"Damaged",@"Documentation",@"Environmental",@"General Error",@"Incoming Power Issue",@"Incorrect Settings",@"Loose Part",@"Maintenance",@"Missing Part",@"Overheating",@"Part Failure",@"Printer Location Issue",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Unknown",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Print Zone"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Alignment Issue",@"Assembly Defect",@"Assembly Issue",@"Carriage Crash",@"Contaminated",@"Cured Ink",@"Damaged",@"Environmental",@"Environmental Issue - Heat/Contaminant",@"Firmware Issue",@"General Error",@"Incorrect Firmware Version",@"Incorrect Software Version",@"Ink Sticking to Platen",@"Loose Part",@"Maintenance",@"Media Issue",@"Missing Part",@"Nozzle Out Non-Recoverable",@"Nozzle Out Recoverable/Intermittent",@"Out of Alignment",@"Out of Calibration",@"Overheating",@"Part Failure",@"Process/Training Issue",@"Registration Issue",@"Repeatability",@"Reseated Part",@"Rust/Corrosion",@"Safety Feature Overridden",@"Tension Issue",@"Unknown",@"Wrong Part",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Safety"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Carriage Crash",@"Damaged",@"Loose Part",@"Out of Alignment",@"Part Failure",@"Process Issue",@"Safety Feature Overridden",@"Unknown",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Software"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Fiery XF Issue",@"General Error",@"Incorrect Firmware Version",@"Incorrect Settings",@"Incorrect Software Version",@"Process/Training Issue",@"Smooting Mask Issue",@"Unknown",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@" T Box"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Assembly Issue",@"Damaged",@"Environmental",@"Loose Part",@"Maintenance",@"Part Failure",@"Process Issue",@"Unknown",@"Wrong Part",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Tools"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Assembly Issue",@"Damaged",@"Missing Part",@"Missing Toolkit",@"Out of Calibration",@"Process Issue",@"Repeatability",@"Unknown",@"Wrong Tooling",nil];
            
        }
        if ([newServiceResultsSystemButton.titleLabel.text isEqualToString:@"Ventilation"]) {
            
            pickerNewServiceResultsRootCauseArray = nil;
            
            pickerNewServiceResultsRootCauseArray = [[NSMutableArray alloc]initWithObjects:@"Assembly Defect",@"Assembly Issue",@"Damaged",@"Documentation",@"Environmental",@"Environmental Issue - Heat/Contaminant",@"General Error",@"Incoming Power Issue",@"Incorrect Settings",@"Loose Part",@"Maintenance",@"Missing Part",@"Overheating",@"Part Failure",@"Printer Location Issue",@"Printer Ventilation",@"Process/Training Issue",@"Reseated Part",@"Rust/Corrosion",@"Unknown",@"Wrong Part",nil];
            
        }
        
    }
    
    [self showActionViewWithTitle:@"New Service Result RootCause"];
    
    [actionView setHidden:NO];
    
}


- (IBAction)serviceResultsInformationCancelBtnAction:(id)sender {
    
    [serviceResultsInformationView setHidden:YES];
}

- (IBAction)serviceResultsInformationEditBtnAction:(id)sender {
    
    _isEditing = YES;
    
    [newServiceResultsProductButton setBackgroundImage:nil forState:UIControlStateNormal];
    [newServiceResultsSystemButton setBackgroundImage:nil forState:UIControlStateNormal];
    [newServiceResultsSubSystems setBackgroundImage:nil forState:UIControlStateNormal];
    [newServiceResultsRootCauseButton setBackgroundImage:nil forState:UIControlStateNormal];
    [newServiceResultsSymptomsButton setBackgroundImage:nil forState:UIControlStateNormal];
    [newServiceResultsActionTakenButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    newServiceResultsWorkOrderLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
    newServiceResultsOrderActivityLabel.text = [[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Name"];
    [newServiceResultsProductButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] forState:UIControlStateNormal];
    [newServiceResultsSystemButton setTitle:[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"System__c"] forState:UIControlStateNormal];
    [newServiceResultsSubSystems setTitle:[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Sub_Systems__c"] forState:UIControlStateNormal];
    [newServiceResultsRootCauseButton setTitle:[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Root_Cause__c"] forState:UIControlStateNormal];
    [newServiceResultsRootCauseButton setTitle:[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Root_Cause__c"] forState:UIControlStateNormal];
    [newServiceResultsSymptomsButton setTitle:[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Symp__c"] forState:UIControlStateNormal];
    [newServiceResultsActionTakenButton setTitle:[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Action_Taken__c"] forState:UIControlStateNormal];
    newServiceResultsDurationField.text =[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Duration__c"];
    newServiceResultsDetailsField.text =[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Details__c"];

    [serviceResultsInformationView setHidden:YES];
    [newServiceResultsView setHidden:NO];
}


- (IBAction)newPartsUsedBtnAction:(id)sender {
    
    // To be modified here:
    
    subResultsOrderLabel.text=[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Name"];
    
    
   // NSDictionary * dict1 =[WOTimeArray objectAtIndex:indexPath.row];
    //[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"]
    
   // subResultsOrderLabel.text=[dict objectForKey:@"Id"];
    newPartsUsedBackgroundScrollView.contentSize = CGSizeMake(0.0f, 1000.0f);
    
    CGFloat yPos = 10;
    tempPartUsedValue = 0;
    
    for (UIView *view in newPartsUsedBackgroundScrollView.subviews) {
        
        if ([view isKindOfClass:[FSAddPartView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSDictionary *partsUsedDict in WOPartsUsedArray) {
        FSAddPartView * addPart =[[[NSBundle mainBundle] loadNibNamed:@"FSAddPartView" owner:self options:nil] objectAtIndex:0];
        
        // For to not delete comment tag and delegate
        addPart.tag = [WOPartsUsedArray indexOfObject:partsUsedDict];
        addPart.delegate = self;

        yPos = ([WOPartsUsedArray indexOfObject:partsUsedDict] * 60.0f) +10.0f;
        [addPart setFrame:CGRectMake(0, yPos, 650, 60)];
        [addPart setUpData:partsUsedDict];
        [newPartsUsedBackgroundScrollView addSubview:addPart];
    }
    
    
     [newPartsUsedView setHidden:NO];
}



- (IBAction)newOrderBtnAction:(id)sender {
    
    [newOrderButton setHidden:NO];
    
    newOrderWOLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
    
    [newOrderView setHidden:NO];
    
}

- (IBAction)newOrderCloseBtnAction:(id)sender {
    
    [newOrderView setHidden:YES];
    
    [newOrderPriorityButton setTitle:@"" forState:UIControlStateNormal];
    [newOrderShippingMethodButton setTitle:@"" forState:UIControlStateNormal];
    
    
    [newOrderPrinterCheckBoxButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    descriptionLabel.text = @"";

}

- (IBAction)newOrderPriorityBtnAction:(id)sender {
    
    pickerNewOrderPriorityArray = [[NSMutableArray alloc]initWithObjects:@"P1",@"P2",@"P3",@"P4", nil];
    
    [self showActionViewWithTitle:@"New Order Priority"];
    
    [actionView setHidden:NO];

    
    
}

- (IBAction)newOrderShippingMethodBtnAction:(id)sender {
    
    if ([newOrderPriorityButton.titleLabel.text isEqualToString:@"P1"]) {
    
        pickerNewOrderShippingMethodArray = [[NSMutableArray alloc]initWithObjects:@"Priority Overnight (10:30 am)",@"Standard Overnight (4:00 pm)",@"Special Saturday", nil];

    
    }
    if ([newOrderPriorityButton.titleLabel.text isEqualToString:@"P2"]) {
        
        pickerNewOrderShippingMethodArray = [[NSMutableArray alloc]initWithObjects:@"Standard Overnight (4:00 pm)",@"2-Day Air",@"3-Day Air", nil];
        
        
    }
    if ([newOrderPriorityButton.titleLabel.text isEqualToString:@"P3"]) {
        
        pickerNewOrderShippingMethodArray = [[NSMutableArray alloc]initWithObjects:@"Ground", nil];
        
        
    }
    if ([newOrderPriorityButton.titleLabel.text isEqualToString:@"P4"]) {
        
        pickerNewOrderShippingMethodArray = [[NSMutableArray alloc]initWithObjects:@"Ground", nil];
        
        
    }

    
    [self showActionViewWithTitle:@"New Order Shipping Method"];
    
    [actionView setHidden:NO];

}


- (IBAction)newOrderPrinterCheckBoxBtnAction:(id)sender {
    
    newOrderCheckboxSelected = !newOrderCheckboxSelected;
    if (newOrderCheckboxSelected == NO)
        
        [newOrderPrinterCheckBoxButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    else
        [newOrderPrinterCheckBoxButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
}


- (IBAction)newOrderSubmitBtnAction:(id)sender {
    
    NSTimeInterval startDateSeconds = [[NSDate date] timeIntervalSince1970];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSeconds];
    
//    formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"];

    NSString * EffectiveDate = [formatter stringFromDate:startDate];

    NSLog(@"%@",serviceOrdersArray);
    NSDictionary * newOrderDict;
    
    if (newOrderCheckboxSelected) {
       
        newOrderDict = @{@"Priority__c":newOrderPriorityButton.titleLabel.text,
                         @"ShippingMethod__c":newOrderShippingMethodButton.titleLabel.text,
                         @"PrinterDown__c":@YES,
                         @"Description":newOrderDescriptionField.text,
                         @"AccountId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account__c"],
                         @"Asset_del__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"],
                         @"Case__C":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case__c"],
                         @"Work_Order__C":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                         @"ShipToContactId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact__c"],
                         @"EffectiveDate":EffectiveDate,
                         @"Status":@"Draft",
                         
                         };
        
    } else {
        
        newOrderDict = @{@"Priority__c":newOrderPriorityButton.titleLabel.text,
                                        @"ShippingMethod__c":newOrderShippingMethodButton.titleLabel.text,
                                        @"PrinterDown__c":@NO,
                                        @"Description":newOrderDescriptionField.text,
                                        @"AccountId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account__c"],
                                        @"Asset_del__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"],
                                        @"Case__C":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case__c"],
                                        @"Work_Order__C":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                                        @"ShipToContactId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact__c"],
                         
                         @"EffectiveDate":EffectiveDate,
                         @"Status":@"Draft",

                                        };
        
    }
    
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString * udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
    
    NSString *newString = [udidString substringToIndex:8];
    
    NSDictionary * newOrderLocalDict = @{@"Id":@"",
                                         @"AccountId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account__c"],
                                         @"Asset_del__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"],
                                         @"Case__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case__c"],
                                         @"Description":@"",
                                         @"EffectiveDate":@"",
                                         @"Error_Message__c":@"",
                                         @"OrderNumber":newString,
                                         @"Pricebook2Id":@"",
                                         @"Priority__c":@"",
                                         @"PrinterDown__c":@"",
                                         @"Send_to_SAP__c":@"",
                                         @"ShipToContactId":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact__c"],
                                         @"ShippingMethod__c":@"",
                                         @"Status":@"Draft",
                                         @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]
                                         };
    
    [orderArray addObject:newOrderLocalDict];
    [orderArray insertObject:newOrderLocalDict atIndex:0];

    NSLog(@"orderArray:%@",orderArray);
    
    [activitiesTableView reloadData];
    
    SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"Order" fields:newOrderDict];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];

    [newOrderView setHidden:YES];
    
    [newOrderPriorityButton setTitle:@"" forState:UIControlStateNormal];
    [newOrderShippingMethodButton setTitle:@"" forState:UIControlStateNormal];
    
//    expensesOverCheckboxSelected = YES;
    
    [newOrderPrinterCheckBoxButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    
    newOrderDescriptionField.text = nil;

}

// add Products Button Action






- (IBAction)addProductBtnAction:(id)sender {
    
    

    [addProductPartNumberTableView setHidden:YES];
    addProductForOrderPartNumberLabel.text=[[orderArray objectAtIndex:selectedServiceRow]objectForKey:@"OrderNumber"];
    
    // NSDictionary * dict1 =[WOTimeArray objectAtIndex:indexPath.row];
    //[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"]
    
    // subResultsOrderLabel.text=[dict objectForKey:@"Id"];
    addProductsBackgroundScrollView.contentSize = CGSizeMake(0.0f, 1000.0f);
    
    CGFloat yPos = 10;
    tempNewPartUsedValue = 0;
    
    for (UIView *view in addProductsBackgroundScrollView.subviews) {
        
        if ([view isKindOfClass:[FSAddNewPartView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSDictionary *newPartsUsedDict in WOPartsUsedArray) {
        FSAddNewPartView * addNewPart =[[[NSBundle mainBundle] loadNibNamed:@"FSAddNewPartView" owner:self options:nil] objectAtIndex:0];
        
        // For to not delete comment tag and delegate
        addNewPart.tag = [WOPartsUsedArray indexOfObject:newPartsUsedDict];
        
        addNewPart.delegate = self;
        addNewPart.addProductDeleteButton.tag = addNewPart.tag;

        yPos = ([WOPartsUsedArray indexOfObject:newPartsUsedDict] * 60.0f) +10.0f;
        [addNewPart setFrame:CGRectMake(0, yPos, 650, 60)];
        [addNewPart setUpAddNewData:newPartsUsedDict];
        [addProductsBackgroundScrollView addSubview:addNewPart];
    }
    
    [addProductView setHidden:NO];

    
    // Old data:
//    addProductsBackgroundScrollView.contentSize = CGSizeMake(0.0f, 400.0f);
//    
//    addProductForOrderPartNumberLabel.text = [productsDict objectForKey:@"OrderNumber"];
//    [addProductView setHidden:NO];
// 
}

- (IBAction)addPartProductButtonAction:(id)sender {
   
    tempNewPartUsedValue = tempNewPartUsedValue + 1;
    
    CGFloat yPos = ((WOPartsUsedArray.count + (tempNewPartUsedValue-1))*60)+10;
    
    FSAddNewPartView *addNewPartView = [[[NSBundle mainBundle] loadNibNamed:@"FSAddNewPartView" owner:self options:nil] objectAtIndex:0];
    
    // For to not delete comment tag and delegate
    
    addNewPartView.tag = WOPartsUsedArray.count + (tempNewPartUsedValue - 1) + 1;
    addNewPartView.delegate = self;
    addNewPartView.addProductPartNumberSearchBar.delegate = self;
    addNewPartView.frame = CGRectMake(0, yPos, 646, 60);
    
    
    [addProductsBackgroundScrollView addSubview:addNewPartView];
}


- (IBAction)closeProductBtnAction:(UIButton *)sender {
    
    [addProductView setHidden:YES];
}


- (IBAction)submitProductButtonAction:(id)sender {
    
    NSDictionary * newProductDict1 = [[NSDictionary alloc]init];
    
    NSDictionary * newProductLocalDict = [[NSDictionary alloc]init];
    NSInteger newParts=0;
    
    for (UIView *view in addProductsBackgroundScrollView.subviews) {
        
        if ([view isKindOfClass:[FSAddNewPartView class]])  {
            
            FSAddNewPartView * addNewParts1 = (FSAddNewPartView *)view;
            
            newProductDict1 =@{@"Part_Name__c":addNewParts1.addProductPartNumberSearchBar.text,
                               @"Quantity":addNewParts1.addProductQuantity.text,
                               @"OrderID":[[orderProductsArray objectAtIndex:0] objectForKey:@"OrderId"],
                               @"PricebookEntryId":[[orderProductsArray objectAtIndex:0] objectForKey:@"PricebookEntryId"],
                               @"UnitPrice":[[orderProductsArray objectAtIndex:0] objectForKey:@"UnitPrice"],
                               @"Work_Order__c":[[orderProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                                           };
            
            NSLog(@"newPaersUsedDict %@",newProductDict1);
            
            newParts++;
            
            SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"OrderItem" fields:newProductDict1];
            
            [[SFRestAPI sharedInstance] send:request delegate:self];
            
            
            CFUUIDRef udid = CFUUIDCreate(NULL);
            NSString * udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
            
            NSString *newString = [udidString substringToIndex:8];
            
            newProductLocalDict= @{@"Id":@"",
                                   @"Material_Part_Number__c":newString,
                                    @"Part_Name__c":addNewParts.addProductPartNumberSearchBar.text,
                                    @"Unused_Quantity__c":@"",
                                    @"Quantity":addNewParts.addProductQuantity.text,
                                    @"UnitPrice":[[orderProductsArray objectAtIndex:0] objectForKey:@"UnitPrice"],
                                    @"PricebookEntryId":[[orderProductsArray objectAtIndex:0] objectForKey:@"PricebookEntryId"],
                                    @"OrderId":[[orderProductsArray objectAtIndex:0] objectForKey:@"OrderId"],
                                    @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]
                                                                   };
            
            //        NSLog(@"%@",newPaersUsedLocalDict);
            [orderProductsArray addObject:newProductLocalDict];
            
            
        }
        
    }
    
    //    for (int i=(int)filteredArray.count; i<partsTag; i++) {
    
    
    //    }
    
    
    NSSet * set = [NSSet setWithArray:orderProductsArray];
    [orderProductsArray removeAllObjects];
    [orderProductsArray addObjectsFromArray:[set allObjects]];
    
    [partsUsedTableView reloadData];
    
    [addProductView setHidden:YES];
//    [partsUsedView setHidden:NO];

    
//    NSDictionary * newProductDict1 = [[NSDictionary alloc]init];
//    
//    NSDictionary * newProductDict1LocalDict = [[NSDictionary alloc]init];
//    
//    for (UIView *view in addProductsBackgroundScrollView.subviews) {
//        
//        if ([view isKindOfClass:[FSAddNewPartView class]])  {
//            
//            addNewParts = [[FSAddNewPartView alloc]init];
//            
//            if (orderProductsArray.count < addNewParts.addProductDeleteButton.tag) {                
//                newProductDict1 = @{@"OrderID":[[orderProductsArray objectAtIndex:0] objectForKey:@"OrderId"],@"PricebookEntryId":[[orderProductsArray objectAtIndex:0] objectForKey:@"PricebookEntryId"],@"UnitPrice":[[orderProductsArray objectAtIndex:0] objectForKey:@"UnitPrice"],@"Work_Order__c":[[orderProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"],@"Quantity":addNewParts.addProductQuantity.text,
//            };
//                
//            }
//        }
//    }
//    
//    newProductDict1LocalDict= @{@"Id":@"",
//                                @"Material_Part_Number__c":@"",
//                                @"Part_Name__c":addNewParts.addProductPartNumberSearchBar.text,
//                                @"Unused_Quantity__c":@"",
//                                @"Quantity":addNewParts.addProductQuantity.text,
//                                @"UnitPrice":[[WOOrderProductsArray objectAtIndex:0] objectForKey:@"UnitPrice"],
//                                @"PricebookEntryId":[[WOOrderProductsArray objectAtIndex:0] objectForKey:@"PricebookEntryId"],
//                                @"OrderId":[[WOOrderProductsArray objectAtIndex:0] objectForKey:@"OrderId"],
//                                @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]
//                                
//                                };
//    
//    [orderProductsArray addObject:newProductDict1LocalDict];
//    
//    [partsUsedTableView reloadData];
//    
//    [addProductView setHidden:YES];
}

- (IBAction)cancelNewPartsButtonAction:(id)sender {
    
    
    [newPartsUsedView setHidden:YES];
}


- (IBAction)addPartServiceResultsBtnAction:(id)sender {
    
    tempPartUsedValue = tempPartUsedValue + 1;
     
  CGFloat yPos = ((WOPartsUsedArray.count + (tempPartUsedValue-1))*60)+10;
        
    FSAddPartView *addPartView = [[[NSBundle mainBundle] loadNibNamed:@"FSAddPartView" owner:self options:nil] objectAtIndex:0];
    
    // For to not delete comment tag and delegate
    addPartView.tag = WOPartsUsedArray.count + (tempPartUsedValue - 1) + 1;

    addPartView.delegate = self;
    
    addPartView.deleteButton.tag = addPartView.tag;
    
    NSLog(@"%ld",(long)addPartView.deleteButton.tag);

    addPartView.partNumberSearchBar.delegate = self;
    addPartView.frame = CGRectMake(0, yPos, 646, 60);

    [newPartsUsedBackgroundScrollView addSubview:addPartView];
}
//{
//    
//        if ([newPartsUsedForServiceResultsDetailedView1 isHidden])
//        {
//            [newPartsUsedForServiceResultsDetailedView1 setHidden:NO];
//            [newPartsUsedForServiceResultsDetailedView2 setHidden:YES];
//            [newPartsUsedForServiceResultsDetailedView3 setHidden:YES];
//            
//            return;
//        }
//        
//        
//        else if ([newPartsUsedForServiceResultsDetailedView2 isHidden]){
//            
//            [newPartsUsedForServiceResultsDetailedView2 setHidden:NO];
//            return;
//            
//        }
//        
//        else if ([newPartsUsedForServiceResultsDetailedView3 isHidden])
//        {
//            
//            [newPartsUsedForServiceResultsDetailedView3 setHidden:NO];
//            return;
//            
//        }
//    
//}

- (IBAction)addPartServiceResultsSubmitBtnAction:(id)sender {
    
    
    NSDictionary * newPaersUsedDict = [[NSDictionary alloc]init];
    
    NSDictionary * newPaersUsedLocalDict = [[NSDictionary alloc]init];
    NSInteger newParts=0;

    for (UIView *view in newPartsUsedBackgroundScrollView.subviews) {
        
        if ([view isKindOfClass:[FSAddPartView class]])  {
            
            FSAddPartView * addParts1 = (FSAddPartView *)view;
            
            newPaersUsedDict =@{@"Quantity__c":  addParts1.usedQuantity.text,
                                @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                                @"Service_Results__c":[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Id"],
                                @"Part_Number__c":addParts1.partNumberSearchBar.text,
                                @"Source__c":addParts1.sourceButton.titleLabel.text,
                                };
            
                NSLog(@"newPaersUsedDict %@",newPaersUsedDict);

            newParts++;
            
            SFRestRequest * request = [[SFRestAPI sharedInstance]requestForCreateWithObjectType:@"Other_Part_Used__c" fields:newPaersUsedDict];
            
            [[SFRestAPI sharedInstance] send:request delegate:self];
            
            
            CFUUIDRef udid = CFUUIDCreate(NULL);
            NSString * udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
            
            NSString *newString = [udidString substringToIndex:8];
            
            newPaersUsedLocalDict= @{@"Quantity__c":@"",
                                     @"Work_Order__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"],
                                     @"Service_Results__c":[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Id"],
                                     @"Product__c":[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"],
                                     @"Id":@"",
                                     @"Part_Number__c":newString,
                                     @"Source__c":@"",
                                     
                                     };
            
            //        NSLog(@"%@",newPaersUsedLocalDict);
            [otherPartsUsedArray addObject:newPaersUsedLocalDict];


        }
    
    }
    
//    for (int i=(int)filteredArray.count; i<partsTag; i++) {
    

//    }
    

    NSSet * set = [NSSet setWithArray:otherPartsUsedArray];
    [otherPartsUsedArray removeAllObjects];
    [otherPartsUsedArray addObjectsFromArray:[set allObjects]];
    
    [partsUsedTableView reloadData];
    
    [addProductView setHidden:YES];
    [partsUsedView setHidden:NO];
    
}


- (void)orderActivateBtnAction:(UIButton *)sender {
    
    if (WOOrderProductsArray.count == 0) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"No Products" message:@"No Products found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else {
        
        
        workOrder = [WOOrderArray objectAtIndex:sender.tag];
        workOrder.wSendToSapC = !workOrder.wSendToSapC;
        NSMutableArray *workOrderArray =[[NSMutableArray alloc] init];
        
        for (NSDictionary *tempDict in orderArray) {
            if ([[tempDict objectForKey:@"Work_Order__c"] isEqualToString:workOrder.wWorkOrderC ]) {
                
                [workOrderArray addObject:tempDict];
                
            }
            
        }
        NSDictionary *tempDict = [workOrderArray objectAtIndex:sender.tag];
        [tempDict setValue:[NSString stringWithFormat:@"%i",workOrder.wSendToSapC]forKey:@"Send_to_SAP__c"];
        
        if ([orderArray containsObject:tempDict]) {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [activitiesTableView reloadData];
            
        });
    }
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches [c] %@",workOrder.wWorkOrderC];
//    NSDictionary *dictValue = [[orderArray filteredArrayUsingPredicate:predicate] objectAtIndex:0];
//    [dictValue setValue:[NSString stringWithFormat:@"%i",workOrder.wSendToSapC] forKey:@"Send_to_SAP__c"];
    
//    NSLog(@"z%@",[orderArray filteredArrayUsingPredicate:predicate]);
    
    
}

#pragma mark serachbar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
        partsTag = searchBar.superview.tag;
    
    for (UIView *view in newPartsUsedBackgroundScrollView.subviews) {
        
        if ([view isKindOfClass:[FSAddPartView class]]) {

            FSAddPartView * addPartsView=(FSAddPartView *)view;
            if (addPartsView.tag==partsTag) {
                
                addParts = addPartsView;
            }
        }
    }
    
    for (UIView *view in addProductsBackgroundScrollView.subviews) {
        
        if ([view isKindOfClass:[FSAddNewPartView class]]) {
            
            FSAddNewPartView * addNewPartsView=(FSAddNewPartView *)view;
            if (addNewPartsView.tag==partsTag) {
                
                addNewParts = addNewPartsView;
            }
        }
    }


    NSLog(@"%ld",(long)partsTag);
        
    NSLog(@"%@",[searchBar.superview class]);
    
    [newPartsTableView setHidden:NO];
    [addProductPartNumberTableView setHidden:NO];
        
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar == addNewParts.addProductPartNumberSearchBar) {
        
//        [addProductsBackgroundScrollView bringSubviewToFront:addProductPartNumberTableView];
//        
//        NSLog(@"text %@   string %@",searchBar.text,searchText);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (filteredArray.count > 0) {
//                
//                filteredArray = nil;
//            }
//            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Material_Part_Number__c contains [cd] %@",searchBar.text];
//            
//            filteredArray = [orderProductsArray filteredArrayUsingPredicate:predicate];
//            
//            NSLog(@"%@",filteredArray);
//            
//            [addProductPartNumberTableView setContentOffset:CGPointMake(0.0f, 0.0f)];
//            
//            
//                [addProductPartNumberTableView reloadData];
//            
//        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (filteredArray.count > 0) {
                
                filteredArray = nil;
            }
            
            [addProductsBackgroundScrollView bringSubviewToFront:addProductPartNumberTableView];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Material_Part_Number__c contains [cd] %@",searchBar.text];
            
            filteredArray = [orderProductsArray filteredArrayUsingPredicate:predicate];
            
            NSLog(@"%@",filteredArray);
            
            [addProductPartNumberTableView reloadData];
            
        });


    } else if (searchBar == addParts.partNumberSearchBar) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (filteredArray.count > 0) {
                
                filteredArray = nil;
            }

            [newPartsUsedBackgroundScrollView bringSubviewToFront:newPartsTableView];

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Part_Number__c contains [cd] %@",searchBar.text];
            
            filteredArray = [otherPartsUsedArray filteredArrayUsingPredicate:predicate];
            
            NSLog(@"%@",filteredArray);
            
            [newPartsTableView reloadData];
            
        });

    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = NO;
    
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [addProductPartNumberTableView setHidden:YES];
    
    [searchBar resignFirstResponder];
    
}

- (void)saveSignatureImage {
    
    //    NSMutableArray * savingCaptureArray=[[NSMutableArray alloc]init];
    //create path to where we want the image to be saved
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    // NSLog(@"Signatur File Path: %@",filePath);
    //if the folder doesn't exists then just create one
    //        NSError *error = nil;
    //        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    //                [[NSFileManager defaultManager] createDirectoryAtPath:filePath
    //                                          withIntermediateDirectories:NO
    //                                                           attributes:nil
    //                                                                error:&error];
    //
    //        //convert image into .png format.
    NSData *imageData = UIImagePNGRepresentation(signatureBackgroundImageView.image);
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lilatest_signature.png",(long)selectedRow]];
    
    //creates an image file with the specified content and attributes at the given location
    [fileManager createFileAtPath:fileName contents:imageData attributes:nil];
    
    NSLog(@"image saved");
    
    [self showAlertView];
    
    //check if the display signature view controller doesn't exists then create it
}


- (void)showAlertView {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saving signature" message:@"Image Saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    alertView.tag = 2;
    
    [alertView show];
}

// Pushing to Installed Products Screen

- (IBAction)installedProductBtnAction:(id)sender {
    
    
    installedProductsView.userId=userId;
    
    installedProductsView._isPushing = YES;
    
    installedProductsView.installedProductsId = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Installed_Product__c"];
    
    
    installedProductsView.installedProductsName = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Installed_Product2__c"];
    
    
    [self.navigationController pushViewController:installedProductsView animated:YES];
    
}

// Pushing to Escalations Screen

- (IBAction)escalationsBtnAction:(id)sender {
    
    escalationView.workOrderId = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"];
    
    escalationView.userId = userId;
    
    escalationView.workOrderName = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
    
    [self.navigationController pushViewController:escalationView animated:YES];
    
}

// Navigate To Google Maps

- (IBAction)getDirectionsBtnAction:(id)sender {
    
    NSString * urlString = [NSString stringWithFormat:@"https://www.google.co.in/maps"];
    NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    
}

// Capturing Photo

- (IBAction)capturePhotoBtnAction:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [myAlertView show];
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


// Capturing Signature

- (IBAction)captureSignatureBtnAction:(id)sender {
    
    [captureSignatureView setHidden:NO];
    
    //create a frame for our signature capture based on whats remaining
    
    //    signatureView.delegate = self;
    //    signatureView.selectedRow = selectedRow;
    //
    [signatureBackgroundView setHidden:NO];
    //
    
    //    //allocate an image view and add to the main view
    //    signatureBackgroundImageView = [[UIImageView alloc] initWithImage:nil];
    
    
    //    [self.navigationController presentViewController:signatureView animated:YES completion:nil];
    //    [self.navigationController pushViewController:signatureView animated:YES];
    
}


- (IBAction)segmentedControlIndexChanged:(id)sender {
    
    NSIndexPath * indexPath;
    
    [newServiceResultsBtn setHidden:YES];
    
    [self activitiesRowClicked:indexPath];
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [newOrderButton setHidden:YES];
            
//            activitiesTableView.frame = CGRectMake(750, 115, 270, 200);

            [orderProductsView setHidden:YES];
            [newOrderView setHidden:YES];

            [timeLabel setHidden:YES];
            [timeAndExpensesTableView setHidden:YES];
            
            [activitiesTableView reloadData];
        });
        
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            [timeLabel setHidden:YES];
            [timeAndExpensesTableView setHidden:YES];
            
            [newOrderButton setHidden:NO];

            activitiesTableView.frame = CGRectMake(750, 150, 270, 200);

            [activitiesTableView reloadData];
            
        });
    }
    
}

- (IBAction)timeAndServiceResultsSegmentControlIndexChanged:(id)sender {
    
    if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 0){
        
        [timeAndExpensesTableView reloadData];
        
        timeAndExpensesTableView.frame = CGRectMake(750, 395, 270, 400);
        
        [serviceResultsInformationView setHidden:YES];
        
        [newServiceResultsView setHidden:YES];

        [newServiceResultsBtn setHidden:YES];
    }
    
    if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 1){
        
        [timeAndExpensesTableView reloadData];
        
        timeAndExpensesTableView.frame = CGRectMake(750, 445, 270, 400);
        
        [newServiceResultsBtn setHidden:NO];
        
    }
    
}


- (IBAction)caseInformationBtnAction:(id)sender {
    
    caseInfoScrollView.contentSize = CGSizeMake(0.0f, 760.0f);
    
    caseInfo = !caseInfo;
    
    if (caseInfo == NO) {
        
        [caseInformationButton setImage:[UIImage imageNamed:@"caseinfo.png"] forState:UIControlStateNormal];
        
        addressInformationButton.frame = CGRectMake(0, caseInformationButton.frame.origin.y+caseInformationButton.frame.size.height, 450, 60);
        
        if (addressInfo) {
            addressInformationView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 200);
            
            buttonsView.frame = CGRectMake(0, addressInformationView.frame.origin.y+addressInformationView.frame.size.height, 450, 140);
            captureImageView.frame = CGRectMake(125, buttonsView.frame.origin.y+buttonsView.frame.size.height, 200, 80);
            captureSignatureView.frame = CGRectMake(125, captureImageView.frame.origin.y+captureImageView.frame.size.height+20, 200, 80);
            
        } else {
            
            buttonsView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 140);
            captureImageView.frame = CGRectMake(125, buttonsView.frame.origin.y+buttonsView.frame.size.height, 200, 80);
            captureSignatureView.frame = CGRectMake(125, captureImageView.frame.origin.y+captureImageView.frame.size.height+20, 200, 80);
            
        }
        
        [caseInformationView setHidden:YES];
        
    } else {
        
        [caseInformationButton setImage:[UIImage imageNamed:@"_caseinfo.png"] forState:UIControlStateNormal];
        
        caseInformationView.frame = CGRectMake(0, caseInformationButton.frame.origin.y+caseInformationButton.frame.size.height, 450, 350);
        
        addressInformationButton.frame = CGRectMake(0, caseInformationView.frame.origin.y+caseInformationView.frame.size.height, 450, 60);
        
        if (addressInfo) {
            
            addressInformationView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 200);
            
            buttonsView.frame = CGRectMake(0, addressInformationView.frame.origin.y+addressInformationView.frame.size.height, 450, 140);
            captureImageView.frame = CGRectMake(125, buttonsView.frame.origin.y+buttonsView.frame.size.height, 200, 80);
            captureSignatureView.frame = CGRectMake(125, captureImageView.frame.origin.y+captureImageView.frame.size.height+20, 200, 80);
            
        } else {
            
            buttonsView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 140);
            captureImageView.frame = CGRectMake(125, buttonsView.frame.origin.y+buttonsView.frame.size.height, 200, 80);
            captureSignatureView.frame = CGRectMake(125, captureImageView.frame.origin.y+captureImageView.frame.size.height+20, 200, 80);
            
        }
        
        caseInformationView.hidden = NO;
        
    }
    
}


- (IBAction)addressInformationBtnAction:(id)sender {
    
    addressInfo = !addressInfo;
    
    if (addressInfo == NO) {
        
        [addressInformationButton setImage:[UIImage imageNamed:@"addressinfo.png"] forState:UIControlStateNormal];
        
        addressInformationView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 200);
        
        buttonsView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 140);
        captureImageView.frame = CGRectMake(125, buttonsView.frame.origin.y+buttonsView.frame.size.height, 200, 80);
        captureSignatureView.frame = CGRectMake(125, captureImageView.frame.origin.y+captureImageView.frame.size.height+20, 200, 80);
        
        addressInformationView.hidden = YES;
        
    } else {
        
        [addressInformationButton setImage:[UIImage imageNamed:@"_addressinfo.png"] forState:UIControlStateNormal];
        
        addressInformationView.frame = CGRectMake(0, addressInformationButton.frame.origin.y+addressInformationButton.frame.size.height, 450, 200);
        
        buttonsView.frame = CGRectMake(0, addressInformationView.frame.origin.y+addressInformationView.frame.size.height, 450, 140);
        captureImageView.frame = CGRectMake(125, buttonsView.frame.origin.y+buttonsView.frame.size.height, 200, 80);
        captureSignatureView.frame = CGRectMake(125, captureImageView.frame.origin.y+captureImageView.frame.size.height+20, 200, 80);
        
        addressInformationView.hidden = NO;
        
    }
    
}


-(void)showActionViewWithTitle:(NSString *)title {
    
    if(actionView) {
        actionView = nil;
    }
    
    pickerTitle = title;
    actionView = [[ASActionView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-300.0f, self.view.frame.size.width, 300)];
    
    [actionView setupActionViewWithPickerViewWithFrame:CGRectMake(0, 50.0f, self.view.frame.size.width, 300) target:self title:title];
    
    //[actiionView setBackgroundColor:[UIColor brownColor]];
    //    UIPickerView *picker = (UIPickerView *)[actionView viewWithTag:100];
    
    //    if ([title isEqualToString:@"Select Priority"]) {
    //        [picker selectRow:currentActivityNameRow inComponent:0 animated:YES];
    //    } else if ([title isEqualToString:@"Select ItemId"]) {
    //
    //        [picker selectRow:currentActivityNameRow inComponent:0 animated:YES];
    //
    //    } else {
    //
    //        [picker selectRow:currentPriorityRow inComponent:0 animated:YES];
    //    }
    
    [self.view setUserInteractionEnabled:NO];
    
    //    [backgroundScrollView addSubview:actionView];
    
    UIWindow* window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [[[window subviews] objectAtIndex:0] addSubview:actionView];
    
}


-(void)pickerviewDonePressed:(UIPickerView *)pickeview {
    
    [self.view setUserInteractionEnabled:YES];
    
    [actionView setHidden:YES];
    
}


-(void)pickerviewCancelPressed:(UIPickerView *)pickerview {
    
    [self.view setUserInteractionEnabled:YES];
    
    [actionView setHidden:YES];
    
}


#pragma mark - SFRestDelegate

// Storing Salesforce Response in Local Database

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [serviceTableView reloadData];
    });
    
    records = nil;
    
    records = [jsonResponse objectForKey:@"records"];
    
    
    if (records.count > 0) {
        
        if ([[records objectAtIndex:0] objectForKey:@"FConnect__Group_Members__r"]) {
            
            NSDictionary * technicianIdDict = [[[records objectAtIndex:0]objectForKey:@"FConnect__Group_Members__r"]objectForKey:@"records"];
            
            NSArray *dictValues=[technicianIdDict valueForKey:@"Id"];
            
            NSLog(@"technicianIdDict:%@",technicianIdDict);
            
            NSString * technician = [dictValues objectAtIndex:0];
            
            NSString *valueToSave = technician;
            
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"TechnicianId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //            success = [[DBManager getSharedInstance]saveTechnicianId:technician];
            //
            //            technicianIdArray = [[DBManager getSharedInstance]getTechnicianDetails];
            
//            NSLog(@"technicianArray:%@",technicianIdArray);
            
            [self callWorkOrderRequest];
            
        }
        
        if([[records objectAtIndex:0] objectForKey:@"FConnect__Account_Name__c"]) {
            
            [self saveData];
            
            [self willCallSecondRequest];
            
        } else if ([[records objectAtIndex:0] objectForKey:@"FConnect__Time__r"])  {
            
            [self saveTimeData];
            
            [self willCallThiredRequest];
            
 
        }
        else if([[records objectAtIndex:0] objectForKey:@"Body"]) {
            
            [self saveAttachmentsData];
            [self callServiceResultsRequest];
            
            
        } else if([[records objectAtIndex:0] objectForKey:@"Other_Part_Used__r"]) {
            
            [self saveServiceResultsData];
            
//            if (!_isSync1) {
//
//                [self callPricebookIdService];
//            }
            
//            [self callPricebookIdService];
            
        } else if([[[records objectAtIndex:0] objectForKey:@"Name"] isEqualToString:@"Inkjet Field Service"]) {
            
            
            pricebookId =[[records objectAtIndex:0] objectForKey:@"Id"];
            
            [self callPricebookEntryService];
            
            
        } else {
            
            [self savePricebookEntryData];
            
            
        }
        
    }
    
    NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
    
    
    
}

// Saving Activities in Local Database

- (void)willCallSecondRequest {
    
    SFRestRequest * request1 = [[SFRestAPI sharedInstance]requestForQuery:@"SELECT Id, Name, FConnect__Service_Order__c, (select id, FConnect__Activity__c, FConnect__Start_Date_Time__c, FConnect__End_Date_Time__c, FConnect__Type__c, FConnect__Comments__c, FConnect__Duration_MM__c from FConnect__Time__r), (select id, name, FConnect__Activity__c, FConnect__Expense_Type__c,  FConnect__Amount__c,FConnect__Technician_Date__c from FConnect__Expenses__r) FROM FConnect__Activitie__c"];
    
    [[SFRestAPI sharedInstance] send:request1 delegate:self];
    
}

//
//-(void)willCallOrderRequest {
//    
//    SFRestRequest * request1 = [[SFRestAPI sharedInstance]requestForQuery:@"SELECT OrderNumber, Priority__c , ShippingMethod__c , PrinterDown__c , Description ,Send_to_SAP__c,Error_Message__c, Status,AccountId,Asset_del__c,Case__c,ShipToContactId, Work_Order__c FROM Order"];
//    
//    [[SFRestAPI sharedInstance] send:request1 delegate:self];
//
//}



// Saving Attachments in Local Database

- (void)willCallThiredRequest {
    
    SFRestRequest * request1 = [[SFRestAPI sharedInstance]requestForQuery:@"Select ParentId,Name,Body FROM Attachment"];
    [[SFRestAPI sharedInstance] send:request1 delegate:self];
    
}


- (void)callServiceResultsRequest {
    
    SFRestRequest * request1 = [[SFRestAPI sharedInstance]requestForQuery:@"Select Id, Name, Action_Taken__c, CreatedDate__c, Details__c, Duration__c, Order_Activity__c, Root_Cause__c, Sub_Systems__c, Symp__c, System__c, (select Id, Part_Number__c, Work_Order__c, Service_Results__c, Product__c, Quantity__c, Source__c from Other_Part_Used__r) from Sub_Results__c"];
    [[SFRestAPI sharedInstance] send:request1 delegate:self];
    
}


// Display Work Order Information

- (void)saveData {
    
    for (int i=0; i<records.count; i++) {
        
        success = [[DBManager getSharedInstance]saveData:[[records objectAtIndex:i]objectForKey:@"Id"] name:[[records objectAtIndex:i]objectForKey:@"Name"] technician:[[records objectAtIndex:i]objectForKey:@"FConnect__Technician_used__c"] accountName:[[records objectAtIndex:i]objectForKey:@"FConnect__Account_Name__c"] accountId:[[records objectAtIndex:i]objectForKey:@"FConnect__Account__c"]  contactName:[[records objectAtIndex:i]objectForKey:@"ContactName__c"] phone:[[records objectAtIndex:i]objectForKey:@"contact_Phone__c"] email:[[records objectAtIndex:i]objectForKey:@"Contact_Email__c"] address:[[records objectAtIndex:i]objectForKey:@"FConnect__Bill_To_Address__c"] priority:[[records objectAtIndex:i]objectForKey:@"FConnect__Priority__c"] status:[[records objectAtIndex:i]objectForKey:@"CaseStatus__c"] caseId:[[records objectAtIndex:i]objectForKey:@"Case__c"] caseName:[[records objectAtIndex:i]objectForKey:@"Case_Name__c"] billable:[[records objectAtIndex:i]objectForKey:@"Billing_Status__c"] caseOwner:[[records objectAtIndex:i]objectForKey:@"Owner__c"] workOrderPriority:[[records objectAtIndex:i]objectForKey:@"casePriority__c"] regionalCoordinator:[[records objectAtIndex:i]objectForKey:@"Regional_Coordinator__c"] installedProductsId:[[records objectAtIndex:i]objectForKey:@"FConnect__Installed_Product__c"] installedProducts:[[records objectAtIndex:i]objectForKey:@"FConnect__Installed_Product2__c"] symptom:[[records objectAtIndex:i]objectForKey:@"Symptom__c"] serialNumber:[[records objectAtIndex:i]objectForKey:@"Serial_Number__c"] sybject:[[records objectAtIndex:i]objectForKey:@"Subject__c"] problemDescription:[[records objectAtIndex:i]objectForKey:@"FConnect__Problem_Description__c"] severity:[[records objectAtIndex:i]objectForKey:@"Severity__c"] product:[[records objectAtIndex:i]objectForKey:@"Product__c"] description:[[records objectAtIndex:i]objectForKey:@"CaseDescription__c"] modelItem:[[records objectAtIndex:i]objectForKey:@"Model_Item__c"] serviceType:[[records objectAtIndex:i]objectForKey:@"Service_Type__c"] sapSlodToBillToAccount:[[records objectAtIndex:i]objectForKey:@"SAP_Sold_To_Bill_To_AccountText__c"] actionTaken:[[records objectAtIndex:i]objectForKey:@"Action_Taken__c"] primaryAddress:[[records objectAtIndex:i]objectForKey:@"Primary_Address__c"] sapBillToAddress:[[records objectAtIndex:i]objectForKey:@"SAP_Bill_To_Address__c"] subRegion:[[records objectAtIndex:i]objectForKey:@"Sub_Region__c"] latittude:[[records objectAtIndex:i]objectForKey:@"Latitude__c"] longitude:[[records objectAtIndex:i]objectForKey:@"Longitude__c"]expensesOver50:[[records objectAtIndex:i]objectForKey:@"Expenses_over_50__c"] areaPrinted:[[records objectAtIndex:i]objectForKey:@"AreaPrinted__c"] areaUnits:[[records objectAtIndex:i]objectForKey:@"AreaUnit__c"] inkUsage:[[records objectAtIndex:i]objectForKey:@"InkUsage__c"] printTime:[[records objectAtIndex:i]objectForKey:@"PrintTime__c"] assetDel:[[records objectAtIndex:i]objectForKey:@"Asset__c"] contactId:[[records objectAtIndex:i]objectForKey:@"Contact__c"]];
        
        serviceOrdersArray = [[DBManager getSharedInstance]readInformationFromDatabase];
        
        if (![[[records objectAtIndex:i]objectForKey:@"FConnect__Activities__r"] isEqual:[NSNull null]]) {
            
            activityRecordsArray = [[[records objectAtIndex:i]objectForKey:@"FConnect__Activities__r"]objectForKey:@"records"];
            
            for (int j=0; j<activityRecordsArray.count; j++) {
                
                success = [[DBManager getSharedInstance]saveActivities:[[activityRecordsArray objectAtIndex:j]objectForKey:@"FConnect__Activity__c"] activityId:[[activityRecordsArray objectAtIndex:j]objectForKey:@"Id"] actvityName:[[activityRecordsArray objectAtIndex:j]objectForKey:@"Name"] activityStartDate:[[activityRecordsArray objectAtIndex:j]objectForKey:@"FConnect__Planned_Start_DateTime__c"] actvityEndDate:[[activityRecordsArray objectAtIndex:j]objectForKey:@"FConnect__Planned_End_Date_Time__c"] activityBillable:[[activityRecordsArray objectAtIndex:j]objectForKey:@"FConnect__Billable__c"] activityPriority:[[activityRecordsArray objectAtIndex:j]objectForKey:@"FConnect__Priority__c"]serviceOrderId:[[serviceOrdersArray objectAtIndex:i]objectForKey:@"Id"]];
                
                NSLog(@"Data Added:%c",success);
                
            }
            
        }
        
        if (![[[records objectAtIndex:i]objectForKey:@"Order_Products__r"] isEqual:[NSNull null]]) {
            
            reqMeterialRecordsArray = [[[records objectAtIndex:i]objectForKey:@"Order_Products__r"]objectForKey:@"records"];
            
            for (int j=0; j<reqMeterialRecordsArray.count; j++) {
                
                success = [[DBManager getSharedInstance]saveOrderProductsId:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Id"] orderId:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"OrderId"] materialPartNumber:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Material_Part_Number__c"] partName:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Part_Name__c"] unUsedQuantity:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Unused_Quantity__c"] usedQuantity:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Used_Quantity__c"] workOrderId:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Work_Order__c"]pricebookEntryId:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"PricebookEntryId"] quantity:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"Quantity"] unitPrice:[[reqMeterialRecordsArray objectAtIndex:j]objectForKey:@"UnitPrice"]];
                //    PricebookEntryId Quantity UnitPrice

            }
            
        }
        
        
        if (![[[records objectAtIndex:i]objectForKey:@"Orders__r"] isEqual:[NSNull null]]) {
            
            ordersRecordsArray = [[[records objectAtIndex:i]objectForKey:@"Orders__r"]objectForKey:@"records"];
           
            for (int c=0; c<ordersRecordsArray.count; c++) {
            
                success = [[DBManager getSharedInstance]saveOrderId:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Id"] caseId:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Case__c"] assetDel:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Asset_del__c"] description:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Description"] effectiveDate:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"EffectiveDate"] errorMessage:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Error_Message__c"] accountId:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"AccountId"] workOrderId:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Work_Order__c"] status:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Status"] shippingMethod:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"ShippingMethod__c"] shipToContactId:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"ShipToContactId"] sendtoSAP:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Send_to_SAP__c"] priority:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Priority__c"] printerDown:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"PrinterDown__c"] orderNumber:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"OrderNumber"] pricebook2Id:[[ordersRecordsArray objectAtIndex:c]objectForKey:@"Pricebook2Id"]];
            }
            
        }
        
        if (![[[records objectAtIndex:i]objectForKey:@"Assigned_Technician__r"] isEqual:[NSNull null]]) {
            
            assignedTechnicianRecordsArray = [[[records objectAtIndex:i]objectForKey:@"Assigned_Technician__r"]objectForKey:@"records"];
            
            for (int d=0; d<assignedTechnicianRecordsArray.count; d++) {
                
                success = [[DBManager getSharedInstance]saveAssignedTechnicianId:[[assignedTechnicianRecordsArray objectAtIndex:d]objectForKey:@"Id"] technicianId:[[assignedTechnicianRecordsArray objectAtIndex:d]objectForKey:@"Technician__c"] FSUserId:[[assignedTechnicianRecordsArray objectAtIndex:d]objectForKey:@"SF_User_ID__c"] name:[[assignedTechnicianRecordsArray objectAtIndex:d]objectForKey:@"Name"] estimatedStartDate:[[assignedTechnicianRecordsArray objectAtIndex:d]objectForKey:@"Estimated_Start_Date__c"] estimatedEndDate:[[assignedTechnicianRecordsArray objectAtIndex:d]objectForKey:@"Estimated_End_Date__c"]];
                
            }
            
        }
        
        if (![[[records objectAtIndex:i]objectForKey:@"RMA__r"] isEqual:[NSNull null]]) {
            
            RMARecordsArray = [[[records objectAtIndex:i]objectForKey:@"RMA__r"]objectForKey:@"records"];
            
            for (int j=0; j<RMARecordsArray.count; j++) {
                
                success = [[DBManager getSharedInstance]saveRMAId:[[RMARecordsArray objectAtIndex:j]objectForKey:@"Id"] orderProductId:[[RMARecordsArray objectAtIndex:j]objectForKey:@"Order_Product__c"] partNumber:[[RMARecordsArray objectAtIndex:j]objectForKey:@"Part_Number__c"] quantity:[[RMARecordsArray objectAtIndex:j]objectForKey:@"Quantity__c"] RMARequired:[[RMARecordsArray objectAtIndex:j]objectForKey:@"RMA_Required__c"] RMATrakingNumber:[[RMARecordsArray objectAtIndex:j]objectForKey:@"RMA_Tracking_Number__c"] workOrderId:[[RMARecordsArray objectAtIndex:j]objectForKey:@"Work_Order__c"] description:[[RMARecordsArray objectAtIndex:j]objectForKey:@"Description__c"]];
                
            }
            
        }
        
        assignedTechnicianArray = [[DBManager getSharedInstance]getAssignedTechnicianDetails];
        orderArray = [[DBManager getSharedInstance]getOrderDetails];
        
        activitiesArray = [[DBManager getSharedInstance]getActivities];
        
        NSLog(@"activitiesArray:%@",activitiesArray);
        
        orderProductsArray = [[DBManager getSharedInstance]getOrderProducts];
        
        RMAArray = [[DBManager getSharedInstance]getRMADetails];
        
    }
    
    
    
    [self showingServiceOrderDetails];
    
}


-(void)showingServiceOrderDetails {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _isSync = YES;
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSLog(@"Time:%@",appDelegate.myString);
        syncTimeLabel.text = appDelegate.myString;  //..to read
        
        [self attachImageAndSignature];
        
        // Get Case Information
        
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"] isEqualToString:@"<null>"]) {
            
            orderIdLabel.text =@"";
            
        } else {
            
            orderIdLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseStatus__c"] isEqualToString:@"<null>"]) {
            
            workOrderStatusLabel.text =@"";
            
        } else {
            
            workOrderStatusLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseStatus__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case_Name__c"] isEqualToString:@"<null>"]) {
            
            caseLabel.text =@"";
            
        } else {
            
            caseLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case_Name__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Billing_Status__c"] isEqualToString:@"<null>"]) {
            
            billableLabel.text =@"";
            
        } else {
            
            billableLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Billing_Status__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Owner__c"] isEqualToString:@"<null>"]) {
            
            caseOwnerLabel.text =@"";
            
        } else {
            
            caseOwnerLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Owner__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"casePriority__c"] isEqualToString:@"<null>"]) {
            
            workOrderPriorityLabel.text =@"";
            
        } else {
            
            workOrderPriorityLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"casePriority__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account_Name__c"] isEqualToString:@"<null>"]) {
            
            accountLabel.text =@"";
            
        } else {
            
            accountLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account_Name__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Regional_Coordinator__c"] isEqualToString:@"<null>"]) {
            
            regionalCoordinatorLabel.text =@"";
            
        } else {
            
            regionalCoordinatorLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Regional_Coordinator__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Installed_Product2__c"] isEqualToString:@"<null>"]) {
            
            installedProductsLabel.text =@"";
            
        } else {
            
            installedProductsLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Installed_Product2__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"] isEqualToString:@"<null>"]) {
            
            symptomLabel.text =@"";
            
        } else {
            
            symptomLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
            
            serialNumberLabel.text =@"";
            
        } else {
            
            serialNumberLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"] isEqualToString:@"<null>"]) {
            
            subjectLabel.text =@"";
            
        } else {
            
            subjectLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Severity__c"] isEqualToString:@"<null>"]) {
            
            severityLabel.text =@"";
            
        } else {
            
            severityLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Severity__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] isEqualToString:@"<null>"]) {
            
            productLabel.text =@"";
            
        } else {
            
            productLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseDescription__c"] isEqualToString:@"<null>"]) {
            
            descriptionLabel.text =@"";
            
        } else {
            
            descriptionLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseDescription__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"] isEqualToString:@"<null>"])
        {
            modelItemLabel.text =@"";
            
        } else {
            
            modelItemLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"ContactName__c"] isEqualToString:@"<null>"]) {
            
            contactNameLabel.text =@"";
            
        } else {
            
            contactNameLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"ContactName__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"contact_Phone__c"] isEqualToString:@"<null>"]) {
            
            contactPhoneLabel.text =@"";
            
        } else {
            
            contactPhoneLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"contact_Phone__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact_Email__c"] isEqualToString:@"<null>"]) {
            
            contactEmailLabel.text =@"";
            
        } else {
            
            contactEmailLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact_Email__c"];
            
        }
        
        // Get Address Information
        
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Primary_Address__c"] isEqualToString:@"<null>"]) {
            
            primaryAddressLabel.text =@"";
            
        } else {
            
            primaryAddressLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Primary_Address__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"SAP_Bill_To_Address__c"] isEqualToString:@"<null>"]) {
            
            sapBillToAddressLabel.text =@"";
            
        } else {
            
            sapBillToAddressLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"SAP_Bill_To_Address__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Sub_Region__c"] isEqualToString:@"<null>"])
        {
            subRegionLabel.text =@"";
            
        } else {
            
            subRegionLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Sub_Region__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"] isEqualToString:@"<null>"]) {
            
            latittudeLabel.text =@"";
            
        } else {
            
            latittudeLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"] isEqualToString:@"<null>"]) {
            
            longitudeLabel.text =@"";
            
        } else {
            
            longitudeLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"];
        }
        
        
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"] isEqualToString:@"<null>"]) {
            
            closeWOSubjectField.text =@"";
            
        } else {
            
            closeWOSubjectField.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Problem_Description__c"] isEqualToString:@"<null>"]) {
            
            closeWOProblemDescriptionField.text =@"";
            
        } else {
            
            closeWOProblemDescriptionField.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Problem_Description__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Action_Taken__c"] isEqualToString:@"<null>"]) {
            
            [closeWOActionTakenButton setTitle:@"" forState:UIControlStateNormal];
            
        } else {
            
            [closeWOActionTakenButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Action_Taken__c"] forState:UIControlStateNormal];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] isEqualToString:@"<null>"]) {
            
            
            [closeWOProductButton setTitle:@"" forState:UIControlStateNormal];
            
        } else {
            
            [closeWOProductButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] forState:UIControlStateNormal];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"] isEqualToString:@"<null>"]) {
            
            
            [closeWOModelButton setTitle:@"" forState:UIControlStateNormal];
            
        } else {
            
            [closeWOModelButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"] forState:UIControlStateNormal];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"] isEqualToString:@"<null>"]) {
            
            [closeWOSymptomButton setTitle:@"" forState:UIControlStateNormal];
            
        } else {
            
            [closeWOSymptomButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"] forState:UIControlStateNormal];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaPrinted__c"] isEqualToString:@"<null>"]) {
            
            areaPrinted.text = @"";
            
        } else {
            
            areaPrinted.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaPrinted__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"InkUsage__c"] isEqualToString:@"<null>"]) {
            
            inkUsage.text = @"";
            
        } else {
            
            inkUsage.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"InkUsage__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"PrintTime__c"] isEqualToString:@"<null>"]) {
            
            printerTime.text = @"";
            
        } else {
            
            printerTime.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"PrintTime__c"];
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Expenses_over_50__c"] isEqualToString:@"<null>"]) {
            
            [expensesOver setHidden:YES];
            
        } else {
            
            if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Expenses_over_50__c"] isEqualToString:@"0"]) {
                
                [expensesOver setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                
            } else if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Expenses_over_50__c"] isEqualToString:@"1"]){
                
                [expensesOver setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
            }
            
        }
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaUnit__c"] isEqualToString:@"<null>"]) {
            
            [areaUnits setTitle:@"" forState:UIControlStateNormal];
            
        } else {
            
            [areaUnits setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaUnit__c"] forState:UIControlStateNormal];
            
        }
        
        [serviceTableView reloadData];
        [activitiesTableView reloadData];
        [timeAndExpensesTableView reloadData];
        
    });
    
}

// Display Activities and Time Information

-(void)saveTimeData {
    
    // time Quiery FConnect__Account_Name__c is null
    //    records = nil;
    
    for (int i=0; i<records.count; i++) {
        
        if (![[[records objectAtIndex:i]objectForKey:@"FConnect__Time__r"] isEqual:[NSNull null]]) {
            
            timeRecordsArray = [[[records objectAtIndex:i]objectForKey:@"FConnect__Time__r"]objectForKey:@"records"];
            
            for (int k=0; k<timeRecordsArray.count; k++) {
                
                success = [[DBManager getSharedInstance]saveTime:[[timeRecordsArray objectAtIndex:k]objectForKey:@"Id"] name:[[records objectAtIndex:i]objectForKey:@"Name"] timeActivity:[[timeRecordsArray objectAtIndex:k]objectForKey:@"FConnect__Activity__c"] timeStartDate:[[timeRecordsArray objectAtIndex:k]objectForKey:@"FConnect__Start_Date_Time__c"] timeEndDate:[[timeRecordsArray objectAtIndex:k]objectForKey:@"FConnect__End_Date_Time__c"]timeDuration:[[timeRecordsArray objectAtIndex:k]objectForKey:@"FConnect__Duration_MM__c"] comments:[[timeRecordsArray objectAtIndex:k]objectForKey:@"FConnect__Comments__c"] type:[[timeRecordsArray objectAtIndex:k]objectForKey:@"FConnect__Type__c"]];
            }
        }
        
        timeArray = [[DBManager getSharedInstance]getTime];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [activitiesTableView reloadData];
            [timeAndExpensesTableView reloadData];
            
        });
        
    }
    
    NSLog(@"timeArray:%@",timeArray);
    
}


-(void)saveServiceResultsData {
    
    for (int i=0; i<records.count; i++) {
        
        success = [[DBManager getSharedInstance]saveServiceResultsId:[[records objectAtIndex:i]objectForKey:@"Id"] name:[[records objectAtIndex:i]objectForKey:@"Name"] orderActivity:[[records objectAtIndex:i]objectForKey:@"Order_Activity__c"] rootCause:[[records objectAtIndex:i]objectForKey:@"Root_Cause__c"] subSystems:[[records objectAtIndex:i]objectForKey:@"Sub_Systems__c"] symptoms:[[records objectAtIndex:i]objectForKey:@"Symp__c"] system:[[records objectAtIndex:i]objectForKey:@"System__c"] actionTaken:[[records objectAtIndex:i]objectForKey:@"Action_Taken__c"] details:[[records objectAtIndex:i]objectForKey:@"Details__c"] createdDate:[[records objectAtIndex:i]objectForKey:@"CreatedDate__c"] duration:[[records objectAtIndex:i]objectForKey:@"Duration__c"]];
        
        serviceResultsArray = [[DBManager getSharedInstance]getServiceResultsDetails];
        
        
        if (![[[records objectAtIndex:i]objectForKey:@"Other_Part_Used__r"] isEqual:[NSNull null]]) {
            
            otherPartsUsedRecordsArray = [[[records objectAtIndex:i]objectForKey:@"Other_Part_Used__r"]objectForKey:@"records"];
            
            for (int j=0; j<otherPartsUsedRecordsArray.count; j++) {
                
                success = [[DBManager getSharedInstance]saveOtherPartsId:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Id"]partNumber:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Part_Number__c"] workOrder:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Work_Order__c"] serviceResults:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Service_Results__c"] product:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Product__c"] quantity:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Quantity__c"] source:[[otherPartsUsedRecordsArray objectAtIndex:j]objectForKey:@"Source__c"]];
                
                
            }
            
            otherPartsUsedArray = [[DBManager getSharedInstance] getOtherPartsUsedDetails];
            
            
        }
        
        
    }
    
    
}

-(void)savePricebookEntryData {
    
    for (int i=0; i<records.count; i++) {
        
        success = [[DBManager getSharedInstance]savePricebookEntryId:[[records objectAtIndex:i]objectForKey:@"Id"] materialPartNumber:[[records objectAtIndex:i]objectForKey:@"Material_Part_Number__c"] pricebook2Id:[[records objectAtIndex:i]objectForKey:@"Pricebook2Id"] product2Id:[[records objectAtIndex:i]objectForKey:@"Product2Id"] productCode:[[records objectAtIndex:i]objectForKey:@"ProductCode"] productName:[[records objectAtIndex:i]objectForKey:@"Product_Name__c"]];
        
        pricebookEntryArray = [[DBManager getSharedInstance] getPricebookEntryDetails];
        
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


-(void)callPricebookIdService {
    
    SFRestRequest * request1 = [[SFRestAPI sharedInstance]requestForQuery:@"SELECT Id,name FROM Pricebook2 WHERE Name LIKE 'Inkjet Field Service'"];
    [[SFRestAPI sharedInstance] send:request1 delegate:self];
    
}


-(void)callPricebookEntryService {
    
    NSString *theRequest = [NSString stringWithFormat:@"SELECT Id,Product2id,Productcode,Pricebook2id,material_part_number__c, Product_Name__c FROM PricebookEntry where Pricebook2id= '%@'",pricebookId];
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:theRequest];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
    
    
}


-(void)saveAttachmentsData {
    
    for (int i=0; i<records.count; i++) {
        
        success = [[DBManager getSharedInstance]saveAttachments:[[records objectAtIndex:i]objectForKey:@"ParentId"] Body:[[records objectAtIndex:i]objectForKey:@"Body"] Name:[[records objectAtIndex:i]objectForKey:@"Name"]];
        
        attachmentsArray = [[DBManager getSharedInstance]getAttachments];
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
    
    //    for (int i=0; i< attachmentsArray.count; i++) {
    //
    //        WOActivitiesArray = [[NSMutableArray alloc]init];
    //        for (int i =0; i<attachmentsArray.count; i++) {
    //            if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[attachmentsArray objectAtIndex:i]objectForKey:@"Id"]] ) {
    //
    //
    //
    //            }
    //        }
    //
    //        if (![[[attachmentsArray objectAtIndex:i]objectForKey:@"Name"] isEqualToString:@"sign.png"]) {
    //
    //            NSData* decodeImage = [Base64 decode:[[attachmentsArray objectAtIndex:i]objectForKey:@"Body"]];
    //
    //            captureImageView.image = [UIImage imageWithData:decodeImage];
    //
    //        } else {
    //
    //            NSData* decodeSignature = [Base64 decode:[[attachmentsArray objectAtIndex:i]objectForKey:@"Body"]];
    //
    //            captureSignatureView.image = [UIImage imageWithData:decodeSignature];
    //
    //        }
    //
    //    }
    
    
}

// Showing Errors Here

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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}


#pragma mark - UIImagePickerControllerDelegate

// Captured images Showing in ImageView

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    int q = buttonsView.frame.origin.y+buttonsView.frame.size.height;
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    [captureImagesArray addObject:chosenImage];
    
    for (int j = 0; j < captureImagesArray.count; j++)
    {
        q += 100;
        
        //        if (captureSignatureView == nil) {
        //
        //
        //        }
        
        captureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, q, 200, 80)];
        
        captureImageView.image = [captureImagesArray objectAtIndex:j];
        
        [serviceOrdersInformationView addSubview:captureImageView];
        
        captureSignatureView = [[UIImageView alloc]initWithFrame:CGRectMake(125, q+100, 200, 80)];
        
        NSLog(@"%f",captureSignatureView.frame.origin.y);
    }
    
    
    [serviceOrdersInformationView addSubview:captureSignatureView];
    
    
    //    captureSignatureView.frame = CGRectMake(400, captureImageView.frame.origin.y+100, 200, 80);
    //    captureSignatureView.backgroundColor = [UIColor redColor];
    //    [backgroundScrollView addSubview:captureSignatureView];
    
    
    //obtaining saving path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ilatest_photo.png",selectedServiceRow]];
    
    //extracting image from the picker and saving it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *webData = UIImagePNGRepresentation(editedImage);
        [webData writeToFile:imagePath atomically:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

// Saving Captured Images and Signature

-(void)attachImageAndSignature {
    
    NSString *imagePath = [SFUtils getSavedImageForIndex:selectedRow];
    
    NSString *signaturePath = [SFUtils getSavedSignatureForIndex:selectedRow];
    
    encodeImage = [[NSData alloc] initWithContentsOfFile:imagePath];
    
    encodeSignature = [[NSData alloc] initWithContentsOfFile:signaturePath];
    
    if (imagePath.length > 0) {
        
        captureImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    if (signaturePath.length > 0) {
        captureSignatureView.image = [UIImage imageWithContentsOfFile:signaturePath];
    }
    
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    
    if ([pickerTitle isEqualToString:@"Select Action Taken"]) {
        return [pickerActionTakenArray count];
    }
    
    if ([pickerTitle isEqualToString:@"Select Product"]) {
        return [pickerProductArray count];
    }
    
    if ([pickerTitle isEqualToString:@"Select Model/Item"]) {
        return [pickerModelArray count];
    }
    
    if ([pickerTitle isEqualToString:@"Select Symptom"]) {
        return [pickerSymptomArray count];
    }
    if ([pickerTitle isEqualToString:@"Select AreaUnits"]) {
        return [pickerAreaUnitsArray count];
    }
    if ([pickerTitle isEqualToString:@"New Service Result Product"]) {
        return [pickerNewServiceResultsProductArray count];
    }
    if ([pickerTitle isEqualToString:@"New Service Result System"]) {
        return [pickerNewServiceResultsSystemsArray count];
    }
    if ([pickerTitle isEqualToString:@"New Service Result SubSystems"])
    {
        return [pickerNewServiceResultsSubSystemArray count];
        
    }
    if ([pickerTitle isEqualToString:@"New Service Result RootCause"]) {
        return [pickerNewServiceResultsRootCauseArray count];
    }
    if ([pickerTitle isEqualToString:@"New Service Result Symptoms"]) {
        
        return [pickerNewServiceResultsSymptomsArray count];
    }
    if ([pickerTitle isEqualToString:@"New Service Result ActionTaken"]) {
        
        return [pickerNewServiceResultsActionTakenArray count];
    }

    if ([pickerTitle isEqualToString:@"New Order Priority"]) {
        return [pickerNewOrderPriorityArray count];
    }
    
    if ([pickerTitle isEqualToString:@"New Order Shipping Method"]) {
        return [pickerNewOrderShippingMethodArray count];
    }

    return [pickerActionTakenArray count];
    
}


-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if([pickerTitle isEqualToString:@"Select Action Taken"]) {
        
        return [pickerActionTakenArray objectAtIndex:row];
    }
    
    if ([pickerTitle isEqualToString:@"Select Product"]) {
        
        return [pickerProductArray objectAtIndex:row];
    }
    
    if ([pickerTitle isEqualToString:@"Select Model/Item"]) {
        
        return [pickerModelArray objectAtIndex:row];
    }
    
    if ([pickerTitle isEqualToString:@"Select Symptom"]) {
        
        return [pickerSymptomArray objectAtIndex:row];
    }
    
    if ([pickerTitle isEqualToString:@"Select AreaUnits"]) {
        
        return [pickerAreaUnitsArray objectAtIndex:row];
    }
    if ([pickerTitle isEqualToString:@"New Service Result Product"]) {
        return [pickerNewServiceResultsProductArray objectAtIndex:row];
    }
    if ([pickerTitle isEqualToString:@"New Service Result System"]) {
        return [pickerNewServiceResultsSystemsArray objectAtIndex:row];
    }
    if ([pickerTitle isEqualToString:@"New Service Result SubSystems"]) {
        return [pickerNewServiceResultsSubSystemArray objectAtIndex:row];
        
    }
    if ([pickerTitle isEqualToString:@"New Service Result RootCause"]) {
        return [pickerNewServiceResultsRootCauseArray objectAtIndex:row];
    }
    if ([pickerTitle isEqualToString:@"New Service Result Symptoms"]) {
       
        return [pickerNewServiceResultsSymptomsArray objectAtIndex:row];
    }
    if ([pickerTitle isEqualToString:@"New Service Result ActionTaken"]) {
        
        return [pickerNewServiceResultsActionTakenArray objectAtIndex:row];
    }

    if ([pickerTitle isEqualToString:@"New Order Priority"]) {
        return [pickerNewOrderPriorityArray objectAtIndex:row];
    }

    if ([pickerTitle isEqualToString:@"New Order Shipping Method"]) {
        return [pickerNewOrderShippingMethodArray objectAtIndex:row];
    }

    
    return [pickerActionTakenArray objectAtIndex:row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if([pickerTitle isEqualToString:@"Select Action Taken"]) {
        
        [closeWOActionTakenButton setTitle:[pickerActionTakenArray objectAtIndex:row] forState:UIControlStateNormal];
        
        [newServiceResultsActionTakenButton setTitle:[pickerActionTakenArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    
    if ([pickerTitle isEqualToString:@"Select Product"]) {
        
        [closeWOProductButton setTitle:[pickerProductArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    
    if ([pickerTitle isEqualToString:@"Select Model/Item"]) {
        
        [closeWOModelButton setTitle:[pickerModelArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    
    if ([pickerTitle isEqualToString:@"Select Symptom"]) {
        
        [closeWOSymptomButton setTitle:[pickerSymptomArray objectAtIndex:row] forState:UIControlStateNormal];
        
        [newServiceResultsSymptomsButton setTitle:[pickerSymptomArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    
    if ([pickerTitle isEqualToString:@"Select AreaUnits"]) {
        
        [areaUnits setTitle:[pickerAreaUnitsArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    if ([pickerTitle isEqualToString:@"New Service Result Product"]) {
        
        [newServiceResultsProductButton setBackgroundImage:nil forState:UIControlStateNormal];

        [newServiceResultsProductButton setTitle:[pickerNewServiceResultsProductArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    if ([pickerTitle isEqualToString:@"New Service Result System"]) {
        
        [newServiceResultsSystemButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [newServiceResultsSystemButton setTitle:[pickerNewServiceResultsSystemsArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    if ([pickerTitle isEqualToString:@"New Service Result SubSystems"]) {
        
        [newServiceResultsSubSystems setBackgroundImage:nil forState:UIControlStateNormal];

        [newServiceResultsSubSystems setTitle:[pickerNewServiceResultsSubSystemArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    
    if ([pickerTitle isEqualToString:@"New Service Result RootCause"]) {
        
        [newServiceResultsRootCauseButton setBackgroundImage:nil forState:UIControlStateNormal];

        [newServiceResultsRootCauseButton setTitle:[pickerNewServiceResultsRootCauseArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    
    if ([pickerTitle isEqualToString:@"New Service Result Symptoms"]) {
        
        [newServiceResultsSymptomsButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [newServiceResultsSymptomsButton setTitle:[pickerNewServiceResultsSymptomsArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    if ([pickerTitle isEqualToString:@"New Service Result ActionTaken"]) {
        
        [newServiceResultsActionTakenButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [newServiceResultsActionTakenButton setTitle:[pickerNewServiceResultsActionTakenArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }

    
    if ([pickerTitle isEqualToString:@"New Order Priority"]) {
        
        [newOrderPriorityButton setTitle:[pickerNewOrderPriorityArray objectAtIndex:row] forState:UIControlStateNormal];

    }

    if ([pickerTitle isEqualToString:@"New Order Shipping Method"]) {
        
        [newOrderShippingMethodButton setTitle:[pickerNewOrderShippingMethodArray objectAtIndex:row] forState:UIControlStateNormal];

    }
    

}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == leftMenuTableView) {
        
        return [tableDataArray count];
    }
    
    if (tableView == serviceTableView) {
        
        return [serviceOrdersArray count];
    }
    
    if (tableView == activitiesTableView) {
        
        if(_isActivitiesSelected) {
            
            [newOrderButton setHidden:YES];
            
            activitiesTableView.frame = CGRectMake(750, 115, 270, 200);
        
            activitiesCount=0;
            
            WOActivitiesArray = [[NSMutableArray alloc]init];
            
            for (int i =0; i<activitiesArray.count; i++) {
                
                if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[activitiesArray objectAtIndex:i]objectForKey:@"FConnect__Service_OrderId__c"]] ) {
                    
                    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                    
                    [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                    [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"FConnect__Billable__c"] forKey:@"FConnect__Billable__c"];
                    [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"FConnect__Priority__c"] forKey:@"FConnect__Priority__c"];
                    [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"FConnect__Activity__c"] forKey:@"FConnect__Activity__c"];
                    [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                    
                    [WOActivitiesArray addObject:dataDict];
                    
                    activitiesCount++;
                }
            }
            
            return activitiesCount;
            
        } else if(_isOrdersSelected) {
            
            [newOrderButton setHidden:NO];
            
            activitiesTableView.frame = CGRectMake(750, 150, 270, 200);

            
            reqMeterialsCount=0;
            
            WOOrderArray = [[NSMutableArray alloc]init];
            
            if (orderArray.count > 0) {
                
                for (int i =0; i<orderArray.count; i++) {
                    
                    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[orderArray objectAtIndex:i]objectForKey:@"Work_Order__c"]] ) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        workOrder = [[FSWorkOrder alloc] initWithDictionary:[orderArray objectAtIndex:i]];
                        
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"AccountId"] forKey:@"AccountId"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Asset_del__c"] forKey:@"Asset_del__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Case__c"] forKey:@"Case__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Description"] forKey:@"Description"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"EffectiveDate"] forKey:@"EffectiveDate"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Error_Message__c"] forKey:@"Error_Message__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"OrderNumber"] forKey:@"OrderNumber"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Pricebook2Id"] forKey:@"Pricebook2Id"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Priority__c"] forKey:@"Priority__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"PrinterDown__c"] forKey:@"PrinterDown__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Send_to_SAP__c"] forKey:@"Send_to_SAP__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"ShipToContactId"] forKey:@"ShipToContactId"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"ShippingMethod__c"] forKey:@"ShippingMethod__c"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Status"] forKey:@"Status"];
//                        [dataDict setObject:[[orderArray objectAtIndex:i] objectForKey:@"Work_Order__c"] forKey:@"Work_Order__c"];

                        
//                        [WOOrderArray addObject:dataDict];

                           [WOOrderArray addObject:workOrder];
                        reqMeterialsCount++;
                    }
                }
            }
            
            return reqMeterialsCount;
        }
        
    }
    
    if (tableView == timeAndExpensesTableView) {
        
        if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 0) {
            
            timeCount=0;
            
            WOTimeArray = [[NSMutableArray alloc]init];
            
            if (timeArray.count > 0) {
                
                for (int i =0; i<timeArray.count; i++) {
                    
                    if (WOActivitiesArray.count>0) {
                        
                        if ([[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"]isEqualToString:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__Activity__c"]] ) {
                            
                            NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                            
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"Name"] forKey:@"Name"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__Activity__c"] forKey:@"FConnect__Activity__c"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__Type__c"] forKey:@"FConnect__Type__c"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__Comments__c"] forKey:@"FConnect__Comments__c"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__Start_Date_Time__c"] forKey:@"FConnect__Start_Date_Time__c"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__End_Date_Time__c"] forKey:@"FConnect__End_Date_Time__c"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"FConnect__Duration_MM__c"] forKey:@"FConnect__Duration_MM__c"];
                            [dataDict setObject:[[timeArray objectAtIndex:i]objectForKey:@"Id"] forKey:@"Id"];
                            
                            
                            [WOTimeArray addObject:dataDict];
                            
                            timeCount++;
                        }
                    }
                }
                
                
            }
            
            return timeCount;
            
            
        }
        
        if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 1) {
            
            resultsCount=0;
            
            WOServiceResultsArray = [[NSMutableArray alloc]init];
            
            if (serviceResultsArray.count > 0) {
                
                for (int i =0; i<serviceResultsArray.count; i++) {
                    
                    if (WOActivitiesArray.count > 0) {
                        
                        if ([[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Id"]isEqualToString:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Order_Activity__c"]] ) {
                            
                            NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                            
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Id"] forKey:@"Id"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Name"] forKey:@"Name"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Order_Activity__c"] forKey:@"Order_Activity__c"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Root_Cause__c"] forKey:@"Root_Cause__c"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Sub_Systems__c"] forKey:@"Sub_Systems__c"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Symp__c"] forKey:@"Symp__c"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"System__c"] forKey:@"System__c"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Action_Taken__c"] forKey:@"Action_Taken__c"];
                            
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Details__c"] forKey:@"Details__c"];
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"CreatedDate__c"] forKey:@"CreatedDate__c"];
                            
                            [dataDict setObject:[[serviceResultsArray objectAtIndex:i]objectForKey:@"Duration__c"] forKey:@"Duration__c"];
                            
                            [WOServiceResultsArray addObject:dataDict];
                            
                            resultsCount++;
                        }
                    }
                }
                
                
            }
            
            return resultsCount;
        }
        
    }
    
    if (tableView == partsUsedTableView) {
        
        partsUsedCount=0;
        
        WOPartsUsedArray = [[NSMutableArray alloc]init];
        
        if (otherPartsUsedArray.count > 0) {
            
            for (int i =0; i<otherPartsUsedArray.count; i++) {
                
                if (WOServiceResultsArray.count > 0) {
                    
                    if ([[[WOServiceResultsArray objectAtIndex:selectedServiceResultRow]objectForKey:@"Id"]isEqualToString:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Service_Results__c"]] ) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Id"] forKey:@"Id"];
                        
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Part_Number__c"] forKey:@"Part_Number__c"];
                        
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Work_Order__c"] forKey:@"Work_Order__c"];
                        
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Service_Results__c"] forKey:@"Service_Results__c"];
                        
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Product__c"] forKey:@"Product__c"];
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Quantity__c"] forKey:@"Quantity__c"];
                        [dataDict setObject:[[otherPartsUsedArray objectAtIndex:i]objectForKey:@"Source__c"] forKey:@"Source__c"];
                        
                        [WOPartsUsedArray addObject:dataDict];
                        
                        partsUsedCount++;
                    }
                }
            }
            
            if (WOPartsUsedArray.count == 0) {
                
                [partsUsedTableView setHidden:YES];
                
            }
            if (WOPartsUsedArray.count > 0) {
                
                [partsUsedTableView setHidden:NO];
                
            }
            
        }
        return partsUsedCount;
        
    }
    
    if (tableView == orderProductsTableView) {
        
        orderProductsCount = 0;
        
        WOOrderProductsArray = [[NSMutableArray alloc]init];

        if (orderProductsArray.count > 0) {
            
            for (int i =0; i<orderProductsArray.count; i++) {
                
                if (WOOrderArray.count > 0) {
                    
                     workOrder = [WOOrderArray objectAtIndex:selectedOrderRow];
                    
                    if ([workOrder.wID isEqualToString:[[orderProductsArray objectAtIndex:i]objectForKey:@"OrderId"]] ) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Id"] forKey:@"Id"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Material_Part_Number__c"] forKey:@"Material_Part_Number__c"];

                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Part_Name__c"] forKey:@"Part_Name__c"];

                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Unused_Quantity__c"] forKey:@"Unused_Quantity__c"];

                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Quantity"] forKey:@"Quantity"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"UnitPrice"] forKey:@"UnitPrice"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"PricebookEntryId"] forKey:@"PricebookEntryId"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"OrderId"] forKey:@"OrderId"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Work_Order__c"] forKey:@"Work_Order__c"];
                        
                        
                     //   [WOOrderProductsArray addObject:dataDict];
                        [WOOrderProductsArray insertObject:dataDict atIndex:0];
                        orderProductsCount++;

                    }
                    
                }
                
            }

            if (WOOrderProductsArray.count == 0) {
                
                [orderProductsTableView setHidden:YES];
                
            }
            if (WOOrderProductsArray.count > 0) {
                
                [orderProductsTableView setHidden:NO];
                
            }

            
        }
        return orderProductsCount;

    }
    
    if (tableView == addProductPartNumberTableView ) {
        
        return filteredArray.count;
        
    }
    
    if (tableView == newPartsTableView) {
        return filteredArray.count;

    }

    
    return [timeArray count];
    
    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Newly Added
    
    ActivitiesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kActivitiesTableViewCellIdentifier];
    
    
    
// Old Data
    
//    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"Cell %li",(long)indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    //cell = nil;
//    
//
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
    
//    for (UIView *view in cell.subviews) {
//        
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view removeFromSuperview];
//        }
//    }
//    
//    if ([cell.contentView subviews]){
//        for (UIView *subview in [cell.contentView subviews]) {
//            [subview removeFromSuperview];
//        }
//    }
//    
    //    cell.imageView.image = [UIImage imageNamed:@"normal_so.png"];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cell.contentView.frame.size.width,cell.contentView.frame.size.height)];
    
    [cell.contentView addSubview:imageView];
    
    //    settingsIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
    //    settingsIconImageView.image = [UIImage imageNamed:@"sett.png"];
    //    [imageView addSubview:settingsIconImageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 200, 30)];
    nameLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLabel];
    
    timeDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, 100, 20)];
    timeDurationLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:timeDurationLabel];
    
    casestatuslabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 100, 20)];
    casestatuslabel.textColor = [UIColor whiteColor];
    [imageView addSubview:casestatuslabel];
    
    activateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    activateButton.frame = CGRectMake(120, 20, 100, 30);
    [activateButton setTitle:@"Activate" forState:UIControlStateNormal];
    [activateButton addTarget:self action:@selector(orderActivateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [activateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [activateButton setBackgroundColor:[UIColor whiteColor]];
    activateButton.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
   
    cell.backgroundColor = [UIColor blackColor];
    
    if (tableView == leftMenuTableView) {
        
        nameLabel.text = [tableDataArray objectAtIndex:indexPath.row];
    }
    
    if (tableView == serviceTableView) {
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_so.png"]];

        nameLabel.frame = CGRectMake(70, 10, 100, 30);
        
        casestatuslabel.frame = CGRectMake(210, 35, 80, 40);
        casestatuslabel.lineBreakMode = NSLineBreakByWordWrapping;
        casestatuslabel.numberOfLines = 2;
        casestatuslabel.font = [UIFont fontWithName:@"Arial" size:12];
        casestatuslabel.textAlignment = NSTextAlignmentRight;
        
        timeDurationLabel.frame =CGRectMake(40, 40, 80, 20);
//        timeDurationLabel.font = [UIFont fontWithName:@"Arial" size:12];
        
        timeDurationLabel.font = [UIFont italicSystemFontOfSize:12.0f];

        NSString * startDateString = [[assignedTechnicianArray objectAtIndex:indexPath.row]objectForKey:@"Estimated_Start_Date__c"];
        
        NSString *newString = [startDateString substringToIndex:10];
        
//        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *myDate = [formatter dateFromString:newString];

        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSString *newDateString = [formatter stringFromDate:myDate];
        
        if (serviceOrdersArray.count > 0) {
            
            nameLabel.text = [[serviceOrdersArray objectAtIndex:indexPath.row]objectForKey:@"Name"];
            
            casestatuslabel.text = [[serviceOrdersArray objectAtIndex:indexPath.row]objectForKey:@"CaseStatus__c"];
            
            timeDurationLabel.text = newDateString;
            
        }
        
    }
    
    if (tableView == activitiesTableView) {
        
        // Newly Added
        
        
//        ActivitiesTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        
//        if (!cell1) {
//            
//            [tableView registerNib:[UINib nibWithNibName:@"ActivitiesTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
//            cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        }
        
        for (UIView *view in cell.subviews) {
            
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
        
        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        
        
        if(_isActivitiesSelected) {
            
            [newOrderButton setHidden:YES];
            
            //            activitiesTableView.frame = CGRectMake(750, 115, 270, 200);
            
            if (WOActivitiesArray.count > 0) {
                
                activitiesDict =[WOActivitiesArray objectAtIndex:indexPath.row];
                
                cell.orderNumberLabel.text = [activitiesDict objectForKey:@"Name"];
                
            }
        }
        if(_isOrdersSelected) {
            
            cell.orderNumberLabel.text = workOrder.wOrderNumber;
            cell.orderStatusLabel.text =workOrder.wStatus;
            cell.orderPriorityLabel.text =workOrder.wPriorityC;
            cell.orderShippingMethodLabel.text =workOrder.wShippingMethod;
            cell.orderPrinterDownButton.titleLabel.text =workOrder.wPrinterDownC;
            cell.orderDescriptionLabel.text =workOrder.wDescription;
            
            
            [cell addSubview:activateButton];
            
//            if (selectedOrderRow == indexPath.row) {
//                
//                OrderViewDetails * orderDetails = [cell.contentView viewWithTag:999];
//                
//                if (orderDetails == nil) {
//                    
//                    orderDetails = [[[NSBundle mainBundle] loadNibNamed:@"OrderViewDetails" owner:self options:nil] objectAtIndex:0];
//                    [cell.contentView.layer setMasksToBounds:YES];
//                    [cell.contentView addSubview:orderDetails];
//                }
//                
//                orderDetails.frame = CGRectMake(0, 60, 330, 100);
//                orderDetails.tag = 999;
//                
//                workOrder = [WOOrderArray objectAtIndex:indexPath.row];
//                
//                orderDetails.orderVIewDetailsPriorityLabel.text = workOrder.wPriorityC;
//                orderDetails.orderViewDetailsShippingLabel.text = workOrder.wShippingMethod;
//                
//                if ([workOrder.wPrinterDownC isEqualToString:@"1"]) {
//                    
//                    [orderDetails.orderViewDetailPrinterButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
//                    
//                } else {
//                    
//                    [orderDetails.orderViewDetailPrinterButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
//                }
//                
//                orderDetails.orderViewDetailsDescriptionLabel.text = workOrder.wDescription;
//            }
            
            nameLabel.frame = CGRectMake(50, 10, 200, 20);
            
            nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            timeDurationLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            [newOrderButton setHidden:NO];
            
            //            activitiesTableView.frame = CGRectMake(750, 150, 270, 200);
            
            if (WOOrderArray.count > 0) {
                
                // productsDict =[WOOrderArray objectAtIndex:indexPath.row];
                
                cell.orderNumberLabel.text = [(FSWorkOrder *)[WOOrderArray objectAtIndex:indexPath.row] wOrderNumber];
                
                cell.orderStatusLabel.text = [(FSWorkOrder *)[WOOrderArray objectAtIndex:indexPath.row] wStatus];
                
                //                if ([[[WOOrderArray objectAtIndex:indexPath.row] objectForKey:@"Send_to_SAP__c"] isEqualToString:@"1"])
                //                {
                //                    [activateButton setHidden:YES];
                //
                //                }
                //                if ([[[WOOrderArray objectAtIndex:indexPath.row] objectForKey:@"Send_to_SAP__c"] isEqualToString:@"0"]) {
                //
                //                    [activateButton setHidden:NO  ];
                //                }
                
                //                [activitiesTableView reloadData];
                
                workOrder = [WOOrderArray objectAtIndex:indexPath.row];
                addProductButton.hidden=true;
                
                [activateButton setHidden:workOrder.wSendToSapC];
                
                // added here now
                //activateButton.hidden=false;
                addProductButton.hidden=false;
                //added here above
                
                [addProductButton setHidden:NO];
                
                
                if (workOrder.wSendToSapC == 0) {
                    
                    [addProductButton setHidden:NO];
                }
                
                if (workOrder.wSendToSapC == 1) {
                    
                    [addProductButton setHidden:YES];
                }
                
                
                NSLog(@"activate button is %i %li",activateButton.hidden,(long)indexPath.row);
                // NSLog(@"workOrder.wSendToSapC   is %@ %li",workOrder.wSendToSapC, (long)indexPath.row );
            }
            
            
        }
        
        
        // Old Data
        
        //        imageView.image=[UIImage imageNamed:@"folder_related_selected.png"];
        //        imageView.image=[UIImage imageNamed:@"folder_related.png"];
        
        //        if(_isActivitiesSelected) {
        //
        //            [newOrderButton setHidden:YES];
        //
        ////            activitiesTableView.frame = CGRectMake(750, 115, 270, 200);
        //
        //            if (WOActivitiesArray.count > 0) {
        //
        //                activitiesDict =[WOActivitiesArray objectAtIndex:indexPath.row];
        //
        //                nameLabel.text = [activitiesDict objectForKey:@"Name"];
        //
        //            }
        //
        //        }
        
        //        if(_isOrdersSelected) {
        //
        //            [cell addSubview:activateButton];
        //
        //            if (selectedOrderRow == indexPath.row) {
        //
        //                OrderViewDetails * orderDetails = [cell.contentView viewWithTag:999];
        //
        //                if (orderDetails == nil) {
        //
        //                    orderDetails = [[[NSBundle mainBundle] loadNibNamed:@"OrderViewDetails" owner:self options:nil] objectAtIndex:0];
        //                    [cell.contentView.layer setMasksToBounds:YES];
        //                    [cell.contentView addSubview:orderDetails];
        //                }
        //
        //                orderDetails.frame = CGRectMake(0, 60, 330, 100);
        //                orderDetails.tag = 999;
        //
        //                workOrder = [WOOrderArray objectAtIndex:indexPath.row];
        //
        //                orderDetails.orderVIewDetailsPriorityLabel.text = workOrder.wPriorityC;
        //                orderDetails.orderViewDetailsShippingLabel.text = workOrder.wShippingMethod;
        //
        //                if ([workOrder.wPrinterDownC isEqualToString:@"1"]) {
        //
        //                    [orderDetails.orderViewDetailPrinterButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        //
        //                } else {
        //
        //                    [orderDetails.orderViewDetailPrinterButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        //                }
        //
        //                orderDetails.orderViewDetailsDescriptionLabel.text = workOrder.wDescription;
        //            }
        //
        //            nameLabel.frame = CGRectMake(50, 10, 200, 20);
        //
        //            nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
        //
        //            timeDurationLabel.font = [UIFont fontWithName:@"Arial" size:14];
        //
        //            [newOrderButton setHidden:NO];
        //
        ////            activitiesTableView.frame = CGRectMake(750, 150, 270, 200);
        //
        //            if (WOOrderArray.count > 0) {
        //
        //               // productsDict =[WOOrderArray objectAtIndex:indexPath.row];
        //
        //                nameLabel.text = [(FSWorkOrder *)[WOOrderArray objectAtIndex:indexPath.row] wOrderNumber];
        //
        //                timeDurationLabel.text = [(FSWorkOrder *)[WOOrderArray objectAtIndex:indexPath.row] wStatus];
        //
        ////                if ([[[WOOrderArray objectAtIndex:indexPath.row] objectForKey:@"Send_to_SAP__c"] isEqualToString:@"1"])
        ////                {
        ////                    [activateButton setHidden:YES];
        ////
        ////                }
        ////                if ([[[WOOrderArray objectAtIndex:indexPath.row] objectForKey:@"Send_to_SAP__c"] isEqualToString:@"0"]) {
        ////
        ////                    [activateButton setHidden:NO  ];
        ////                }
        //
        ////                [activitiesTableView reloadData];
        //
        //                workOrder = [WOOrderArray objectAtIndex:indexPath.row];
        //                addProductButton.hidden=true;
        //
        //                [activateButton setHidden:workOrder.wSendToSapC];
        //
        //          // added here now
        //                //activateButton.hidden=false;
        //                addProductButton.hidden=false;
        //         //added here above
        //
        //                [addProductButton setHidden:NO];
        //
        //
        //                if (workOrder.wSendToSapC == 0) {
        //
        //                    [addProductButton setHidden:NO];
        //                }
        //
        //                if (workOrder.wSendToSapC == 1) {
        //
        //                    [addProductButton setHidden:YES];
        //                }
        //                
        //
        //                NSLog(@"activate button is %i %li",activateButton.hidden,(long)indexPath.row);
        //               // NSLog(@"workOrder.wSendToSapC   is %@ %li",workOrder.wSendToSapC, (long)indexPath.row );
        //            }
        //            
        //        }

    }
    
    if (tableView == timeAndExpensesTableView) {
        
        if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 0) {
            
            timeAndExpensesTableView.frame = CGRectMake(750, 395, 270, 400);
            [newServiceResultsBtn setHidden:YES];
            
            if (WOTimeArray.count > 0) {
                
                NSDictionary * dict1 =[WOTimeArray objectAtIndex:indexPath.row];
                
                nameLabel.frame = CGRectMake(50, 10, 200, 20);
                nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
                
                timeDurationLabel.font = [UIFont fontWithName:@"Arial" size:14];
                
                NSString * startDateString = [dict1 objectForKey:@"FConnect__Start_Date_Time__c"];
                
                NSString *newString = [startDateString substringToIndex:10];
                
//                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *myDate = [formatter dateFromString:newString];
                
                [formatter setDateFormat:@"dd-MM-yyyy"];
                NSString *newDateString = [formatter stringFromDate:myDate];
                
                nameLabel.text = newDateString;
                
                timeDurationLabel.text = [dict1 objectForKey:@"FConnect__Duration_MM__c"];
                
            }
            
        } else if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 1) {
            
            timeAndExpensesTableView.frame = CGRectMake(750, 445, 270, 400);
            [newServiceResultsBtn setHidden:NO];

            
            if (WOServiceResultsArray.count > 0) {
                NSDictionary * dict1 =[WOServiceResultsArray objectAtIndex:indexPath.row];
                
                nameLabel.text = [dict1 objectForKey:@"Name"];
                
            
            }

        }
        
        //   imageView.image=[UIImage imageNamed:@"folder_related_required.png"];
        
    }
    
    if (tableView == partsUsedTableView) {
        
        nameLabel.frame = CGRectMake(50, 10, 200, 20);
        
        nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
        if (WOPartsUsedArray.count > 0) {
            nameLabel.text = [[WOPartsUsedArray objectAtIndex:indexPath.row] objectForKey:@"Part_Number__c"];
            
            timeDurationLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            timeDurationLabel.text = [[WOPartsUsedArray objectAtIndex:indexPath.row] objectForKey:@"Quantity__c"];
            
        }
        
    }
    
    if (tableView == orderProductsTableView) {
        
        nameLabel.frame = CGRectMake(50, 10, 200, 40);
        
        timeDurationLabel.frame = CGRectMake(50, 50, 200, 20);

        nameLabel.font = [UIFont fontWithName:@"Arial" size:12];
        if (WOOrderProductsArray.count > 0) {
            
            nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
            nameLabel.numberOfLines = 2;
            
            nameLabel.text = [[WOOrderProductsArray objectAtIndex:indexPath.row] objectForKey:@"Part_Name__c"];
            timeDurationLabel.font = [UIFont fontWithName:@"Arial" size:14];
            
            timeDurationLabel.text = [[WOOrderProductsArray objectAtIndex:indexPath.row] objectForKey:@"Quantity"];
            
        }

    }
    
    if (tableView == addProductPartNumberTableView) {
        
        nameLabel.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Material_Part_Number__c"];
        
    }
    
    
    if (tableView == newPartsTableView) {
        
        nameLabel.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Part_Number__c"];

    }


    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    [timeIntervalView setHidden:YES];
    
    [newServiceResultsBtn setHidden:YES];
    
    if (tableView == leftMenuTableView) {
        
        if (indexPath.row == 0) {
            
            _isShowingMenu = NO;
            
            [leftMenuTableView setHidden:YES];
            serviceTableView.frame = CGRectMake(0, 65, 300, 700);
            
            serviceOrderScrollView.frame = CGRectMake(300, 65, 450, 350);
            self.segmentedControl.frame = CGRectMake(750, 80, 300, 28);
            activitiesTableView.frame = CGRectMake(750, 115, 270, 150);
            
        }
        
        if (indexPath.row == 1) {
            
            installedProductsView.userId = userId;
            [self.navigationController pushViewController:installedProductsView animated:YES];
        }
        
        if (indexPath.row == 2) {
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Logout ?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
            
            [alertView show];
            
        }
        
    }
    
    if (tableView == serviceTableView) {
        
        if (_isActivitiesSelected) {
            
            [newOrderButton setHidden:YES];
            
            activitiesTableView.frame = CGRectMake(750, _ordersButton.frame.size.height+_ordersButton.frame.origin.y, 270, 200);

//            activitiesTableView.frame = CGRectMake(750, 115, 270, 200);
        }

        if (_isOrdersSelected) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [newOrderButton setHidden:NO];
                
                [activitiesTableView reloadData];
               
                activitiesTableView.frame = CGRectMake(750, newOrderButton.frame.size.height+newOrderButton.frame.origin.y, 270, 200);
            });
           
        }
        
        selectedOrderRow = 0;

        [newOrderView setHidden:YES];
        
        [addProductView setHidden:YES];

        [orderProductsView setHidden:YES];
        
        [travelButton setBackgroundImage:[UIImage imageNamed:@"start travel.png"] forState:UIControlStateNormal];
        
        travelChecked = NO;
        
        selectedRow =  (int)indexPath.row;
        
        [captureImageView setHidden:NO];
        
        [captureSignatureView setHidden:NO];
        
        selectedServiceRow = (int)indexPath.row;
        
        [self serviceOrdersRowClicked];
        
        [activitiesTableView reloadData];
        
        [timeLabel setHidden:YES];
        
        [self.timeAndServiceResultsSegmentControl setHidden:YES];
        
        [timeAndExpensesTableView setHidden:YES];
        
        [serviceResultsInformationView setHidden:YES];
        [newServiceResultsView setHidden:YES];
        
        [partsUsedView setHidden:YES];
        
        
    }
    
    if (tableView == activitiesTableView) {
        
        //        travelChecked = NO;
        
        [serviceResultsInformationView setHidden:YES];
        [newServiceResultsView setHidden:YES];
        
        
        [timeAndExpensesTableView reloadData];
        
        [self activitiesRowClicked:indexPath];
        
        if (_isActivitiesSelected) {
            
            [newOrderView setHidden:YES];

            [orderProductsView setHidden:YES];
            
//            [orderProductsTableView reloadData];

            selectedActivityRow =  (int)indexPath.row;
            
            serviceAndTravelString = [activitiesDict1 objectForKey:@"Name"];
            
            if ([serviceAndTravelString isEqualToString:@"Service"] || [serviceAndTravelString isEqualToString:@"2"]) {
                
                timeAndExpensesTableView.frame = CGRectMake(750, 445, 270, 400);
                [newServiceResultsBtn setHidden:NO];

                [self.timeAndServiceResultsSegmentControl setHidden:NO];
                
                [timeLabel setHidden:YES];
                
                [timeAndExpensesTableView reloadData];
                
            }
            
            if ([serviceAndTravelString isEqualToString:@"Travel"] || [serviceAndTravelString isEqualToString:@"1"]){
                
                timeAndExpensesTableView.frame = CGRectMake(750, 395, 270, 400);

                [newServiceResultsBtn setHidden:YES];
                
                [self.timeAndServiceResultsSegmentControl setHidden:YES];
                [timeLabel setHidden:NO];
                [timeAndExpensesTableView setHidden:NO];
                
                [timeAndExpensesTableView reloadData];
                
            }
        }
        
        // For Expandin and Colapsing the Activities TableView
        if (_isOrdersSelected) {
            
//            selectedOrderRow = (int)indexPath.row;
//            
//            [activitiesTableView reloadData];
//            
//            [activitiesTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedOrderRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            [activitiesTableView beginUpdates];
            
            
            // If same Cell Selected do nothing as its already expanded
//            if ((self.selectedIndexPath) && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
//                
//                return;
//            }
//            
//            NSIndexPath *previousSelectedIndexPath = self.selectedIndexPath;  // <- save previously selected cell
//            
//            self.selectedIndexPath = indexPath;
//            
//            if (previousSelectedIndexPath) { // <- reload previously selected cell (if not nil)
//                
//                
//                if ([previousSelectedIndexPath compare:indexPath] != NSOrderedSame) {
//                    
//                    
//                    
//                    [activitiesTableView reloadRowsAtIndexPaths:@[previousSelectedIndexPath]
//                                     withRowAnimation:UITableViewRowAnimationAutomatic];
//                    
//                }
//                selectedOrderRow = (int)self.selectedIndexPath.row;
//                
//                // <- reload selected cell
//                [activitiesTableView reloadRowsAtIndexPaths:@[self.selectedIndexPath]
//                                 withRowAnimation:UITableViewRowAnimationAutomatic];
//            } else {
//                
//                selectedOrderRow = (int)self.selectedIndexPath.row;
//
//                // <- reload selected cell (if not nil)
//                [activitiesTableView reloadRowsAtIndexPaths:@[self.selectedIndexPath]
//                                 withRowAnimation:UITableViewRowAnimationAutomatic];
//                
//            }
            
            
            
            NSInteger previousSelectedRow = selectedOrderRow;
            [activitiesTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:previousSelectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            selectedOrderRow =(int)indexPath.row;

            _isActivitiesTableViewCellExpanded=NO;
    
            if (selectedOrderRow != previousSelectedRow) {
            
                [activitiesTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedOrderRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

            }

            workOrder = [WOOrderArray objectAtIndex:indexPath.row];
            
            if (workOrder.wSendToSapC == 0 ) {
                
                [addProductButton setHidden:NO];
                
                orderProductsTableView.frame = CGRectMake(0, 80, 270, 320);
                
            }
            
            if (workOrder.wSendToSapC == 1) {
                
                [addProductButton setHidden:YES];
                orderProductsTableView.frame = CGRectMake(0, 40, 270, 320);

            }
            
            selectedOrderRow = (int)indexPath.row;

            [orderProductsTableView reloadData];
            
//            [self ordersRowClicked:indexPath];
            
            [orderProductsView setHidden:NO];
                        
            [timeLabel setHidden:YES];
            [timeAndExpensesTableView setHidden:YES];
            
        }
        
        //        [timeLabel setHidden:NO];
        //        [timeAndExpensesTableView setHidden:NO];
        
    }
    
    if (tableView == timeAndExpensesTableView) {
        if (self.timeAndServiceResultsSegmentControl.selectedSegmentIndex == 1) {
            
            [partsUsedView setHidden:NO];
            
            [serviceResultsInformationView setHidden:NO];
            
            [newServiceResultsView setHidden:YES];

            [newServiceResultsBtn setHidden:NO];
            
            selectedServiceResultRow = (int)indexPath.row;
            
            serviceResultsWorkOrderLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
            serviceResultsProductLabel.text =[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"];
            serviceResultsNameLabel.text = [[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Name"];
            serviceResultsOrderActivityLabel.text =[[WOActivitiesArray objectAtIndex:selectedActivityRow]objectForKey:@"Name"];
            serviceResultsSubSystemsLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Sub_Systems__c"];
            serviceResultsDurationLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Duration__c"];
            serviceResultsSymptomsLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Symp__c"];
            serviceResultsSystemLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"System__c"];
            serviceResultsActionTakenLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Action_Taken__c"];
            serviceResultsRootCauseLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Root_Cause__c"];
            serviceResultsDetailsLabel.text =[[WOServiceResultsArray objectAtIndex:indexPath.row]objectForKey:@"Details__c"];
            
            [partsUsedTableView reloadData];
            
        }
        
        
    }
    
    if (tableView == addProductPartNumberTableView) {
        
        // here we need to add typedown approch and add details to remaining fields.
        // SearchBar type down approach by 2 character minimum
        
        addNewParts.addProductPartNumberSearchBar.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Material_Part_Number__c"];
        addNewParts.addProductName.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Part_Name__c"];
        
        addNewParts.addProductQuantity.text =[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Quantity__c"];
        
        [addProductPartNumberTableView setHidden:YES];

    }
    
    if (tableView == newPartsTableView) {
        
        addParts.partNumberSearchBar.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Part_Number__c"];
        
        addParts.partName.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Part_Number__c"];
        
        [addParts.sourceButton setTitle:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Source__c"] forState:UIControlStateNormal];
        
        addParts.unusedQuantity.text =  [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Unused_Quantity__c"];

    //        addParts1.unusedQuantity.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"Quantity__c"];
        
        [addParts.partNumberSearchBar resignFirstResponder];
        
//        [addParts setUpData:[filteredArray objectAtIndex:indexPath.row]];
        
        [newPartsTableView setHidden:YES];
    
    }

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == serviceTableView) {
        
        cell.selectedBackgroundView = [[UIImageView alloc] init];
        UIImage *img  = [UIImage imageNamed:@"selected_so.png"];
        ((UIImageView *)cell.selectedBackgroundView).image = img;
    }
    
    if (tableView == activitiesTableView) {
        
        cell.selectedBackgroundView = [[UIImageView alloc] init];
        UIImage *img  = [UIImage imageNamed:@"folder_related.png"];
        ((UIImageView *)cell.selectedBackgroundView).image = img;
        
    }
    
    if (tableView == timeAndExpensesTableView ||  tableView == orderProductsTableView) {
        
        cell.selectedBackgroundView = [[UIImageView alloc] init];
        UIImage *img  = [UIImage imageNamed:@"folder_related_required.png"];
        ((UIImageView *)cell.selectedBackgroundView).image = img;
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UITableView * tableView;
    
    // Force your tableview margins (this may be a bad idea)
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
} 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == serviceTableView) {
        
        return 70;
    }
    if (tableView == orderProductsTableView) {
      
        return 80;
    }
    
    if (tableView == activitiesTableView) {
        
        if (selectedOrderRow == indexPath.row) {
            
            return 160.0f;
        } else {
            
            return 60.0f;
        }
    }
    
    return 60;
}

// Showing Case and Address Information when changing Work Order

-(void)serviceOrdersRowClicked {
    
    [self attachImageAndSignature];
    
    // Get Case Information
    
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"] isEqualToString:@"<null>"]) {
        
        orderIdLabel.text =@"";
        
    } else {
        
        orderIdLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Name"];
    }
    
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseStatus__c"] isEqualToString:@"<null>"]) {
        
        workOrderStatusLabel.text =@"";
        
    } else {
        
        workOrderStatusLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseStatus__c"];
    }
    
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case_Name__c"] isEqualToString:@"<null>"]) {
        
        caseLabel.text =@"";
        
    } else {
        
        caseLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Case_Name__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Billing_Status__c"] isEqualToString:@"<null>"]) {
        
        billableLabel.text =@"";
        
    } else {
        
        billableLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Billing_Status__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Owner__c"] isEqualToString:@"<null>"]) {
        
        caseOwnerLabel.text =@"";
        
    } else {
        
        caseOwnerLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Owner__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"casePriority__c"] isEqualToString:@"<null>"]) {
        
        workOrderPriorityLabel.text =@"";
        
    } else {
        
        workOrderPriorityLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"casePriority__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account_Name__c"] isEqualToString:@"<null>"]) {
        
        accountLabel.text =@"";
        
    } else {
        
        accountLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Account_Name__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Regional_Coordinator__c"] isEqualToString:@"<null>"]) {
        
        regionalCoordinatorLabel.text =@"";
        
    } else {
        
        regionalCoordinatorLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Regional_Coordinator__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Installed_Product2__c"] isEqualToString:@"<null>"]) {
        
        installedProductsLabel.text =@"";
        
    } else {
        
        installedProductsLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Installed_Product2__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"] isEqualToString:@"<null>"]) {
        
        symptomLabel.text =@"";
        
    } else {
        
        symptomLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
        
        serialNumberLabel.text =@"";
        
    } else {
        
        serialNumberLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"] isEqualToString:@"<null>"]) {
        
        subjectLabel.text =@"";
        
    } else {
        
        subjectLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Severity__c"] isEqualToString:@"<null>"]) {
        
        severityLabel.text =@"";
        
    } else {
        
        severityLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Severity__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] isEqualToString:@"<null>"]) {
        
        productLabel.text =@"";
        
    } else {
        
        productLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseDescription__c"] isEqualToString:@"<null>"]) {
        
        descriptionLabel.text =@"";
        
    } else {
        
        descriptionLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"CaseDescription__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"] isEqualToString:@"<null>"])
    {
        modelItemLabel.text =@"";
        
    } else {
        
        modelItemLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"ContactName__c"] isEqualToString:@"<null>"]) {
        
        contactNameLabel.text =@"";
        
    } else {
        
        contactNameLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"ContactName__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"contact_Phone__c"] isEqualToString:@"<null>"]) {
        
        contactPhoneLabel.text =@"";
        
    } else {
        
        contactPhoneLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"contact_Phone__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact_Email__c"] isEqualToString:@"<null>"]) {
        
        contactEmailLabel.text =@"";
        
    } else {
        
        contactEmailLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Contact_Email__c"];
        
    }
    
    // Get Address Information
    
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Primary_Address__c"] isEqualToString:@"<null>"]) {
        
        primaryAddressLabel.text =@"";
        
    } else {
        
        primaryAddressLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Primary_Address__c"];
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"SAP_Bill_To_Address__c"] isEqualToString:@"<null>"]) {
        
        sapBillToAddressLabel.text =@"";
        
    } else {
        
        sapBillToAddressLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"SAP_Bill_To_Address__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Sub_Region__c"] isEqualToString:@"<null>"])
    {
        subRegionLabel.text =@"";
        
    } else {
        
        subRegionLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Sub_Region__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"] isEqualToString:@"<null>"]) {
        
        latittudeLabel.text =@"";
        
    } else {
        
        latittudeLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"] isEqualToString:@"<null>"]) {
        
        longitudeLabel.text =@"";
        
    } else {
        
        longitudeLabel.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"];
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"] isEqualToString:@"<null>"]) {
        
        closeWOSubjectField.text =@"";
        
    } else {
        
        closeWOSubjectField.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Subject__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Problem_Description__c"] isEqualToString:@"<null>"]) {
        
        closeWOProblemDescriptionField.text =@"";
        
    } else {
        
        closeWOProblemDescriptionField.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"FConnect__Problem_Description__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Action_Taken__c"] isEqualToString:@"<null>"]) {
        
        
        [closeWOActionTakenButton setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [closeWOActionTakenButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Action_Taken__c"] forState:UIControlStateNormal];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] isEqualToString:@"<null>"]) {
        
        
        [closeWOProductButton setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [closeWOProductButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Product__c"] forState:UIControlStateNormal];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"] isEqualToString:@"<null>"]) {
        
        
        [closeWOModelButton setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [closeWOModelButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Model_Item__c"] forState:UIControlStateNormal];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"] isEqualToString:@"<null>"]) {
        
        [closeWOSymptomButton setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [closeWOSymptomButton setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Symptom__c"] forState:UIControlStateNormal];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaPrinted__c"] isEqualToString:@"<null>"]) {
        
        areaPrinted.text = @"";
        
    } else {
        
        areaPrinted.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaPrinted__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"InkUsage__c"] isEqualToString:@"<null>"]) {
        
        inkUsage.text = @"";
        
    } else {
        
        inkUsage.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"InkUsage__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"PrintTime__c"] isEqualToString:@"<null>"]) {
        
        printerTime.text = @"";
        
    } else {
        
        printerTime.text = [[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"PrintTime__c"];
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Expenses_over_50__c"] isEqualToString:@"<null>"]) {
        
        
        [expensesOver setHidden:YES];
        
    } else {
        
        if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Expenses_over_50__c"] isEqualToString:@"0"]) {
            
            [expensesOver setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            
        } else if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Expenses_over_50__c"] isEqualToString:@"1"]) {
            
            [expensesOver setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        }
        
    }
    if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaUnit__c"] isEqualToString:@"<null>"]) {
        
        [areaUnits setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [areaUnits setTitle:[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"AreaUnit__c"] forState:UIControlStateNormal];
        
    }
    
    
}


-(void)activitiesRowClicked:(NSIndexPath *)indexPath {
    
    if(_isActivitiesSelected) {
        
        if ([serviceAndTravelString isEqualToString:@"Service"] || [serviceAndTravelString isEqualToString:@"2"]) {
            
            [self.timeAndServiceResultsSegmentControl setHidden:NO];
            [timeLabel setHidden:YES];
            
        }
        if ([serviceAndTravelString isEqualToString:@"Travel"] || [serviceAndTravelString isEqualToString:@"1"]){
            
            [self.timeAndServiceResultsSegmentControl setHidden:YES];
            [timeLabel setHidden:NO];
            
        }
        
        [timeAndExpensesTableView setHidden:NO];
        
        WOActivitiesArray = [[NSMutableArray alloc]init];
        
        for (int i =0; i<activitiesArray.count; i++) {
            
            if ([[[serviceOrdersArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[activitiesArray objectAtIndex:i]objectForKey:@"FConnect__Service_OrderId__c"]] ) {
                
                NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                
                [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"FConnect__Billable__c"] forKey:@"FConnect__Billable__c"];
                [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"FConnect__Priority__c"] forKey:@"FConnect__Priority__c"];
                [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"FConnect__Activity__c"] forKey:@"FConnect__Activity__c"];
                [dataDict setObject:[[activitiesArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                
                [WOActivitiesArray addObject:dataDict];
                
            }
        }
        
        if (WOActivitiesArray.count>0) {
            
            activitiesDict1 = [WOActivitiesArray objectAtIndex:indexPath.row];
            
            NSLog(@"activitiesDict:%@",activitiesDict1);
            
        }
        
    } else if(_isOrdersSelected) {
        
        [orderProductsTableView reloadData];
        
        [timeLabel setHidden:YES];
        [self.timeAndServiceResultsSegmentControl setHidden:YES];
        [timeAndExpensesTableView setHidden:YES];
        
        WOOrderProductsArray = [[NSMutableArray alloc]init];

        if (orderProductsArray.count > 0) {
            
            for (int i =0; i<orderProductsArray.count; i++) {
                
                if (WOOrderArray.count > 0) {
                    
                    workOrder = [WOOrderArray objectAtIndex:selectedOrderRow];
                    
                    if ([workOrder.wID isEqualToString:[[orderProductsArray objectAtIndex:i]objectForKey:@"OrderId"]] ) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Id"] forKey:@"Id"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Material_Part_Number__c"] forKey:@"Material_Part_Number__c"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Part_Name__c"] forKey:@"Part_Name__c"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Unused_Quantity__c"] forKey:@"Unused_Quantity__c"];
                        
                        [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Quantity"] forKey:@"Quantity"];
                        
                        [WOOrderProductsArray addObject:dataDict];
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

//-(void)ordersRowClicked:(NSIndexPath *)indexPath {
//    
//    if (orderProductsArray.count > 0) {
//        
//        for (int i =0; i<orderProductsArray.count; i++) {
//            
//            if (WOOrderArray.count > 0) {
//                
//                if ([[[WOOrderArray objectAtIndex:selectedOrderRow]objectForKey:@"Id"]isEqualToString:[[orderProductsArray objectAtIndex:i]objectForKey:@"OrderId"]] ) {
//                    
//                    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
//                    
//                    [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Id"] forKey:@"Id"];
//                    
//                    [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Material_Part_Number__c"] forKey:@"Material_Part_Number__c"];
//                    
//                    [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Part_Name__c"] forKey:@"Part_Name__c"];
//                    
//                    [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Unused_Quantity__c"] forKey:@"Unused_Quantity__c"];
//                    
//                    [dataDict setObject:[[orderProductsArray objectAtIndex:i]objectForKey:@"Quantity__c"] forKey:@"Quantity__c"];
//                    
//                    [WOOrderProductsArray addObject:dataDict];
//                    
//                }
//                
//            }
//            
//            
//        }
//        
//    }
//    
//}


// Drawing a Signature in SignatureView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //did our finger moved yet?
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        signatureBackgroundImageView.image = nil;
        return;
    }
    
    //we need 3 points of contact to make our signature smooth using quadratic bezier curve
    currentPoint = [touch locationInView:signatureBackgroundImageView];
    lastContactPoint1 = [touch previousLocationInView:signatureBackgroundImageView];
    lastContactPoint2 = [touch previousLocationInView:signatureBackgroundImageView];
    
    
    //    fingerMoved = NO;
    //    UITouch *touch = [touches anyObject];
    //    lastContactPoint2 = [touch locationInView:signatureBackgroundImageView];
    
}


//when one or more fingers associated with an event move within a view or window
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //well its obvious that our finger moved on the screen
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    //save previous contact locations
    lastContactPoint2 = lastContactPoint1;
    lastContactPoint1 = [touch previousLocationInView:signatureBackgroundImageView];
    //save current location
    currentPoint = [touch locationInView:signatureBackgroundImageView];
    
    //find mid points to be used for quadratic bezier curve
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    //create a bitmap-based graphics context and makes it the current context
    UIGraphicsBeginImageContext(signatureBackgroundImageView.frame.size);
    
    //draw the entire image in the specified rectangle frame
    [signatureBackgroundImageView.image drawInRect:CGRectMake(0, 0, signatureBackgroundImageView.frame.size.width, signatureBackgroundImageView.frame.size.height)];
    
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //begin a new new subpath at this point
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midPoint1.x, midPoint1.y);
    //create quadratic Bézier curve from the current point using a control point and an end point
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                                 lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    //set the miter limit for the joins of connected lines in a graphics context
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    //paint a line along the current path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //set the image based on the contents of the current bitmap-based graphics context
    signatureBackgroundImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
    //lastContactPoint = currentPoint;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        signatureBackgroundImageView.image = nil;
        return;
    }
    
    //if the finger never moved draw a point
    if(!fingerMoved) {
        
        UIGraphicsBeginImageContext(imageFrame.size);
        [signatureBackgroundImageView.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        signatureBackgroundImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    
    //    UIGraphicsBeginImageContext(signatureBackgroundImageView.frame.size);
    //    [signatureBackgroundImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    //    [signatureBackgroundImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    //    signatureBackgroundImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //    signatureBackgroundImageView.image = nil;
    //    UIGraphicsEndImageContext();
    
}


//calculate midpoint between two points
- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}


//some action was taken on the alert view

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_isShowingMenu) {
        
        if (buttonIndex == 0) {
            
            [[SFAuthenticationManager sharedManager] logout];
            
        } else if (buttonIndex == 1) {
            
            [alertView dismissWithClickedButtonIndex:1 animated:TRUE];
        }
        
    }
    
    if (alertView.tag == 1) {
        
        return;
    }
    
    else if (alertView.tag == 2){
        
        captureSignatureView.image = signatureBackgroundImageView.image;
        
        signatureBackgroundImageView.image = nil;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    
    //which button was pressed in the alert view
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    //user wants to save the signature now
    if ([buttonTitle isEqualToString:@"Ok"]){
        NSLog(@"Ok button was pressed.");
        NSLog(@"Name of the person is: %@", [[alertView textFieldAtIndex:0] text]);
        NSString * personName = [[alertView textFieldAtIndex:0] text];
        
        //create path to where we want the image to be saved
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
        NSLog(@"Signatur File Path: %@",filePath);
        //if the folder doesn't exists then just create one
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:&error];
        
        //convert image into .png format.
        NSData *imageData = UIImagePNGRepresentation(signatureBackgroundImageView.image);
        NSString *fileName = [filePath stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.png", personName]];
        
        //creates an image file with the specified content and attributes at the given location
        [fileManager createFileAtPath:fileName contents:imageData attributes:nil];
        NSLog(@"image saved");
        
        //check if the display signature view controller doesn't exists then create it
        //        if(self.displaySignatureViewController == nil) {
        
        //            DisplaySignatureViewController *displayView = [[DisplaySignatureViewController alloc] init];
        //            self.displaySignatureViewController = displayView;
        //        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saving signature" message:@"Image Saved" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        
        [alertView show];
        
    }
    
    //just forget it
    else if ([buttonTitle isEqualToString:@"Cancel"]){
        
        NSLog(@"Cancel button was pressed.");
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SignatureViewControllerDelegate Methods

- (void)willDisplaySignature:(UIImage *)image {
    
    captureSignatureView.image = image;
}

#pragma mark - FSAddPartViewDelegate

- (void)deleteActionForButton:(UIButton *)sender {
    
    BOOL isPartRemoved = NO;
    CGFloat yPos = 0.0f;
    CGFloat deltaYPos = 60.0f;
   
    for (UIView *addPartView in newPartsUsedBackgroundScrollView.subviews) {
        
        [addPartView bringSubviewToFront:newPartsTableView];
        
        if ([addPartView isKindOfClass:[FSAddPartView class]]) {
            
            if (isPartRemoved) {
                
                CGRect frame = addPartView.frame;
                frame.origin.y = yPos;
               // dispatch_async(dispatch_get_main_queue(), ^{
                    addPartView.frame = frame;
                
                newPartsTableView.frame = CGRectMake(250, yPos, 200, 128);
              //  });
                
            }

            if (addPartView.tag == sender.tag) {
                isPartRemoved = YES;
                [addPartView removeFromSuperview];
            }
             yPos = addPartView.frame.origin.y - deltaYPos;
            
        }
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)addProductdeleteActionForButton:(UIButton *)sender {
    
    BOOL isPartRemoved = NO;
    CGFloat yPos = 0.0f;
    CGFloat deltaYPos = 60.0f;
    
    for (UIView *addNewPartView in addProductsBackgroundScrollView.subviews) {
        
        [addNewPartView bringSubviewToFront:addProductPartNumberTableView];
        
        if ([addNewPartView isKindOfClass:[FSAddNewPartView class]]) {
            
            if (isPartRemoved) {
                
                CGRect frame = addNewPartView.frame;
                frame.origin.y = yPos;
                // dispatch_async(dispatch_get_main_queue(), ^{
                addNewPartView.frame = frame;
                
                addProductPartNumberTableView.frame = CGRectMake(250, yPos, 200, 128);
                //  });
                
            }
            NSLog(@"  addnew parts tag%ld,sender tag%ld",addNewParts.tag,sender.tag);
            
            
            if (addNewPartView.tag == sender.tag) {
                isPartRemoved = YES;
                [addNewPartView removeFromSuperview];
            }
            yPos = addNewPartView.frame.origin.y - deltaYPos;
            
        }
    }
//    BOOL isPartRemoved = NO;
//    CGFloat yPos = 0.0f;
//    CGFloat deltaYPos = 60.0f;
//    
//    for (UIView *addNewPartView in addProductsBackgroundScrollView.subviews) {
//        
//        [addNewPartView bringSubviewToFront:addProductPartNumberTableView];
//        
//        if ([addNewPartView isKindOfClass:[FSAddNewPartView class]]) {
//            
//            if (isPartRemoved) {
//                
//                CGRect frame = addNewPartView.frame;
//                frame.origin.y = yPos;
//                // dispatch_async(dispatch_get_main_queue(), ^{
//                addNewPartView.frame = frame;
//                
//                addProductPartNumberTableView.frame = CGRectMake(250, yPos, 200, 128);
//                //  });
//                
//            }
//            
//            if (addNewPartView.tag == sender.tag) {
//                isPartRemoved = YES;
//                [addNewPartView removeFromSuperview];
//            }
//            yPos = addNewPartView.frame.origin.y - deltaYPos;
//            
//        }
//    }
}




@end
