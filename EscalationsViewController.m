//
//  EscalationsViewController.m
//  FS360
//
//  Created by BiznusSoft on 9/9/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import "EscalationsViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "SFAuthenticationManager.h"


@interface EscalationsViewController ()<SFRestDelegate>
{
    ServiceOrdersViewController * serviceOrderView;
    InstalledProductsViewController * installedProductsView;
    
    UILabel * syncTimeLabel;
//    UIButton *newEscalationButton;

    NSArray *records;

    BOOL success;
    
    int escalationCount,selectedRow;

}
@end

@implementation EscalationsViewController
@synthesize userId,_isShowingMenu,workOrderId,workOrderName,escalationPickerView,pickerStatusArray,pickerTypeArray,pickerSymptomsArray;


// Cleaning Database and Execute Salesforce Query

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [escalationNotFoundLabel setHidden:YES];
    
    NSLog(@"userId:%@",userId);
    
    serviceOrderView = [[ServiceOrdersViewController alloc]init];
    installedProductsView = [[InstalledProductsViewController alloc]init];
    self.title = @"Installed Products";
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _isShowingMenu = NO;

    backgroundScrollView.contentSize = CGSizeMake(1050, 0);
    newEscalationScrollview.contentSize = CGSizeMake(1050, 0);

    
    SFRestRequest * request1 = [[SFRestAPI sharedInstance]requestForQuery:@"select Id, Name, Account__c, Case__c, Asset__c, Installed_Product__c, Work_Order__c, Site__c,Type__c,Escalation_Owner__c,Part_Number__c,Case_Owner__c,Status__c,FSE__c,Case_Priority__c,Problem_Description__c,Escalation_Symptoms__c,End_Date__c,Time_Open__c,Serial_Number__c,Escalation_Resolution__c  FROM Escalations__c"];
    
    [[SFRestAPI sharedInstance] send:request1 delegate:self];
    


    [[DBManager getSharedInstance]deleteEscationsDB];
    
    

    NSLog(@"workOrderId:%@,workOrderName:%@",workOrderId,workOrderName);

    tableDataArray = [[NSMutableArray alloc]initWithObjects:@"Work Orders",@"Installed Products",@"Logout", nil];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self ShowNavigationBar];
    
    backgroundScrollView.contentSize = CGSizeMake(1050, 0);
    newEscalationScrollview.contentSize = CGSizeMake(1050, 0);

    escalationsArray = [[NSMutableArray alloc]init];
    
    [escalationsTableView reloadData];
    
    [timeIntervalBtn setTitle:@"15 min" forState:UIControlStateNormal];

}


// Adding Navigationbar Buttons

-(void)ShowNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
    
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.text = @"Escalations";
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.title = @"Escalations";
    
    
    self.navigationItem.hidesBackButton = YES;
    
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
    
    self.navigationItem.leftBarButtonItems=arrLeftBarItems;
    
    
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    UIButton * newEscalationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newEscalationButton setImage:[UIImage imageNamed:@"newEscalation.png"] forState:UIControlStateNormal];
    newEscalationButton.frame = CGRectMake(0, 0, 120, 32);
    newEscalationButton.showsTouchWhenHighlighted=YES;
    [newEscalationButton addTarget:self action:@selector(newEscalationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn7 = [[UIBarButtonItem alloc] initWithCustomView:newEscalationButton];
    [arrRightBarItems addObject:rightBarBtn7];
    
    UIButton * setTimeIntervalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setTimeIntervalButton setImage:[UIImage imageNamed:@"time_interval.png"] forState:UIControlStateNormal];
    setTimeIntervalButton.frame = CGRectMake(100, 0, 32, 32);
    setTimeIntervalButton.showsTouchWhenHighlighted=YES;
    [setTimeIntervalButton addTarget:self action:@selector(timeIntervalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn1 = [[UIBarButtonItem alloc] initWithCustomView:setTimeIntervalButton];
    [arrRightBarItems addObject:rightBarBtn1];
    
    UILabel *emptyLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,30)];
    emptyLabel1.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel1];
    [arrRightBarItems addObject:rightBarBtn2];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"sync.png"] forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(0, 0, 32, 32);
    refreshBtn.showsTouchWhenHighlighted=YES;
    [refreshBtn addTarget:self action:@selector(refreshButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn3 = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    [arrRightBarItems addObject:rightBarBtn3];
    
    UILabel *emptyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,30)];
    emptyLabel2.textColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarBtn4 = [[UIBarButtonItem alloc] initWithCustomView:emptyLabel2];
    [arrRightBarItems addObject:rightBarBtn4];
    
    syncTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,115,30)];
    syncTimeLabel.textColor = [UIColor whiteColor];
    syncTimeLabel.font = [UIFont fontWithName:@"Arial" size:12];
    UIBarButtonItem *rightBarBtn5 = [[UIBarButtonItem alloc] initWithCustomView:syncTimeLabel];
    [arrRightBarItems addObject:rightBarBtn5];
    
    UILabel *syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,30)];
    syncLabel.text = @"Last Sync:";
    syncLabel.textColor = [UIColor whiteColor];
    syncLabel.font = [UIFont fontWithName:@"Arial" size:12];
    UIBarButtonItem *rightBarBtn6 = [[UIBarButtonItem alloc] initWithCustomView:syncLabel];
    [arrRightBarItems addObject:rightBarBtn6];
    
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    
}

-(void)newEscalationButtonAction:(id)sender
{
    [newEscalationsView setHidden:NO];
    [backgroundScrollView setHidden:YES];
    
    
    
    
}


// Showing Menu

-(void)showMenu {
    
    if (_isShowingMenu) {
        _isShowingMenu = NO;
        [leftMenuTableView setHidden:YES];
        [newEscalationsView setHidden:YES];
        backgroundScrollView.frame = CGRectMake(0, 0, 1000, 1000);

        return;
    }
    
    _isShowingMenu = YES;
    [leftMenuTableView setHidden:NO];
    backgroundScrollView.frame = CGRectMake(202, 0, 1000, 1000);
    [newEscalationsView setHidden:YES];

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


// Going to HomeViewController

-(void)homeButtonAction {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


// Updated data Pushing to Salesforce Server

-(void)refreshButtonAction {
    
    [self viewDidLoad];

}



- (IBAction)escalationCancelBtnACtion:(id)sender {
    
     serviceOrderView._isPushing = YES;

    serviceOrderView.userId = userId;

    [self.navigationController pushViewController:serviceOrderView animated:YES];
}

- (IBAction)newEscalationSaveBtnAction:(id)sender {
    
}

- (IBAction)newEscalationCancelBtnACtion:(id)sender {
    if (WOEscalationsArray.count>0)
    {
        
        [backgroundScrollView setHidden:NO];
        [escalationsTableView setHidden:NO];
    }
    else if(WOEscalationsArray.count==0)
    {
        [backgroundScrollView setHidden:YES];
        [escalationsTableView setHidden:YES];

    
    [newEscalationsView setHidden:YES];
    
    }
}

- (IBAction)statusBtnAction:(id)sender {
    
    pickerStatusArray= [[NSMutableArray alloc] initWithObjects:@"Escalation Open",@"Escalation Closed",@"Escalation Discontinued", nil];

    [self showActionViewWithTitle:@"Select EscStatus"];
    [actionView setHidden:NO];

}

- (IBAction)typeBtnAction:(id)sender {
    
    pickerTypeArray= [[NSMutableArray alloc] initWithObjects:@"FRU Unavailable",@"Parts Unavailable",@"Customer Damage",@"Equipment Shipping Damage",@"Safety – Hospitalization – Fire",@"No Root Cause",@"Ink Issue", nil];

    [self showActionViewWithTitle:@"Select EscType"];
    [actionView setHidden:NO];

}

- (IBAction)escalationSymptomsBtnAction:(id)sender {
    
    pickerSymptomsArray= [[NSMutableArray alloc] initWithObjects:@"Account",@"Activation Issue",@"Adapter FIH MN4",@"Adhesion",@"Administrative",@"Agent",@"Aggregate Supply Pump Time Out",@"Air Leak",@"Authorize.Net Issue",@"Bill Acceptor",@"Bill Acceptor Cleaner",@"Blipping",@"Blurry Print",@"Bulb Not Igniting",@"Cable",@"Cable FIH MiniNet 4",@"Cable Pod LapNet",@"Cable Pwr Extension 12' PC500",@"Cable RJ45 3' Blue",@"Cable RJ45 w/Strain 15' Blue",@"Cable USB A-B w/Strain 4'",@"Can not power up",@"Can not print",@"Card Associate Staples",@"Card Cash Express Pay",@"Card Configuration Staples",@"Card Convenience FedEx",@"Card Courtesy Staples",@"Card Dispenser",@"Card Reader",@"Card Reader (L)",@"Card Reader Cable",@"Card Reader Cleaner",@"Card Reader Issue",@"Card Reader PC500",@"Card Staff",@"Card SVC FedEx",@"Card Team Member FedEx",@"Carriage X Drive - Error / Failure",@"Carriage Z Lift - Error / Failure",@"CF Card Issue",@"Clients",@"Cloud Service",@"Coin Acceptor",@"Coin Hopper",@"Color Match",@"Communication error",@"Connectors",@"Copier Issue",@"Copier Test Box MiniNet 2",@"Copier test box MiniNet 4",@"Curing System Not Working",@"Customer Application / Operation Question",@"Customer not entitled",@"Customer Request",@"Damaged Part",@"Dashboard",@"Database Problem",@"Defective Cable",@"De-Install",@"Display Issue",@"DockNet",@"Documentation",@"Environment",@"Environment/Server",@"Envrt/System Issue",@"EP PC Access",@"Error Indicated - Non-recoverable",@"Error Indicated - Recoverable",@"ES100",@"Escalation to other groups",@"Fiery XF",@"Fiery XF Malfunction",@"Fiery XF ProServer Failure",@"FIH Cable",@"Form / Fit / Alignment - Incorrect",@"FSE Dispatch/Completed",@"Functionality Issue Fiery Apps",@"Functionality Issues Connectors",@"Functionality Issues CPS",@"Functionality Issues EFI Apps",@"Functionality Issues General",@"Functionality Issues Proofing",@"Functionality Issues Web Submission",@"Function - Intermittent Failure",@"Function - Not Working / Missing",@"Function - Unexpected behavior",@"G5 Card Reader",@"Hard Drive Issue",@"Hardware Issue",@"Head Dripping",@"Icaro",@"Image Shifting",@"Information Request",@"Ink - Adhesion",@"Ink - Cracking / Durability / Embossing",@"Ink - Curing",@"Ink - Fill errors",@"Ink Leaks",@"Ink - Leaks",@"Ink Rubbing",@"Install - Defective / Damaged parts",@"Install - DeInstallation",@"Install - Missing Parts",@"Install - No Issues",@"Install - Shipping Damage",@"Install - Site Configuration Error",@"Inter ASIC Banding",@"Intra ASIC Banding",@"IQ - Banding / Step Inconsistency",@"IQ - Corrupt output",@"IQ - Density / Color Shift",@"IQ - Jet Dropout / Wetting / Drips / Not firing",@"IQ - Misdirected nozzle / X-Deviation",@"IQ - Satellites / Grainy / Blurry",@"Jet-Outs",@"Key MiniNet 4/USB Reader (2)",@"Label Designer",@"Lamp - Can not power up",@"Lamp - Cuts out while printing",@"Lamp - Does not open / close properly / noisy",@"Lamp - Overheating",@"LCD Cleaner",@"Lock Assembly",@"Locked",@"Lock-Up - Can reboot via GUI",@"Lock-Up - System re-boot required",@"Maintenance",@"Manufacturability",@"Media - Tracking",@"Media - Wrinkling / Curling",@"Mercury",@"MiniNet 2",@"MiniNet 4C",@"MiniNet 4L",@"MiniNet 4X - Copy/Print",@"MiniNet RPS",@"Misalignment",@"Misdirected Nozzle(s)",@"MIS Integration",@"Misregistration",@"Missing ASIC(S)",@"Missing Specification or Document",@"Network Issue",@"New Opportunity",@"No Autostart",@"Not Applicable",@"Not Configured",@"Not Detected",@"Not Determined",@"Not functioning",@"On - site",@"Other",@"Overheating",@"Payment Methods",@"Performance Issue - Speed / Efficiency Loss",@"Poor Cure",@"Power Adapter 9V",@"Power Adapter MiniNet4",@"Power adaptor 10 V",@"Power adaptor 9V",@"Power Issue",@"PPC",@"Pressure/Vacuum Excessive Variation",@"Pricing Issue",@"Printer",@"Printer Issues",@"Printhead Not Printing",@"Print jobs",@"Print - Loss / Incomplete",@"PrintMessenger",@"Receipt Paper G3 Kiosk",@"Receipt Printer",@"RFID Errors",@"Safety - E-Stop / Smoke Alarm",@"Scada",@"Scanner",@"Security - Smartcard / Key Dongle",@"Serviceability",@"Shutters Not Opening",@"Site Administration",@"Site Functionality Issues",@"Site Readiness Preparation",@"Slow Heating",@"Software",@"Software Installation",@"Software Issues",@"Software License",@"Stand MiniNet 4",@"Substrate Bubbling",@"Substrate Loose",@"Substrate Tight",@"Sustrate Vibration",@"Sustrate Waves",@"SW Lock-up - Can reboot via GUI",@"SW Lock-up - System re-boot required",@"System Crash",@"System Freeze",@"Tax Issue",@"Temperature Fluctuations",@"Tight Substrate",@"Touchscreen Issue",@"Training",@"Training/docs/CDs needed",@"Undefined Classification",@"Uneven Print B/W Heads",@"Uneven Print W/In Head",@"Uneven Treatment",@"Upgrade",@"Using Program",@"VDP",@"WCC Issues",@"Web Break",@"Workstation",@"Wrong Customer ID",@"XFLOW",@"Jet Out - Recoverable - Transient",@"Jet Out - Recoverable - Stationary",@"Jet Out - Non Recoverable - Stationary",@"Misdirected nozzles",@"Filter(s) Clogged / Fill Errors",@"Color – Off Shade",@"Color – Density",@"Color - Fading",@"Poor Adhesion / Poor Cure",@"Jet Wetting",@"Print Quality - Fuzzy Print",@"Print Quality - Overspray",@"Print Quality - Fish Eyes",@"Print Quality - Cracking",@"Print Quality - Other", nil];
    
    [self showActionViewWithTitle:@"Select EscSymptoms"];
    [actionView setHidden:NO];

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
    UIWindow* window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [[[window subviews] objectAtIndex:0] addSubview:actionView];
    
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    
    if ([pickerTitle isEqualToString:@"Select EscStatus"]) {
        return [pickerStatusArray count];
    }
    if ([pickerTitle isEqualToString:@"Select EscType"]) {
        return [pickerTypeArray count];
    }
    if ([pickerTitle isEqualToString:@"Select EscSymptoms"]) {
        return [pickerSymptomsArray count];
    }

    return [pickerStatusArray count];
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([pickerTitle isEqualToString:@"Select EscStatus"]) {
        
        return [pickerStatusArray objectAtIndex:row];
        
    }
    if([pickerTitle isEqualToString:@"Select EscType"]) {
        
        return [pickerTypeArray objectAtIndex:row];
        
    }
    if([pickerTitle isEqualToString:@"Select EscSymptoms"]) {
        
        return [pickerSymptomsArray objectAtIndex:row];
        
    }

    return [pickerStatusArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if([pickerTitle isEqualToString:@"Select EscStatus"]) {
        
        [statusButton setTitle:[pickerStatusArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    if([pickerTitle isEqualToString:@"Select EscType"]) {
        
        [typeButton setTitle:[pickerTypeArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    if([pickerTitle isEqualToString:@"Select EscSymptoms"]) {
        
        [escalationSymptomsButton setTitle:[pickerSymptomsArray objectAtIndex:row] forState:UIControlStateNormal];
    }

}



-(void)pickerviewDonePressed:(UIPickerView *)pickeview
{
    [self.view setUserInteractionEnabled:YES];
    
    [actionView setHidden:YES];
    
}


-(void)pickerviewCancelPressed:(UIPickerView *)pickerview
{
    
    [self.view setUserInteractionEnabled:YES];
    
    [actionView setHidden:YES];
    
}



// Storing Salesforce Response in Local Database

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    [escalationNotFoundLabel setHidden:YES];

    records = nil;
    records = [jsonResponse objectForKey:@"records"];
    
    if (records.count > 0) {
        
        for (int i=0; i<records.count; i++) {
        
            success = [[DBManager getSharedInstance]saveEscalations:[[records objectAtIndex:i]objectForKey:@"Name"] escalationAccount:[[records objectAtIndex:i]objectForKey:@"Account__c"] escalationCase:[[records objectAtIndex:i]objectForKey:@"Case__c"] asset:[[records objectAtIndex:i]objectForKey:@"Asset__c"] installedProduct:[[records objectAtIndex:i]objectForKey:@"Installed_Product__c"] workOrder:[[records objectAtIndex:i]objectForKey:@"Work_Order__c"] site:[[records objectAtIndex:i]objectForKey:@"Site__c"] type:[[records objectAtIndex:i]objectForKey:@"Type__c"] escalationOwner:[[records objectAtIndex:i]objectForKey:@"Escalation_Owner__c"] partNumber:[[records objectAtIndex:i]objectForKey:@"Part_Number__c"] caseOwner:[[records objectAtIndex:i]objectForKey:@"Case_Owner__c"] status:[[records objectAtIndex:i]objectForKey:@"Status__c"] FSE:[[records objectAtIndex:i]objectForKey:@"FSE__c"] casePriority:[[records objectAtIndex:i]objectForKey:@"Case_Priority__c"] problemDescription:[[records objectAtIndex:i]objectForKey:@"Problem_Description__c"] escalationSymptoms:[[records objectAtIndex:i]objectForKey:@"Escalation_Symptoms__c"] endDate:[[records objectAtIndex:i]objectForKey:@"End_Date__c"] timeOpen:[[records objectAtIndex:i]objectForKey:@"Time_Open__c"] serialNumber:[[records objectAtIndex:i]objectForKey:@"Serial_Number__c"] escalationResolution:[[records objectAtIndex:i]objectForKey:@"Escalation_Resolution__c"]];
        
        }
    
        escalationsArray = [[DBManager getSharedInstance]getEscalations];
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            syncTimeLabel.text = appDelegate.myString;
        
       
        
        for (int i=0; i < escalationsArray.count; i++) {
            
            workOrderLabel.text = workOrderName;

            if (![[[escalationsArray objectAtIndex:i]objectForKey:@"Work_Order__c"] isEqualToString:@"<null>"]) {
     
                if ([workOrderId isEqualToString:[[escalationsArray objectAtIndex:i]objectForKey:@"Work_Order__c"]]) {
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Name"] isEqualToString:@"<null>"]) {
                        
                        escalationNameLabel.text = @"";
                        
                    } else {
                        
                        escalationNameLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Name"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Account__c"] isEqualToString:@"<null>"]) {
                        
                        accountLabel.text = @"";
                        
                    } else {
                        
                        accountLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Account__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Case__c"] isEqualToString:@"<null>"]) {
                        
                        caseLabel.text = @"";
                        
                    } else {
                        
                        caseLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Case__c"];
                        
                    }
                    
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Asset__c"] isEqualToString:@"<null>"]) {
                        
                        assetLabel.text = @"";
                        
                    } else {
                        
                        assetLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Asset__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"] isEqualToString:@"<null>"]) {
                        
                        installedProductLabel.text = @"";
                        
                    } else {
                        
                        installedProductLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"] isEqualToString:@"<null>"]) {
                        
                        installedProductLabel.text = @"";
                        
                    } else {
                        
                        installedProductLabel.text = [[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Site__c"] isEqualToString:@"<null>"]) {
                        
                        siteLabel.text = @"";
                        
                    } else {
                        
                        siteLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Site__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Type__c"] isEqualToString:@"<null>"]) {
                        
                        typeLabel.text = @"";
                        
                    } else {
                        
                        typeLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Type__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Owner__c"] isEqualToString:@"<null>"]) {
                        
                        escalationOwnerLabel.text = @"";
                        
                    } else {
                        
                        escalationOwnerLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Owner__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Part_Number__c"] isEqualToString:@"<null>"]) {
                        
                        partNumberLabel.text = @"";
                        
                    } else {
                        
                        partNumberLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Part_Number__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Owner__c"] isEqualToString:@"<null>"]) {
                        
                        caseOwnerLabel.text = @"";
                        
                    } else {
                        
                        caseOwnerLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Owner__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Status__c"] isEqualToString:@"<null>"]) {
                        
                        statusLabel.text = @"";
                        
                    } else {
                        
                        statusLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Status__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"FSE__c"] isEqualToString:@"<null>"]) {
                        
                        FSELabel.text = @"";
                        
                    } else {
                        
                        FSELabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"FSE__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Priority__c"] isEqualToString:@"<null>"]) {
                        
                        casePriorityLabel.text = @"";
                        
                    } else {
                        
                        casePriorityLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Priority__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Problem_Description__c"] isEqualToString:@"<null>"]) {
                        
                        problemDescriptionLabel.text = @"";
                        
                    } else {
                        
                        problemDescriptionLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Problem_Description__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Symptoms__c"] isEqualToString:@"<null>"]) {
                        
                        escalationSymptomsLabel.text = @"";
                        
                    } else {
                        
                        escalationSymptomsLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Symptoms__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"End_Date__c"] isEqualToString:@"<null>"]) {
                        
                        endDateLabel.text = @"";
                        
                    } else {
                        
                        endDateLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"End_Date__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Time_Open__c"] isEqualToString:@"<null>"]) {
                        
                        timeOpenLabel.text = @"";
                        
                    } else {
                        
                        timeOpenLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Time_Open__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
                        
                        serialNumberLabel.text = @"";
                        
                    } else {
                        
                        serialNumberLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Resolution__c"] isEqualToString:@"<null>"]) {
                        
                        escalationResolutionLabel.text = @"";
                        
                    } else {
                        
                        escalationResolutionLabel.text=[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Resolution__c"];
                        
                    }
                    
                    
                    
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Case__c"] isEqualToString:@"<null>"]) {
                        
                        caseField.text = @"";
                        
                    } else {
                        
                        caseField.text = [[escalationsArray objectAtIndex:i]objectForKey:@"Case__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Account__c"] isEqualToString:@"<null>"]) {
                        
                        accountField.text = @"";
                        
                    } else {
                        
                        accountField.text =[[escalationsArray objectAtIndex:i]objectForKey:@"Account__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Asset__c"] isEqualToString:@"<null>"]) {
                        
                        assetField.text = @"";
                        
                    } else {
                        
                        assetField.text =[[escalationsArray objectAtIndex:i]objectForKey:@"Asset__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"] isEqualToString:@"<null>"]) {
                        
                        installedProductField.text = @"";
                        
                    } else {
                        
                        installedProductField.text = [[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Priority__c"] isEqualToString:@"<null>"]) {
                        
                        casePriorityField.text = @"";
                        
                    } else {
                        
                        casePriorityField.text = [[escalationsArray objectAtIndex:i]objectForKey:@"Case_Priority__c"];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Owner__c"] isEqualToString:@"<null>"]) {
                        
                        caseOwnerField.text = @"";
                        
                    } else {
                        
                        caseOwnerField.text = [[escalationsArray objectAtIndex:i]objectForKey:@"Case_Owner__c"];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Status__c"] isEqualToString:@"<null>"]) {
                        
                        [statusButton setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [statusButton setTitle:[[escalationsArray objectAtIndex:i]objectForKey:@"Status__c"] forState:UIControlStateNormal];
                        
                    }
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Type__c"] isEqualToString:@"<null>"]) {
                        
                        [typeButton setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [typeButton setTitle:[[escalationsArray objectAtIndex:i]objectForKey:@"Type__c"] forState:UIControlStateNormal];
                        
                    }
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Problem_Description__c"] isEqualToString:@"<null>"]) {
                        
                        problemDescriptionField.text = @"";
                        
                    } else {
                        
                        problemDescriptionField.text = [[escalationsArray objectAtIndex:i]objectForKey:@"Problem_Description__c"];
                        
                    }
                    
                    
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Symptoms__c"] isEqualToString:@"<null>"]) {
                        
                        [escalationSymptomsButton setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [escalationSymptomsButton setTitle:[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Symptoms__c"] forState:UIControlStateNormal];
                        
                    }
                    
                    [escalationsTableView reloadData];

                    return ;
                    
                } else {
                    if ([[[escalationsArray objectAtIndex:i]objectForKey:@"Work_Order__c"] isEqualToString:@"<null>"]) {
                        
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No Escalations" message:@"No Escalations Available to Display" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                        
                        
                        return;
                        
                    }
                    
                }
                
            }
            
        }
        
    });

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == leftMenuTableView) {
        return [tableDataArray count];
    }
    if(tableView == escalationsTableView) {
        
        WOEscalationsArray = [[NSMutableArray alloc]init];
        escalationCount = 0;

        if (escalationsArray.count > 0) {

        for (int i=0; i<escalationsArray.count; i++) {
            
            if ([workOrderId isEqualToString:[[escalationsArray objectAtIndex:i]objectForKey:@"Work_Order__c"]]) {
                
               
                NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Name"] forKey:@"Name"];

                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Account__c"] forKey:@"Account__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Case__c"] forKey:@"Case__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Asset__c"] forKey:@"Asset__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Installed_Product__c"] forKey:@"Installed_Product__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Work_Order__c"] forKey:@"Work_Order__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Site__c"] forKey:@"Site__c"];
              
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Type__c"] forKey:@"Type__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Owner__c"] forKey:@"Escalation_Owner__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Part_Number__c"] forKey:@"Part_Number__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Owner__c"] forKey:@"Case_Owner__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Status__c"] forKey:@"Status__c"];

                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"FSE__c"] forKey:@"FSE__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Case_Priority__c"] forKey:@"Case_Priority__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Problem_Description__c"] forKey:@"Problem_Description__c"];
                
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Symptoms__c"] forKey:@"Escalation_Symptoms__c"];
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"End_Date__c"] forKey:@"End_Date__c"];
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Time_Open__c"] forKey:@"Time_Open__c"];
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Serial_Number__c"] forKey:@"Serial_Number__c"];
                [dataDict setObject:[[escalationsArray objectAtIndex:i]objectForKey:@"Escalation_Resolution__c"] forKey:@"Escalation_Resolution__c"];
                
                [WOEscalationsArray addObject:dataDict];

                escalationCount++;
           
            
                }
            
            }
    
        }
        
        
        if (WOEscalationsArray.count>0)
        {
            [escalationNotFoundLabel setHidden:YES];

            [backgroundScrollView setHidden:NO];
            [escalationsTableView setHidden:NO];
        }
        else if(WOEscalationsArray.count==0)
        {
            [escalationNotFoundLabel setHidden:NO];
            [backgroundScrollView setHidden:YES];
            [escalationsTableView setHidden:YES];
            //  [newEscalationScrollview setHidden:NO];
        }
        


        return escalationCount;
    }
    
    return 1;
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cell.contentView.frame.size.width,cell.contentView.frame.size.height)];
    
//    imageView.image=[UIImage imageNamed:@"selected_inv.png"];

    [cell.contentView addSubview:imageView];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 120, 30)];
    nameLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:nameLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor blackColor];
   
    if (tableView == leftMenuTableView) {
        
        nameLabel.text = [tableDataArray objectAtIndex:indexPath.row];
    }

    if (tableView == escalationsTableView) {
        
        if (WOEscalationsArray.count >0 ) {
           
//            NSDictionary * escDict  = [WOEscalationsArray objectAtIndex:indexPath.row];
            
            nameLabel.text = [[WOEscalationsArray objectAtIndex:indexPath.row]objectForKey:@"Name"];

        }
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == leftMenuTableView) {
        
        if (indexPath.row == 0) {
            
            
            [self.navigationController pushViewController:serviceOrderView animated:YES];
            
            
        }
        if (indexPath.row == 1) {
            
            [self.navigationController pushViewController:installedProductsView animated:YES];

            
        }
        if (indexPath.row == 2) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Logout ?"
                                                                message:nil delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Yes",@"No",nil];
            [alertView show];
            
            
        }
        
    }
    
    if (tableView == escalationsTableView) {
        
        selectedRow = (int)indexPath.row;
        [self serviceOrdersRowClicked];

    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == escalationsTableView) {
        cell.selectedBackgroundView = [[UIImageView alloc] init];
        UIImage *img  = [UIImage imageNamed:@"selected_inv.png"];
        ((UIImageView *)cell.selectedBackgroundView).image = img;
    }
}

-(void)serviceOrdersRowClicked {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        workOrderLabel.text = workOrderName;

//        for (int j=0; j<escalationsArray.count; j++) {
//            
//            if (![[[escalationsArray objectAtIndex:j]objectForKey:@"Work_Order__c"] isEqualToString:@"<null>"]) {
//                
//                if ([workOrderId isEqualToString:[[escalationsArray objectAtIndex:j]objectForKey:@"Work_Order__c"]]) {

        
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Name"] isEqualToString:@"<null>"]) {
                        
                        escalationNameLabel.text = @"";
                        
                    } else {
                        
                        escalationNameLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Name"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Account__c"] isEqualToString:@"<null>"]) {
                        
                        accountLabel.text = @"";
                        
                    } else {
                        
                        accountLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Account__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case__c"] isEqualToString:@"<null>"]) {
                        
                        caseLabel.text = @"";
                        
                    } else {
                        
                        caseLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case__c"];
                        
                    }
                    
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"] isEqualToString:@"<null>"]) {
                        
                        assetLabel.text = @"";
                        
                    } else {
                        
                        assetLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Installed_Product__c"] isEqualToString:@"<null>"]) {
                        
                        installedProductLabel.text = @"";
                        
                    } else {
                        
                        installedProductLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Installed_Product__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Installed_Product__c"] isEqualToString:@"<null>"]) {
                        
                        installedProductLabel.text = @"";
                        
                    } else {
                        
                        installedProductLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Installed_Product__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Site__c"] isEqualToString:@"<null>"]) {
                        
                        siteLabel.text = @"";
                        
                    } else {
                        
                        siteLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Site__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Type__c"] isEqualToString:@"<null>"]) {
                        
                        typeLabel.text = @"";
                        
                    } else {
                        
                        typeLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Type__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Owner__c"] isEqualToString:@"<null>"]) {
                        
                        escalationOwnerLabel.text = @"";
                        
                    } else {
                        
                        escalationOwnerLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Owner__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Part_Number__c"] isEqualToString:@"<null>"]) {
                        
                        partNumberLabel.text = @"";
                        
                    } else {
                        
                        partNumberLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Part_Number__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Owner__c"] isEqualToString:@"<null>"]) {
                        
                        caseOwnerLabel.text = @"";
                        
                    } else {
                        
                        caseOwnerLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Owner__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Status__c"] isEqualToString:@"<null>"]) {
                        
                        statusLabel.text = @"";
                        
                    } else {
                        
                        statusLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Status__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"FSE__c"] isEqualToString:@"<null>"]) {
                        
                        FSELabel.text = @"";
                        
                    } else {
                        
                        FSELabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"FSE__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Priority__c"] isEqualToString:@"<null>"]) {
                        
                        casePriorityLabel.text = @"";
                        
                    } else {
                        
                        casePriorityLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Priority__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Problem_Description__c"] isEqualToString:@"<null>"]) {
                        
                        problemDescriptionLabel.text = @"";
                        
                    } else {
                        
                        problemDescriptionLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Problem_Description__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Symptoms__c"] isEqualToString:@"<null>"]) {
                        
                        escalationSymptomsLabel.text = @"";
                        
                    } else {
                        
                        escalationSymptomsLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Symptoms__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"End_Date__c"] isEqualToString:@"<null>"]) {
                        
                        endDateLabel.text = @"";
                        
                    } else {
                        
                        endDateLabel.text=[[escalationsArray objectAtIndex:selectedRow]objectForKey:@"End_Date__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Time_Open__c"] isEqualToString:@"<null>"]) {
                        
                        timeOpenLabel.text = @"";
                        
                    } else {
                        
                        timeOpenLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Time_Open__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"] isEqualToString:@"<null>"]) {
                        
                        serialNumberLabel.text = @"";
                        
                    } else {
                        
                        serialNumberLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Serial_Number__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Resolution__c"] isEqualToString:@"<null>"]) {
                        
                        escalationResolutionLabel.text = @"";
                        
                    } else {
                        
                        escalationResolutionLabel.text=[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Resolution__c"];
                        
                    }
                    
                    
                    
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case__c"] isEqualToString:@"<null>"]) {
                        
                        caseField.text = @"";
                        
                    } else {
                        
                        caseField.text = [[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Account__c"] isEqualToString:@"<null>"]) {
                        
                        accountField.text = @"";
                        
                    } else {
                        
                        accountField.text =[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Account__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"] isEqualToString:@"<null>"]) {
                        
                        assetField.text = @"";
                        
                    } else {
                        
                        assetField.text =[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Asset__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Installed_Product__c"] isEqualToString:@"<null>"]) {
                        
                        installedProductField.text = @"";
                        
                    } else {
                        
                        installedProductField.text = [[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Installed_Product__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Priority__c"] isEqualToString:@"<null>"]) {
                        
                        casePriorityField.text = @"";
                        
                    } else {
                        
                        casePriorityField.text = [[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Priority__c"];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Owner__c"] isEqualToString:@"<null>"]) {
                        
                        caseOwnerField.text = @"";
                        
                    } else {
                        
                        caseOwnerField.text = [[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Case_Owner__c"];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Status__c"] isEqualToString:@"<null>"]) {
                        
                        [statusButton setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [statusButton setTitle:[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Status__c"] forState:UIControlStateNormal];
                        
                    }
                    
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Type__c"] isEqualToString:@"<null>"]) {
                        
                        [typeButton setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [typeButton setTitle:[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Type__c"] forState:UIControlStateNormal];
                        
                    }
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Problem_Description__c"] isEqualToString:@"<null>"]) {
                        
                        problemDescriptionField.text = @"";
                        
                    } else {
                        
                        problemDescriptionField.text = [[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Problem_Description__c"];
                        
                    }
                    
        
                    if ([[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Symptoms__c"] isEqualToString:@"<null>"]) {
                        
                        [escalationSymptomsButton setTitle:@"" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [escalationSymptomsButton setTitle:[[WOEscalationsArray objectAtIndex:selectedRow]objectForKey:@"Escalation_Symptoms__c"] forState:UIControlStateNormal];
                        
                    }
                    
                        return;
                    
//            }
//        }
    
    });

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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
