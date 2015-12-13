//
//  InstalledProductsViewController.m
//  FS360
//
//  Created by BiznusSoft on 7/31/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import "InstalledProductsViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "DBManager.h"
#import "SFSDKReachability.h"
#import "AppDelegate.h"
#import "ServiceOrdersViewController.h"
#import "SFAuthenticationManager.h"

@interface InstalledProductsViewController ()
{
    ServiceOrdersViewController * serviceOrderView;
    NSArray * records;
    NSArray * installedModRecordsArray;
    NSArray * availableModRecordsArray;
    
    UILabel * nameLabel;
    UIImageView * imageView;
    UIButton * addButton;
    UILabel * syncTimeLabel;
    NSDateFormatter *formatter;

    NSString *str;
    
    BOOL success;
    BOOL _isSync,_isCheckBoxSelected;
    int selectedRow,selectedInstalledModRow,selectedAvailableModRow;
    
    UIView * footerView;
}
@end

@implementation InstalledProductsViewController
@synthesize userId,_isShowingMenu,_isPushing,_isGettingData,installedProductsId,installedProductsName;


// Cleaning Database and Execute Salesforce Query

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    tableDataArray = [[NSMutableArray alloc]initWithObjects:@"Work Orders",@"Installed Products",@"Logout", nil];
    
    self.title = @"Installed Products";
    
    backgroundScrollView.contentSize = CGSizeMake(1000, 1200);
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    installedProductsArray = [[DBManager getSharedInstance]getInstalledProducts];
    
    installedModsArray = [[DBManager getSharedInstance]getInstalledMods];
    availableModsArray = [[DBManager getSharedInstance]getAvailableMods];
    
    if (_isSync) {
        
        [[DBManager getSharedInstance]deleteInstalledProductsDB];
        
        [[DBManager getSharedInstance]deleteInstalledModDB];
        
        [[DBManager getSharedInstance]deleteAvailableModDB];
        
    }
    
    if ((!_isPushing && installedProductsArray.count == 0) || (_isPushing && installedProductsArray.count == 0)) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //
        [[DBManager getSharedInstance]deleteInstalledProductsDB];
        
        [[DBManager getSharedInstance]deleteInstalledModDB];
        
        [[DBManager getSharedInstance]deleteAvailableModDB];
        
        SFRestRequest * request = [[SFRestAPI sharedInstance]requestForQuery:@"Select Id, Name, Serial_Number__c, Customer_Name__c, FConnect__Customer__c, FConnect__Contact__c, AssetUniqueField__c, Asset_Name__c, FConnect__Item_ID_Used__c, Latitude__c, Longitude__c,(select Id, Name, Installed_Products__c, Install__c, Installed_Date__c, Mod_Required__c, Mod_Name__c, Existing_Mod__c, Mod_Number__c, Doc_Title__c from Installed_Mods__r), (select Id, Name, Installed_Products__c, Install__c, Installed_Date__c, Mod_Required__c, Mod_Name__c, Mod_Number__c, Existing_Mod__c, Doc_Title__c from Available_Mod__r)  FROM FConnect__Installed_Products__c"];
        
        [[SFRestAPI sharedInstance] send:request delegate:self];
        
    }
    if (_isPushing &&  installedProductsArray.count > 0 && !_isSync) {
        
        [self showingInstalledProductsDetails];
        
        [installedModTableView reloadData];
        
    }
    
    if ((!_isPushing && _isSync) || (_isPushing && _isSync)) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        SFRestRequest * request = [[SFRestAPI sharedInstance]requestForQuery:@"Select Id, Name, Serial_Number__c, Customer_Name__c, FConnect__Customer__c, FConnect__Contact__c, AssetUniqueField__c, Asset_Name__c, FConnect__Item_ID_Used__c, Latitude__c, Longitude__c,(select Id, Name, Installed_Products__c, Install__c, Installed_Date__c, Mod_Required__c, Mod_Name__c, Existing_Mod__c, Mod_Number__c, Doc_Title__c from Installed_Mods__r), (select Id, Name, Installed_Products__c, Install__c, Installed_Date__c, Mod_Required__c, Mod_Name__c, Mod_Number__c, Existing_Mod__c, Doc_Title__c from Available_Mod__r)  FROM FConnect__Installed_Products__c"];
        
        [[SFRestAPI sharedInstance] send:request delegate:self];
        
    }
    
    _isShowingMenu = NO;
    _isSync = NO;
    _isCheckBoxSelected = NO;
    
    serviceOrderView = [[ServiceOrdersViewController alloc]init];
    
    //     Do any additional setup after loading the view from its nib.
    
}


-(void)viewWillAppear:(BOOL)animated
{
    backgroundScrollView.contentSize = CGSizeMake(1000, 1200);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_isSync) {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"dd/MM/yyyy HH:mm aa";
            NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
            syncTimeLabel.text =stringFromDate;

           
            //            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
        }
    });
    
    installedProductsArray = [[NSMutableArray alloc]init];
    installedModsArray = [[NSMutableArray alloc]init];
    availableModsArray = [[NSMutableArray alloc]init];
    
    
    installedProductsArray = [[DBManager getSharedInstance]getInstalledProducts];
    
    installedModsArray = [[DBManager getSharedInstance]getInstalledMods];
    availableModsArray = [[DBManager getSharedInstance]getAvailableMods];
    
    [installedProductsTableView reloadData];
    [installedModTableView reloadData];
    
    [self ShowNavigationBar];
    
    [timeIntervalBtn setTitle:@"15 min" forState:UIControlStateNormal];
    
    
}

-(void)ShowNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    
    
//    CGRect frame = CGRectMake(0, 0, 180, 44);
//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:frame];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    titleLabel.text = @"Installed Products";
//    titleLabel.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = titleLabel;
//    
//    self.title = @"Installed Products";
//    
//    
//    self.navigationItem.hidesBackButton = YES;
//    
    
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
    [homeBtn addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    [arrLeftBarItems addObject:barButtonItem2];
    
    UILabel *installedProductsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,70)];
    installedProductsLabel.text = @"Installed Products";
    installedProductsLabel.textColor = [UIColor whiteColor];
    installedProductsLabel.font = [UIFont boldSystemFontOfSize:18.0];
    installedProductsLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:installedProductsLabel];
    [arrLeftBarItems addObject:barButtonItem3];

    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    
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

// Showing Menu

-(void)showMenu {
    
    if (_isShowingMenu) {
        _isShowingMenu = NO;
        [leftMenuTableView setHidden:YES];
        installedProductsTableView.frame = CGRectMake(0, 0, 300, 600);
        installedProductsDetailsView.frame = CGRectMake(300, 0, 450, 800);
        installedModSegmentControl.frame = CGRectMake(750, 15, 300, 29);
        installedModTableView.frame = CGRectMake(750, 50, 250, 568);
        
        return;
    }
    
    _isShowingMenu = YES;
    [leftMenuTableView setHidden:NO];
    installedProductsTableView.frame = CGRectMake(202, 0, 300, 600);
    installedProductsDetailsView.frame = CGRectMake(502, 0, 450, 800);
    installedModSegmentControl.frame = CGRectMake(952, 15, 300, 29);
    installedModTableView.frame = CGRectMake(952, 50, 250, 568);
    
    
}

// Showing Timeinterval

-(void)timeIntervalButtonAction:(id)sender {
    
    [timeIntervalView setHidden:NO];
    
}


// Showing Time Interval List

- (IBAction)timeIntervalBtnAction:(id)sender{
    
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

-(void)refreshButtonAction {
    
    _isPushing = NO;
    _isSync = YES;
    //
    //    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"]) {
    //
    //        NSArray *offlineArray =  [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"];
    //
    //        for (NSDictionary *offlineDict in offlineArray) {
    //
    //            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"FConnect__Installed_Products__c" objectId:[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"] fields:offlineDict];
    //            [[SFRestAPI sharedInstance] send:request delegate:self];
    //        }
    //
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OfflineData"];
    //
    //    }
    
    [self viewDidLoad];
    
}


// Going to HomeViewController

-(void)homeButtonAction {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)installedModSegmentControlAction:(id)sender {
    
    if(installedModSegmentControl.selectedSegmentIndex == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [installedModTableView reloadData];
        });
        
    } else if(installedModSegmentControl.selectedSegmentIndex == 1) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [installedModTableView reloadData];
        });
    }
    
}

- (IBAction)availableModCloseBtnAction:(id)sender {
    
    [availableModDetailsView setHidden:YES];
    
}

// Showing Installed Date

- (IBAction)availableModCheckBoxBtnAction:(id)sender {
    
    if (_isCheckBoxSelected) {
        
        [availableModCheckBoxButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
        _isCheckBoxSelected= NO;
        
        [installedDateButton setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [availableModCheckBoxButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        
        _isCheckBoxSelected= YES;
        
        NSTimeInterval startDateSeconds = [[NSDate date] timeIntervalSince1970];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSeconds];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        
        str = [formatter stringFromDate:startDate];
        
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateFormat = @"dd-MM-yyyy";
        //        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
        
        [installedDateButton setTitle:str forState:UIControlStateNormal];
        
    }
    
}

// Changing The Date

- (IBAction)installedDateBtnAction:(id)sender {
    
    datePicker.datePickerMode=UIDatePickerModeDate;
    
    [datePickerView setHidden:NO];
    
    [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
    
}


-(void)datePickerAction:(id)sender {
    
    NSTimeInterval startDateSeconds = [[NSDate date] timeIntervalSince1970];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSeconds];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
    [formatter setDateFormat:@"dd-MM-yyyy'"];
    
    //    str = [formatter stringFromDate:startDate];
    
    str=[NSString stringWithFormat:@"%@",[formatter  stringFromDate:datePicker.date]];
    //assign text to label
    
    [installedDateButton setTitle:str forState:UIControlStateNormal];
    
}

// Pushing Data available Mod to Installed Mod

- (IBAction)availableModSubmitBtnAction:(id)sender {
    
    if (_isCheckBoxSelected) {
        
        NSString *installedDateString = installedDateButton.titleLabel.text;
        
        //        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //
        //        [df setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
        //        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"];
        //
        //        NSDate *myDate = [df dateFromString: installedDateString];
        //        NSString * dateStr = [df stringFromDate:myDate];
        
        NSDateFormatter *isoDateFormatter = [[NSDateFormatter alloc] init];
        [isoDateFormatter setDateFormat:@"dd-MM-yyyy"];
        [isoDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
        
        NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
        [userFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"IST"]];
        
        NSDate *date = [isoDateFormatter dateFromString:installedDateString];
        
        NSString * dateStr = [dateFormatter stringFromDate:date];
        
        NSDictionary *dict=@{@"Installed_Date__c":dateStr,
                             @"Install__c": @YES
                             };
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Available_Mod__c" objectId:[[WOAvailableModArray objectAtIndex:selectedAvailableModRow]objectForKey:@"Id"] fields:dict];
        
        [[SFRestAPI sharedInstance] send:request delegate:self];
        
        installedDateButton.titleLabel.text = @"";
        
        [availableModCheckBoxButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
        _isCheckBoxSelected= NO;
        
    }
    
    [datePickerView setHidden:YES];
    [availableModDetailsView setHidden:YES];
    
}


- (IBAction)datePickerSetBtnAction:(id)sender {
    
    [datePickerView setHidden:YES];
}


- (IBAction)datePickerCancelBtnAction:(id)sender {
    
    NSTimeInterval startDateSeconds = [[NSDate date] timeIntervalSince1970];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSeconds];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    
    str = [formatter stringFromDate:startDate];
    
    [installedDateButton setTitle:str forState:UIControlStateNormal];
    
    [datePickerView setHidden:YES];
    
}


- (IBAction)updateLocationBtnAction:(id)sender {
    
    
    [InstalledModDetaisView setHidden:YES];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Update Location ?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Update",@"Cancel",nil];
    
    alertView.tag = 10;
    
    [alertView show];
    
}

// Storing Salesforce Response in Local Database

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [installedProductsTableView reloadData];
    });
    
    records = nil;
    records = [jsonResponse objectForKey:@"records"];
    if (records.count > 0) {
        
        if([[records objectAtIndex:0] objectForKey:@"Customer_Name__c"]) {
            
            [self saveData];
            
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [installedProductsTableView reloadData];
    });
    
    NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
    
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

// Display Installed Products Information

- (void)saveData {
    
    NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:NULL];
    
    for (int i=0; i<records.count; i++) {
        
        success = [[DBManager getSharedInstance]saveInstalledProucts:[[records objectAtIndex:i]objectForKey:@"Id"] name:[[records objectAtIndex:i]objectForKey:@"Name"] serialNumber:[[records objectAtIndex:i]objectForKey:@"Serial_Number__c"] customerName:[[records objectAtIndex:i]objectForKey:@"Customer_Name__c"] customer:[[records objectAtIndex:i]objectForKey:@"FConnect__Customer__c"] contact:[[records objectAtIndex:i]objectForKey:@"FConnect__Contact__c"] assetUniqueField:[[records objectAtIndex:i]objectForKey:@"AssetUniqueField__c"] assetName:[[records objectAtIndex:i]objectForKey:@"Asset_Name__c"] itemId:[[records objectAtIndex:i]objectForKey:@"FConnect__Item_ID_Used__c"] latittude:[[records objectAtIndex:i]objectForKey:@"Latitude__c"] longitude:[[records objectAtIndex:i]objectForKey:@"Longitude__c"]];
        
        installedProductsArray = [[DBManager getSharedInstance]getInstalledProducts];
        
        
        if (![[[records objectAtIndex:i]objectForKey:@"Installed_Mods__r"] isEqual:[NSNull null]]) {
            
            installedModRecordsArray = [[[records objectAtIndex:i]objectForKey:@"Installed_Mods__r"]objectForKey:@"records"];
            
            for (int j=0; j<installedModRecordsArray.count; j++) {
                
                //                NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
                //
                //                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:NULL];
                
                NSString *  modName = [regex stringByReplacingMatchesInString:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Name__c"] options:0 range:NSMakeRange(0, [[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Name__c"] length]) withTemplate:@"$2"];
                
                NSString *  docTitle = [regex stringByReplacingMatchesInString:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Doc_Title__c"] options:0 range:NSMakeRange(0, [[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Doc_Title__c"] length]) withTemplate:@"$2"];
                
                NSLog(@"%@%@",modName,docTitle);
                
                success = [[DBManager getSharedInstance]saveInstalledMod:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Id"] name:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Name"] installedProducts:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Installed_Products__c"] install:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Install__c"] installedDate:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Installed_Date__c"] modRequired:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Required__c"] modName:modName existingMod:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Existing_Mod__c"] modNumber:[[installedModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Number__c"] docTitle:docTitle];
                
                installedModsArray = [[DBManager getSharedInstance]getInstalledMods];
                
            }
            
        }
        
        if (![[[records objectAtIndex:i]objectForKey:@"Available_Mod__r"] isEqual:[NSNull null]]) {
            
            availableModRecordsArray = [[[records objectAtIndex:i]objectForKey:@"Available_Mod__r"]objectForKey:@"records"];
            
            for (int j=0; j<availableModRecordsArray.count; j++) {
                
                //                NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
                //                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:NULL];
                
                NSString *  modName = [regex stringByReplacingMatchesInString:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Name__c"] options:0 range:NSMakeRange(0, [[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Name__c"] length]) withTemplate:@"$2"];
                
                NSString *  docTitle = [regex stringByReplacingMatchesInString:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Doc_Title__c"] options:0 range:NSMakeRange(0, [[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Doc_Title__c"] length]) withTemplate:@"$2"];
                
                NSLog(@"%@%@",modName,docTitle);
                
                success = [[DBManager getSharedInstance]saveAvailableMod:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Id"] name:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Name"] installedProducts:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Installed_Products__c"] install:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Install__c"] installedDate:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Installed_Date__c"] modRequired:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Required__c"] modName:modName existingMod:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Existing_Mod__c"] modNumber:[[availableModRecordsArray objectAtIndex:j]objectForKey:@"Mod_Number__c"] docTitle:docTitle];
                
                availableModsArray = [[DBManager getSharedInstance]getAvailableMods];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
        }
        
    }
    
    [self showingInstalledProductsDetails];
    
    
    
}
-(void)showingInstalledProductsDetails{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _isSync = YES;
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSLog(@"Time:%@",appDelegate.myString);
        syncTimeLabel.text = appDelegate.myString;  //..to read
        
        NSLog(@"installedProductsArray:%@",installedProductsArray);
        
        for (int i=0; i<installedProductsArray.count; i++) {
            
            
            if ([installedProductsId isEqualToString:[[installedProductsArray objectAtIndex:i]objectForKey:@"Id"]] && installedProductsId != nil) {
                
                [installedModTableView reloadData];
                
                if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Customer_Name__c"] isEqualToString:@"<null>"]) {
                    
                    accountNameLabel.text =@"";
                    
                } else {
                    
                    accountNameLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Customer_Name__c"];
                    
                }
                
                if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
                    
                    serialNumberLabel.text =@"";
                    
                } else {
                    
                    serialNumberLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"];
                }
                
                if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Asset_Name__c"] isEqualToString:@"<null>"]) {
                    
                    assetNameLabel.text =@"";
                    
                } else {
                    
                    assetNameLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Asset_Name__c"];
                    
                }
                if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"AssetUniqueField__c"] isEqualToString:@"<null>"]) {
                    
                    assetUniqueFieldLabel.text =@"";
                    
                } else {
                    
                    assetUniqueFieldLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"AssetUniqueField__c"];
                }
                
                if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Latitude__c"] isEqualToString:@"<null>"]) {
                    
                    latittudeLabel.text =@"";
                    
                } else {
                    
                    latittudeLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Latitude__c"];
                }
                
                if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Longitude__c"] isEqualToString:@"<null>"]) {
                    
                    longitudeLabel.text =@"";
                    
                } else {
                    
                    longitudeLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Longitude__c"];
                }
                
                MKPointAnnotation *mappin;
                
                [installedProductsMapView removeAnnotations:installedProductsMapView.annotations];
                
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                installedProductsMapView.delegate = self;
                installedProductsMapView.showsUserLocation = YES;
                
                
                
                MKCoordinateRegion region = installedProductsMapView.region;
                
                region.center = CLLocationCoordinate2DMake([[[installedProductsArray objectAtIndex:i]objectForKey:@"Latitude__c"] doubleValue], [[[installedProductsArray objectAtIndex:i]objectForKey:@"Longitude__c"] doubleValue]);
                
                CLLocationCoordinate2D location;
                
                NSMutableArray * annotation=[[NSMutableArray alloc]initWithCapacity:1];
                
                location = region.center;
                mappin = [[MKPointAnnotation alloc]init];
                mappin.coordinate=location;
                
                [annotation addObject:mappin];
                
                mappin.title = [[installedProductsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"];
                
                
                [installedProductsMapView setRegion:region animated:NO];
                
                [installedProductsMapView addAnnotation:mappin];
                
                [installedProductsTableView reloadData];
                
                [installedModTableView reloadData];
                
                return ;
                
            }
            
        }
        
        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Customer_Name__c"] isEqualToString:@"<null>"]) {
            
            accountNameLabel.text =@"";
            
        } else {
            
            accountNameLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Customer_Name__c"];
            
        }
        
        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
            
            serialNumberLabel.text =@"";
            
        } else {
            
            serialNumberLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
            
        }
        
        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Asset_Name__c"] isEqualToString:@"<null>"]) {
            
            assetNameLabel.text =@"";
            
        } else {
            
            assetNameLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Asset_Name__c"];
            
        }
        
        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"AssetUniqueField__c"] isEqualToString:@"<null>"]) {
            
            assetUniqueFieldLabel.text =@"";
            
        } else {
            
            assetUniqueFieldLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"AssetUniqueField__c"];
        }
        
        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"] isEqualToString:@"<null>"]) {
            
            latittudeLabel.text =@"";
            
        } else {
            
            latittudeLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"];
        }
        
        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"] isEqualToString:@"<null>"]) {
            
            longitudeLabel.text =@"";
            
        } else {
            
            longitudeLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"];
        }
        
        MKPointAnnotation *mappin;
        
        [installedProductsMapView removeAnnotations:installedProductsMapView.annotations];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        installedProductsMapView.delegate = self;
        installedProductsMapView.showsUserLocation = YES;
        
        
        MKCoordinateRegion region = installedProductsMapView.region;
        
        region.center = CLLocationCoordinate2DMake([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"] doubleValue], [[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"] doubleValue]);
        
        CLLocationCoordinate2D location;
        
        NSMutableArray * annotation=[[NSMutableArray alloc]initWithCapacity:1];
        
        location = region.center;
        mappin = [[MKPointAnnotation alloc]init];
        mappin.coordinate=location;
        
        [annotation addObject:mappin];
        
        mappin.title = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
        
        
        [installedProductsMapView setRegion:region animated:NO];
        
        [installedProductsMapView addAnnotation:mappin];
        
        [installedProductsTableView reloadData];
        [installedModTableView reloadData];
        
    });
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == leftMenuTableView) {
        
        return [tableDataArray count];
    }
    
    if (tableView == installedProductsTableView) {
        
        return [installedProductsArray count];
        
    }
    
    if (tableView == installedModTableView) {
        
        if(installedModSegmentControl.selectedSegmentIndex==0) {
            installedModCount=0;
            WOInstalledModArray = [[NSMutableArray alloc]init];
            
            for (int i =0; i<installedModsArray.count; i++) {
                
                if (_isPushing) {
                    
                    if ([installedProductsId isEqualToString:[[installedModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]]) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Installed_Date__c"] forKey:@"Installed_Date__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Install__c"] forKey:@"Install__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Required__c"] forKey:@"Mod_Required__c"];
                        
                        [WOInstalledModArray addObject:dataDict];
                        
                        installedModCount++;
                        
                    }
                } else {
                    
                    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[installedModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]] ) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Installed_Date__c"] forKey:@"Installed_Date__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Install__c"] forKey:@"Install__c"];
                        [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Required__c"] forKey:@"Mod_Required__c"];
                        
                        [WOInstalledModArray addObject:dataDict];
                        
                        installedModCount++;
                    }
                    
                }
                
            }
            
            return installedModCount;
            
        } else if(installedModSegmentControl.selectedSegmentIndex==1) {
            
            availableModCount=0;
            
            WOAvailableModArray = [[NSMutableArray alloc]init];
            
            if (availableModsArray.count > 0) {
                
                for (int i =0; i<availableModsArray.count; i++) {
                    
                    
                    if (_isPushing) {
                        
                        if ([installedProductsId isEqualToString:[[availableModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]]) {
                            
                            
                            NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                            
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Installed_Date__c"] forKey:@"Installed_Date__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                            
                            [WOAvailableModArray addObject:dataDict];
                            
                            availableModCount++;
                        }
                        
                    } else {
                        
                        if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[availableModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]] ) {
                            
                            NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                            
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Installed_Date__c"] forKey:@"Installed_Date__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                            [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                            
                            [WOAvailableModArray addObject:dataDict];
                            
                            availableModCount++;
                        }
                    }
                    
                }
                
            }
            
            return availableModCount;
        }
        
    }
    
    return [installedProductsArray count];
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cell.contentView.frame.size.width,cell.contentView.frame.size.height)];
    
    [cell.contentView addSubview:imageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 200, 30)];
    nameLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor blackColor];
    //    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    if (tableView == leftMenuTableView) {
        
        nameLabel.text = [tableDataArray objectAtIndex:indexPath.row];
        
    }
    
    if (tableView == installedProductsTableView) {
        
        if ([installedProductsId isEqualToString:[[installedProductsArray objectAtIndex:indexPath.row]objectForKey:@"Id"]] && installedProductsId == nil) {
            
            cell.selectedBackgroundView = [[UIImageView alloc] init];
            UIImage *img  = [UIImage imageNamed:@"selected_stock.png"];
            ((UIImageView *)cell.selectedBackgroundView).image = img;
            
        }
        nameLabel.text = [[installedProductsArray objectAtIndex:indexPath.row]objectForKey:@"Serial_Number__c"];
        
    }
    
    if (tableView == installedModTableView) {
        
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(10, 20, 30, 30);
        [addButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:addButton];
        
        if(installedModSegmentControl.selectedSegmentIndex==0) {
            
            [addButton setHidden:NO];
            
            if (WOInstalledModArray.count > 0 ) {
                
                NSDictionary * dict =[WOInstalledModArray objectAtIndex:indexPath.row];
                
                NSString *joinString=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"Mod_Name__c"],[dict objectForKey:@"Mod_Number__c"]];
                NSLog(@"joinString:%@",joinString);
                
                nameLabel.font = [UIFont fontWithName:@"Arial" size:12];
                
                nameLabel.text = joinString;
                
            }
            
            //            nameLabel.text = [dict objectForKey:@"Name"];
            
        }
        
        if(installedModSegmentControl.selectedSegmentIndex==1) {
            
            [addButton setHidden:YES];
            
            if (WOAvailableModArray.count > 0) {
                
                NSDictionary * dict =[WOAvailableModArray objectAtIndex:indexPath.row];
                
                NSString *joinString=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"Mod_Name__c"],[dict objectForKey:@"Mod_Number__c"]];
                NSLog(@"joinString:%@",joinString);
                
                nameLabel.font = [UIFont fontWithName:@"Arial" size:12];
                
                nameLabel.text = joinString;
                
                //                nameLabel.text = [dict objectForKey:@"Name"];
                
            }
            
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == leftMenuTableView) {
        
        if (indexPath.row == 0) {
            
            serviceOrderView._isPushing = YES;
            
            serviceOrderView.userId = userId;
            
            [self.navigationController pushViewController:serviceOrderView animated:YES];
        }
        
        if (indexPath.row == 1) {
            
            _isShowingMenu = NO;
            [leftMenuTableView setHidden:YES];
            installedProductsTableView.frame = CGRectMake(0, 65, 300, 600);
            installedProductsDetailsView.frame = CGRectMake(300, 65, 450, 800);
            installedModSegmentControl.frame = CGRectMake(750, 80, 300, 29);
            installedModTableView.frame = CGRectMake(750, 115, 250, 568);
        }
        
        if (indexPath.row == 2) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Logout ?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
            [alertView show];
            
        }
        
    }
    
    if (tableView == installedProductsTableView) {
        
        _isPushing = NO;
        
        [InstalledModDetaisView setHidden:YES];
        
        selectedRow =  (int)indexPath.row;
        
        [self serviceOrdersRowClicked];
        
        [installedModTableView reloadData];
        
    }
    
    if (tableView == installedModTableView) {
        
        if(installedModSegmentControl.selectedSegmentIndex == 0) {
            
            selectedInstalledModRow = (int)indexPath.row;
            
            installedModNameLabel.text =[[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Name"];
            
            if ([[[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Install__c"] isEqualToString:@"0"]) {
                
                [installedModInstallButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            }
            if ([[[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Install__c"] isEqualToString:@"1"]) {
                
                [installedModInstallButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
            }
            
            installedModInstalledDateLabel.text = [[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Installed_Date__c"];
            
            installedModModNameLabel.text = [[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Mod_Name__c"];
            installedModModNumberLabel.text = [[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Mod_Number__c"];
            
            if ([[[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Mod_Required__c"] isEqualToString:@"0"]) {
                
                [installedModModRequiredButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            }
            if ([[[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Mod_Required__c"] isEqualToString:@"1"]) {
                
                [installedModModRequiredButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
            }
            
            installedModDocTitleLabel.text = [[WOInstalledModArray objectAtIndex:selectedInstalledModRow]objectForKey:@"Doc_Title__c"];
            
            
        }
        
        
        if(installedModSegmentControl.selectedSegmentIndex == 1) {
            
            selectedAvailableModRow = (int)indexPath.row;
            
            
        }
        
        [self activitiesRowClicked:indexPath];
        
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == installedProductsTableView) {
        cell.selectedBackgroundView = [[UIImageView alloc] init];
        UIImage *img  = [UIImage imageNamed:@"selected_stock.png"];
        ((UIImageView *)cell.selectedBackgroundView).image = img;
    }
    if (tableView == installedModTableView) {
        
        if (installedModSegmentControl.selectedSegmentIndex == 0) {
            
            //            [addButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
            
            cell.selectedBackgroundView = [[UIImageView alloc] init];
            UIImage *img  = [UIImage imageNamed:@"install_mod.png"];
            ((UIImageView *)cell.selectedBackgroundView).image = img;
            
        } else {
            
            cell.selectedBackgroundView = [[UIImageView alloc] init];
            UIImage *img  = [UIImage imageNamed:@"selected_inv.png"];
            ((UIImageView *)cell.selectedBackgroundView).image = img;
            
        }
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorColor:[UIColor whiteColor]];
    return 60;
}


-(void)addButtonAction:(id)sender {
    
    NSLog(@"Need To Show FooterView");
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (tableView == installedModTableView) {
//
//        return 220.0f;
//    }
//
//    return 0.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
////    installedModTableView.tableFooterView.hidden = YES;
////    tableView.sectionFooterHeight = 0.0;
//
//    if (tableView == installedModTableView) {
//
//        if(installedModSegmentControl.selectedSegmentIndex == 0) {
//
//            CGRect frame1 = CGRectMake(0,0,self.view.frame.size.width,300);
//
//            footerView = [[UIView alloc] initWithFrame:frame1];
//                        footerView.backgroundColor = [UIColor clearColor];
//
//            UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake(0,/*150*/0.0f,self.view.frame.size.width,0)];
//
//            [centerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
//
//            [footerView addSubview:centerView];
//
//
//            UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 50, 20)];
//            label1.font = [UIFont fontWithName:@"Arial" size:12];
//            label1.text = @"Name:";
//
//            UILabel * detailedNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 100, 20)];
//            detailedNameLabel.font = [UIFont fontWithName:@"Arial" size:12];
//            detailedNameLabel.text = [[WOInstalledModArray objectAtIndex:section]objectForKey:@"Name"];
//
//            [centerView addSubview:detailedNameLabel];
//            [centerView addSubview:label1];
//
//            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 60, 20)];
//            label2.font = [UIFont fontWithName:@"Arial" size:12];
//            label2.text = @"Install:";
//
//            UIButton * detailedInstalledButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            detailedInstalledButton.frame = CGRectMake(130, 40, 25, 25);
//            if ([[[WOInstalledModArray objectAtIndex:section]objectForKey:@"Install__c"] isEqualToString:@"0"]) {
//
//                [detailedInstalledButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
//            }
//            if ([[[WOInstalledModArray objectAtIndex:section]objectForKey:@"Install__c"] isEqualToString:@"1"]) {
//
//                [detailedInstalledButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
//            }
//
//            [centerView addSubview:detailedInstalledButton];
//            [centerView addSubview:label2];
//
//            UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 100, 20)];
//            label3.font = [UIFont fontWithName:@"Arial" size:12];
//            label3.text = @"Installed Date:";
//
//            UILabel * detailedInstalledDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 70, 70, 20)];
//            detailedInstalledDateLabel.font = [UIFont fontWithName:@"Arial" size:12];
//            detailedInstalledDateLabel.text = [[WOInstalledModArray objectAtIndex:section]objectForKey:@"Installed_Date__c"];
//            [centerView addSubview:detailedInstalledDateLabel];
//            [centerView addSubview:label3];
//
//            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 20)];
//            label4.font = [UIFont fontWithName:@"Arial" size:12];
//            label4.text = @"Mod Name:";
//
//            UILabel * detailedModNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 100, 100, 20)];
//            detailedModNameLabel.font = [UIFont fontWithName:@"Arial" size:12];
//            detailedModNameLabel.text = [[WOInstalledModArray objectAtIndex:section]objectForKey:@"Mod_Name__c"];
//
//            [centerView addSubview:detailedModNameLabel];
//            [centerView addSubview:label4];
//
//            UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, 100, 20)];
//            label5.font = [UIFont fontWithName:@"Arial" size:12];
//            label5.text = @"Mod Number:";
//
//            UILabel * detailedModNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 130, 100, 20)];
//            detailedModNumberLabel.font = [UIFont fontWithName:@"Arial" size:12];
//            detailedModNumberLabel.text = [[WOInstalledModArray objectAtIndex:section]objectForKey:@"Mod_Number__c"];
//
//            [centerView addSubview:detailedModNumberLabel];
//            [centerView addSubview:label5];
//
//            UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 100, 30)];
//            label6.font = [UIFont fontWithName:@"Arial" size:12];
//            label6.text = @"Mod Required?:";
//
//            UIButton * detailedModRequiredButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            detailedModRequiredButton.frame = CGRectMake(130, 160, 25, 25);
//            if ([[[WOInstalledModArray objectAtIndex:section]objectForKey:@"Mod_Required__c"] isEqualToString:@"0"]) {
//
//                [detailedModRequiredButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
//            }
//            if ([[[WOInstalledModArray objectAtIndex:section]objectForKey:@"Mod_Required__c"] isEqualToString:@"1"]) {
//
//                [detailedModRequiredButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
//            }
//
//            [centerView addSubview:detailedModRequiredButton];
//            [centerView addSubview:label6];
//
//            UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(20, 190, 100, 20)];
//            label7.font = [UIFont fontWithName:@"Arial" size:12];
//            label7.text = @"Doc Title:";
//
//            UILabel * detailedDocTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 190, 100, 20)];
//            detailedDocTitleLabel.font = [UIFont fontWithName:@"Arial" size:12];
//            detailedDocTitleLabel.text = [[WOInstalledModArray objectAtIndex:section]objectForKey:@"Doc_Title__c"];
//
//            [centerView addSubview:detailedDocTitleLabel];
//            [centerView addSubview:label7];
//
//            return centerView;
//
//        }
//    }
//
//    return nil;
//}

-(void)serviceOrdersRowClicked {
    
    //    for (int i=0; i<installedProductsArray.count; i++) {
    
    
    //        if ([installedProductsId isEqualToString:[[installedProductsArray objectAtIndex:i]objectForKey:@"Id"]] && installedProductsId != nil) {
    //
    //            [installedModTableView reloadData];
    //
    //            if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Customer_Name__c"] isEqualToString:@"<null>"]) {
    //
    //                accountNameLabel.text =@"";
    //
    //            } else {
    //
    //                accountNameLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Customer_Name__c"];
    //
    //            }
    //
    //            if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
    //
    //                serialNumberLabel.text =@"";
    //
    //            } else {
    //
    //                serialNumberLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"];
    //
    //            }
    //
    //            if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Asset_Name__c"] isEqualToString:@"<null>"]) {
    //
    //                assetNameLabel.text =@"";
    //
    //            } else {
    //
    //                assetNameLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Asset_Name__c"];
    //
    //            }
    //
    //            if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"AssetUniqueField__c"] isEqualToString:@"<null>"]) {
    //
    //                assetUniqueFieldLabel.text =@"";
    //
    //            } else {
    //
    //                assetUniqueFieldLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"AssetUniqueField__c"];
    //            }
    //
    //            if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Latitude__c"] isEqualToString:@"<null>"]) {
    //
    //                latittudeLabel.text =@"";
    //
    //            } else {
    //
    //                latittudeLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Latitude__c"];
    //            }
    //
    //            if ([[[installedProductsArray objectAtIndex:i]objectForKey:@"Longitude__c"] isEqualToString:@"<null>"]) {
    //
    //                longitudeLabel.text =@"";
    //
    //            } else {
    //
    //                longitudeLabel.text = [[installedProductsArray objectAtIndex:i]objectForKey:@"Longitude__c"];
    //            }
    //
    //            MKPointAnnotation *mappin;
    //
    //            [installedProductsMapView removeAnnotations:installedProductsMapView.annotations];
    //
    //            self.locationManager = [[CLLocationManager alloc] init];
    //            self.locationManager.delegate = self;
    //            installedProductsMapView.delegate = self;
    //            installedProductsMapView.showsUserLocation = YES;
    //
    //            MKCoordinateRegion region = installedProductsMapView.region;
    //
    //            region.center = CLLocationCoordinate2DMake([[[installedProductsArray objectAtIndex:i]objectForKey:@"Latitude__c"] doubleValue], [[[installedProductsArray objectAtIndex:i]objectForKey:@"Longitude__c"] doubleValue]);
    //
    //            CLLocationCoordinate2D location;
    //
    //            NSMutableArray * annotation=[[NSMutableArray alloc]initWithCapacity:1];
    //
    //            location = region.center;
    //            mappin = [[MKPointAnnotation alloc]init];
    //            mappin.coordinate=location;
    //
    //            [annotation addObject:mappin];
    //
    //            mappin.title = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
    //
    //            [installedProductsMapView setRegion:region animated:NO];
    //
    //            [installedProductsMapView addAnnotation:mappin];
    //
    //            [installedProductsTableView reloadData];
    //
    //            [installedModTableView reloadData];
    //
    //            return ;
    //
    //        }
    
    //    }
    
    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Customer_Name__c"] isEqualToString:@"<null>"]) {
        
        accountNameLabel.text =@"";
        
    } else {
        
        accountNameLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Customer_Name__c"];
        
    }
    
    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
        
        serialNumberLabel.text =@"";
        
    } else {
        
        serialNumberLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
        
    }
    
    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Asset_Name__c"] isEqualToString:@"<null>"]) {
        
        assetNameLabel.text =@"";
        
    } else {
        
        assetNameLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Asset_Name__c"];
        
    }
    
    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"AssetUniqueField__c"] isEqualToString:@"<null>"]) {
        
        assetUniqueFieldLabel.text =@"";
        
    } else {
        
        assetUniqueFieldLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"AssetUniqueField__c"];
    }
    
    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"] isEqualToString:@"<null>"]) {
        
        latittudeLabel.text =@"";
        
    } else {
        
        latittudeLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"];
    }
    
    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"] isEqualToString:@"<null>"]) {
        
        longitudeLabel.text =@"";
        
    } else {
        
        longitudeLabel.text = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"];
        
    }
    
    MKPointAnnotation *mappin;
    
    [installedProductsMapView removeAnnotations:installedProductsMapView.annotations];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    installedProductsMapView.delegate = self;
    
    installedProductsMapView.showsUserLocation = YES;
    
    
    MKCoordinateRegion region = installedProductsMapView.region;
    
    region.center = CLLocationCoordinate2DMake([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Latitude__c"] doubleValue], [[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Longitude__c"] doubleValue]);
    
    CLLocationCoordinate2D location;
    
    NSMutableArray * annotation=[[NSMutableArray alloc]initWithCapacity:1];
    
    location = region.center;
    mappin = [[MKPointAnnotation alloc]init];
    mappin.coordinate=location;
    [annotation addObject:mappin];
    
    mappin.title = [[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
    
    [installedProductsMapView setRegion:region animated:NO];
    
    [installedProductsMapView addAnnotation:mappin];
    
}


-(void)activitiesRowClicked:(NSIndexPath *)indexPath {
    
    if(installedModSegmentControl.selectedSegmentIndex == 0) {
        
        [InstalledModDetaisView setHidden:NO];
        
        [availableModDetailsView setHidden:YES];
        
        WOInstalledModArray = [[NSMutableArray alloc]init];
        
        for (int i =0; i<installedModsArray.count; i++) {
            
            if (_isPushing) {
                
                if ([installedProductsId isEqualToString:[[installedModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]] ) {
                    
                    
                    
                    
                    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                    
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                    
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Install__c"] forKey:@"Install__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Required__c"] forKey:@"Mod_Required__c"];
                    
                    
                    [WOInstalledModArray addObject:dataDict];
                    
                    
                }
            } else {
                
                if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[installedModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]] ) {
                    
                    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                    
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                    
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Install__c"] forKey:@"Install__c"];
                    [dataDict setObject:[[installedModsArray objectAtIndex:i] objectForKey:@"Mod_Required__c"] forKey:@"Mod_Required__c"];
                    
                    
                    [WOInstalledModArray addObject:dataDict];
                    
                }
                
                
            }
            
        }
        
        if (WOInstalledModArray.count>0) {
            
            NSDictionary * activitiesDict = [WOInstalledModArray objectAtIndex:indexPath.row];
            NSLog(@"activitiesDict:%@",activitiesDict);
            
        }
        
        
    } else if(installedModSegmentControl.selectedSegmentIndex == 1) {
        
        [availableModDetailsView setHidden:NO];
        
        [InstalledModDetaisView setHidden:YES];
        
        NSString *joinString=[NSString stringWithFormat:@"%@  %@",[[WOAvailableModArray objectAtIndex:selectedAvailableModRow] objectForKey:@"Mod_Name__c"],[[WOAvailableModArray objectAtIndex:selectedAvailableModRow] objectForKey:@"Mod_Number__c"]];
        
        NSLog(@"joinString:%@",joinString);
        
        availableModDetailsLabel.text = joinString;
        
        WOAvailableModArray = [[NSMutableArray alloc]init];
        
        if (availableModsArray.count > 0) {
            
            for (int i =0; i<availableModsArray.count; i++) {
                
                if (_isPushing) {
                    
                    if ([installedProductsId isEqualToString:[[availableModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]]) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                        
                        [WOAvailableModArray addObject:dataDict];
                        
                    }
                    
                } else {
                    
                    
                    if ([[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"]isEqualToString:[[availableModsArray objectAtIndex:i]objectForKey:@"Installed_Products__c"]] ) {
                        
                        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                        
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Id"] forKey:@"Id"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Name"] forKey:@"Name"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Doc_Title__c"] forKey:@"Doc_Title__c"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Existing_Mod__c"] forKey:@"Existing_Mod__c"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Name__c"] forKey:@"Mod_Name__c"];
                        [dataDict setObject:[[availableModsArray objectAtIndex:i] objectForKey:@"Mod_Number__c"] forKey:@"Mod_Number__c"];
                        
                        [WOAvailableModArray addObject:dataDict];
                    }
                    
                }
                
                
            }
            
            if (WOAvailableModArray.count > 0) {
                
                NSDictionary * reqMeterialsDict = [WOAvailableModArray objectAtIndex:indexPath.row];
                NSLog(@"reqMeterialsDict:%@",reqMeterialsDict);
                
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10) {
        
        if (buttonIndex == 0)
        {
            
            MKPointAnnotation *mappin;
            
            [installedProductsMapView removeAnnotations:installedProductsMapView.annotations];
            
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            installedProductsMapView.delegate = self;
            installedProductsMapView.showsUserLocation = YES;
            
            
            MKCoordinateRegion region = installedProductsMapView.region;
            
            region.center = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
            
            CLLocationCoordinate2D location;
            
            NSMutableArray * annotation=[[NSMutableArray alloc]initWithCapacity:1];
            
            location = region.center;
            mappin = [[MKPointAnnotation alloc]init];
            mappin.coordinate=location;
            
            [annotation addObject:mappin];
            
            mappin.title = @"Current Location";
            
            latittudeLabel.text = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
            
            longitudeLabel.text = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
            
            [installedProductsMapView setRegion:region animated:NO];
            
            [installedProductsMapView addAnnotation:mappin];
            
            
            NSDictionary * dict = @{@"Latitude__c":latittudeLabel.text,
                                    @"Longitude__c":longitudeLabel.text,
                                    };
            
            
            if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] != SFSDKReachabilityNotReachable) {
                
                SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"FConnect__Installed_Products__c" objectId:[[installedProductsArray objectAtIndex:selectedRow]objectForKey:@"Id"] fields:dict];
                [[SFRestAPI sharedInstance] send:request delegate:self];
                
            }
            
            if ([[SFSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == SFSDKReachabilityNotReachable) {
                
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"]) {
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"] isKindOfClass:[NSArray class]]) {
                        
                        NSArray *dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"OfflineData"];
                        [array addObjectsFromArray:dataArray];
                        
                        [array addObject:dict];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"OfflineData"];
                    }
                    
                } else {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@[dict] forKey:@"OfflineData"];
                }
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
        } else if (buttonIndex == 1) {
            
            [alertView dismissWithClickedButtonIndex:1 animated:TRUE];
        }
        
        return;
    }
    
    if (buttonIndex == 0)
    {
        [[SFAuthenticationManager sharedManager] logout];
        
    } else if (buttonIndex == 1) {
        
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
