//
//  ServiceOrdersViewController.h
//  FS360newPartsUsedBtnAction
//
//  Created by BiznusSoft on 7/31/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "ASActionView.h"
#import "MBProgressHUD.h"

#import "EscalationsViewController.h"
#import "InstalledProductsViewController.h"
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"

#import "LeftPanelViewController.h"
#import "FSAddPartView.h"
#import "FSAddNewPartView.h"


@class EscalationsViewController,InstalledProductsViewController,SignatureViewController;

@interface ServiceOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SFRestDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIActionSheetDelegate,FSAddPartViewDelegate>

{
    
    
    NSString * userId;

    IBOutlet MKMapView *WOMapView;
    
    IBOutlet UITableView *leftMenuTableView;
    
    IBOutlet UITableView *serviceTableView;
    
    IBOutlet UITableView *activitiesTableView;
    
    IBOutlet UITableView *timeAndExpensesTableView;
    
    IBOutlet UITableView *partsUsedTableView;
    
    IBOutlet UITableView *orderProductsTableView;
    
    
    IBOutlet UIButton *newOrderButton;
    
    IBOutlet UIButton *newServiceResultsBtn;
    
    BOOL _isActivitiesTableViewCellExpanded;
    
    BOOL _isShowingMenu;
    BOOL _isPushing;
    BOOL _isGettingData;


    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIScrollView *backgroundScrollView;
    
    
    
    IBOutlet UIView *signatureBackgroundView;
    
    IBOutlet UIImageView *signatureBackgroundImageView;
    
    
    
    IBOutlet UIView *timeIntervalView;
    
    IBOutlet UIButton *timeIntervalBtn;
    
    
    NSMutableArray * WOActivitiesArray;
    NSMutableArray * WOOrderProductsArray;
    NSMutableArray * WOOrderArray;
    NSMutableArray * WORMAArray;

    NSMutableArray * WOTimeArray;
    
    NSMutableArray * WOServiceResultsArray;

    NSMutableArray * WOPartsUsedArray;

    NSMutableArray * tableDataArray;
    
    NSMutableArray * technicianIdArray;
    NSMutableArray * serviceOrdersArray;
    NSMutableArray * activitiesArray;
    NSMutableArray * orderProductsArray;
    NSMutableArray * orderArray;
    NSMutableArray * assignedTechnicianArray;
    NSMutableArray * RMAArray;
    NSMutableArray * serviceResultsArray;
    NSMutableArray * otherPartsUsedArray;
    NSMutableArray * pricebookEntryArray;
    NSMutableArray * timeArray;
    NSMutableArray * attachmentsArray;

    NSMutableArray * expensesArray;
    

    //Service Orders
    
    
    IBOutlet UIScrollView *serviceOrderScrollView;
    
    IBOutlet UIView *serviceOrdersInformationView;
    
    IBOutlet UIButton *caseInformationButton;
    
    IBOutlet UIButton *addressInformationButton;
    
    IBOutlet UIView *caseInformationView;
    
    IBOutlet UIView *addressInformationView;
    
    IBOutlet UIScrollView *caseInfoScrollView;
    
    IBOutlet UIView *buttonsView;
    
    // Case Information

    IBOutlet UILabel *orderIdLabel;
    
    IBOutlet UILabel *workOrderStatusLabel;
    
    IBOutlet UILabel *caseLabel;
    
    IBOutlet UILabel *caseOwnerLabel;
    
    IBOutlet UILabel *workOrderPriorityLabel;
    
    IBOutlet UILabel *accountLabel;
    
    IBOutlet UILabel *regionalCoordinatorLabel;
    
    IBOutlet UILabel *installedProductsLabel;
    
    IBOutlet UILabel *symptomLabel;
    
    IBOutlet UILabel *serialNumberLabel;
    
    IBOutlet UILabel *subjectLabel;
    
    IBOutlet UILabel *severityLabel;
    
    IBOutlet UILabel *productLabel;
    
    IBOutlet UILabel *descriptionLabel;
    
    IBOutlet UILabel *modelItemLabel;
    
    IBOutlet UILabel *contactNameLabel;
    
    IBOutlet UILabel *contactPhoneLabel;
    
    IBOutlet UILabel *contactEmailLabel;
    IBOutlet UILabel *billableLabel;

    
    // Address Information
    
    IBOutlet UILabel *primaryAddressLabel;
    
    IBOutlet UILabel *sapBillToAddressLabel;
    
    IBOutlet UILabel *subRegionLabel;
    
    IBOutlet UILabel *latittudeLabel;
    
    IBOutlet UILabel *longitudeLabel;
    
    IBOutlet UILabel *timeLabel;
    
    IBOutlet UIView *startTravelView;
    
    IBOutlet UIButton *serviceButton;
    
    IBOutlet UIButton *travelButton;
    
    
    // Close Work Order
    
    IBOutlet UIScrollView *closeWorkOrderScrollView;
    
    IBOutlet UIView *closeWorkOrderView;
    
    
    IBOutlet UITextField *closeWOSubjectField;
    
    IBOutlet UITextField *closeWOProblemDescriptionField;
        
    
    
    IBOutlet UIButton *closeWOProductButton;
    IBOutlet UIButton *closeWOActionTakenButton;
    
    IBOutlet UIButton *closeWOModelButton;
    IBOutlet UIButton *closeWOSymptomButton;
    
    IBOutlet UIButton *expensesOver;
    IBOutlet UIButton *areaUnits;
    
    IBOutlet UITextField *areaPrinted;
    IBOutlet UITextField *inkUsage;
    IBOutlet UITextField *printerTime;
    
    
    IBOutlet UIButton *closeWOInfoButton;
    IBOutlet UIButton *closeWOClosureInfoButton;
    IBOutlet UIButton *closeWOBillableInfoButton;
    IBOutlet UIButton *closeWOPrinterInfoButton;
    
    IBOutlet UIView *closeWOInfoView;
    IBOutlet UIView *closeWoClosureView;
    IBOutlet UIView *closeWoBillableView;
    IBOutlet UIView *closeWOPrinterInfoView;
    
// Service Results Details

    IBOutlet UIView *serviceResultsInformationView;
    
    IBOutlet UILabel *serviceResultsWorkOrderLabel;
    
    IBOutlet UILabel *serviceResultsNameLabel;
    
    IBOutlet UILabel *serviceResultsProductLabel;
    
    IBOutlet UILabel *serviceResultsOrderActivityLabel;
    IBOutlet UILabel *serviceResultsSubSystemsLabel;
    IBOutlet UILabel *serviceResultsDurationLabel;
    IBOutlet UILabel *serviceResultsSymptomsLabel;
    IBOutlet UILabel *serviceResultsSystemLabel;
    IBOutlet UILabel *serviceResultsActionTakenLabel;
    IBOutlet UILabel *serviceResultsRootCauseLabel;
    IBOutlet UILabel *serviceResultsDetailsLabel;

    
    
 // New Service Results Details
    
    IBOutlet UIView *newServiceResultsView;
    
    IBOutlet UIScrollView *newServiceResultsScrollView;
    
    
    IBOutlet UILabel *newServiceResultsWorkOrderLabel;
    
    IBOutlet UILabel *newServiceResultsOrderActivityLabel;
    IBOutlet UIButton *newServiceResultsProductButton;
    IBOutlet UIButton *newServiceResultsSubSystems;
    
    IBOutlet UITextField *newServiceResultsDurationField;
    IBOutlet UIButton *newServiceResultsSymptomsButton;
    
    IBOutlet UIButton *newServiceResultsSystemButton;
    
    IBOutlet UIButton *newServiceResultsActionTakenButton;
    
    IBOutlet UIButton *newServiceResultsRootCauseButton;
    
    IBOutlet UITextField *newServiceResultsDetailsField;
    

    
    // Orders
    
    
    IBOutlet UIView *newOrderView;
    
    IBOutlet UILabel *newOrderWOLabel;
    
    IBOutlet UIButton *newOrderPriorityButton;
    
    IBOutlet UIButton *newOrderShippingMethodButton;
    
    IBOutlet UIButton *newOrderPrinterCheckBoxButton;
    
    IBOutlet UITextField *newOrderDescriptionField;
    
    
    // Add Products
    
    IBOutlet UIScrollView *addProductsBackgroundScrollView;
    
    
    IBOutlet UIButton *addProductButton;
    
    IBOutlet UIView *addProductView;
    
    IBOutlet UILabel *addProductWOLabel;
    
    
    //New Parts Used Service Results
    
    
    IBOutlet UIView *newPartsUsedView;
    
    
    
    IBOutlet UILabel *subResultsOrderLabel;
    
    
    IBOutlet UIScrollView *newPartsUsedBackgroundScrollView;
    
    // Order Products
    
    
    IBOutlet UIView *orderProductsView;
    
    // Parts Used Details
    
    
    IBOutlet UILabel *addProductForOrderPartNumberLabel;
    
    IBOutlet UITableView *addProductPartNumberTableView;

    
    
    IBOutlet UIView *partsUsedView;
    
    
  // New Parts Used for Service Results
    
    
    IBOutlet UITableView *newPartsTableView;
    
    
    UIPickerView *activityNameSelectPickerView;
    NSMutableArray *pickerActionTakenArray;
    NSMutableArray *pickerProductArray;
    NSMutableArray *pickerModelArray;
    NSMutableArray *pickerSymptomArray;
    NSMutableArray *pickerAreaUnitsArray;
    
    
    NSMutableArray *pickerNewOrderPriorityArray;
    NSMutableArray *pickerNewOrderShippingMethodArray;

    
    NSMutableArray * pickerNewServiceResultsProductArray;
    NSMutableArray * pickerNewServiceResultsSystemsArray;
    NSMutableArray * pickerNewServiceResultsSubSystemArray;
    NSMutableArray * pickerNewServiceResultsRootCauseArray;
    NSMutableArray * pickerNewServiceResultsSymptomsArray;
    NSMutableArray * pickerNewServiceResultsActionTakenArray;


    ASActionView * actionView;
    NSString *pickerTitle;

    int currentActivityNameRow, currentPriorityRow;
    
    
    NSArray *filteredArray;
    
    NSInteger partsTag;
}

@property(assign)NSIndexPath * selectedIndexPath;//<- To track Activity Table Expand/Colaps

@property (strong, nonatomic) IBOutlet UIImageView *captureImageView;
@property (strong, nonatomic) IBOutlet UIImageView *captureSignatureView;


@property (strong, nonatomic) IBOutlet UIButton *activitiesButton;
@property (strong, nonatomic) IBOutlet UIButton *ordersButton;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@property (strong, nonatomic) IBOutlet UISegmentedControl *timeAndServiceResultsSegmentControl;


@property (strong, nonatomic) FSAddPartView *addParts;
@property (strong, nonatomic) FSAddNewPartView *addNewParts;

//- (IBAction)newServiceOrderBtnAction:(id)sender;

- (IBAction)activitiesBtnAction:(id)sender;
- (IBAction)ordersBtnAction:(id)sender;
- (IBAction)timeIntervalBtnAction:(id)sender;
- (IBAction)setTimeIntervalBtnAction:(id)sender;
- (IBAction)closeWorkOrderBtnAction:(id)sender;
- (IBAction)installedProductBtnAction:(id)sender;
- (IBAction)escalationsBtnAction:(id)sender;
- (IBAction)getDirectionsBtnAction:(id)sender;
- (IBAction)capturePhotoBtnAction:(id)sender;
- (IBAction)captureSignatureBtnAction:(id)sender;
- (IBAction)segmentedControlIndexChanged:(id)sender;
- (IBAction)timeAndServiceResultsSegmentControlIndexChanged:(id)sender;
- (IBAction)caseInformationBtnAction:(id)sender;
- (IBAction)addressInformationBtnAction:(id)sender;
- (IBAction)closeWOProductBtnAction:(id)sender;
- (IBAction)closeWOActionTakenBtnAction:(id)sender;
- (IBAction)closeWOModelBtnAction:(id)sender;
- (IBAction)closeWOSymptomBtnAction:(id)sender;
- (IBAction)closeWOAreaUnitsBtnAction:(id)sender;
- (IBAction)expensesOverCheckBoxBtnAction:(id)sender;
- (IBAction)closeWOSaveBtnAction:(id)sender;
- (IBAction)closeWOCancelBtnAction:(id)sender;
- (IBAction)closeWOInfoBtnAction:(id)sender;
- (IBAction)closeWOClosureInfoBtnAction:(id)sender;
- (IBAction)closeWOBillableInfoBtnAction:(id)sender;
- (IBAction)closeWOPrinterInfoBtnAction:(id)sender;
- (IBAction)serviceBtnAction:(id)sender;
- (IBAction)travelBtnAction:(id)sender;
- (IBAction)serviceIconBtnAction:(id)sender;
- (IBAction)travelIconBtnAction:(id)sender;
- (IBAction)startTravelCloseBtnAction:(id)sender;
- (IBAction)saveSignatureBtnAction:(id)sender;
- (IBAction)cancelSignatureBtnAction:(id)sender;
- (IBAction)clearSignatureBtnAction:(id)sender;
- (IBAction)newServiceResultsBtnAction:(id)sender;
- (IBAction)newServiceResultsSaveBtnAction:(id)sender;
- (IBAction)newServiceResultsCancelBtnAction:(id)sender;
- (IBAction)newServiceResultsProductBtnAction:(id)sender;
- (IBAction)newServiceResultsSubSystemsBtnAction:(id)sender;
- (IBAction)newServiceResultsSystemBtnAction:(id)sender;

- (IBAction)newServiceResultsSymptomsBtnAction:(id)sender;

- (IBAction)newServiceResultsActionTakenBtnAction:(id)sender;


- (IBAction)newServiceResultsRootCauseBtnAction:(id)sender;
- (IBAction)serviceResultsInformationCancelBtnAction:(id)sender;

- (IBAction)serviceResultsInformationEditBtnAction:(id)sender;

- (IBAction)newPartsUsedBtnAction:(id)sender;
- (IBAction)newOrderBtnAction:(id)sender;
- (IBAction)newOrderCloseBtnAction:(id)sender;
- (IBAction)newOrderPriorityBtnAction:(id)sender;
- (IBAction)newOrderShippingMethodBtnAction:(id)sender;
- (IBAction)newOrderPrinterCheckBoxBtnAction:(id)sender;
- (IBAction)newOrderSubmitBtnAction:(id)sender;
- (IBAction)addProductBtnAction:(id)sender;
- (IBAction)addPartProductButtonAction:(id)sender;
- (IBAction)submitProductButtonAction:(id)sender;
- (IBAction)cancelNewPartsButtonAction:(id)sender;
- (IBAction)addPartServiceResultsBtnAction:(id)sender;
- (IBAction)addPartServiceResultsSubmitBtnAction:(id)sender;


@property (nonatomic, retain) UIPickerView *activityNameSelectPickerView;
@property (nonatomic, retain)  NSArray *pickerActionTakenArray;
@property (nonatomic, retain)  NSArray *pickerProductArray;
@property (nonatomic, retain)  NSArray *pickerModelArray;
@property (nonatomic, retain)  NSArray *pickerSymptomArray;
@property (nonatomic, retain)  NSArray *pickerAreaUnitsArray;

@property (nonatomic, retain) NSArray * pickerNewServiceResultsProductArray;
@property (nonatomic, retain) NSArray * pickerNewServiceResultsSystemsArray;
@property (nonatomic, retain) NSArray * pickerNewServiceResultsSubSystemArray;
@property (nonatomic, retain) NSArray * pickerNewServiceResultsRootCauseArray;
@property (nonatomic, retain) NSArray * pickerNewServiceResultsSymptomsArray;
@property (nonatomic, retain) NSArray * pickerNewServiceResultsActionTakenArray;

@property (nonatomic, retain) NSArray *pickerNewOrderPriorityArray;
@property (nonatomic, retain) NSArray *pickerNewOrderShippingMethodArray;


@property (nonatomic, strong) NSString * userId;

@property(nonatomic,assign)BOOL _isShowingMenu;

@property(nonatomic,assign)BOOL _isPushing;

@property(nonatomic,assign)BOOL _isGettingData;

@property (nonatomic, assign) CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL fingerMoved;
@property (nonatomic, assign) float navbarHeight;


@end
