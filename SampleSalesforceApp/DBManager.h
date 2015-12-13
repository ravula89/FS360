//
//  DBManager.h
//  MyNativeiOSApp
//
//  Created by Atif Mohammed on 7/15/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
    
}

+(DBManager*)getSharedInstance;

-(BOOL)createDB;

// Save TechnicianId

//-(BOOL)saveTechnicianId:(NSString *)technicianId;
//
//-(NSMutableArray *)getTechnicianDetails;
//
//-(void)deleteTechnicianDetails;


//Service Orders

- (BOOL) saveData:(NSString *)techId name:(NSString *)name technician:(NSString *)technician accountName:(NSString *)accountName accountId:(NSString *)accountId contactName:(NSString *)contactName phone:(NSString *)phone email:(NSString *)email address:(NSString *)address priority:(NSString *)priority status:(NSString *)status caseId:(NSString *)caseId caseName:(NSString *)caseName billable:(NSString *)billable caseOwner:(NSString *)caseOwner workOrderPriority:(NSString *)workOrderPriority regionalCoordinator:(NSString *) regionalCoordinator installedProductsId:(NSString *)installedProductsId installedProducts:(NSString *)installedProducts symptom:(NSString *)symptom serialNumber:(NSString *)serialNumber sybject:(NSString *)subject problemDescription:(NSString *)problemDescription severity:(NSString *)severity product:(NSString *)product description:(NSString *)description modelItem:(NSString *)modelItem serviceType:(NSString *)serviceType sapSlodToBillToAccount:(NSString *)sapSlodToBillToAccount actionTaken:(NSString *)actionTaken primaryAddress:(NSString *)primaryAddress sapBillToAddress:(NSString *)sapBillToAddress subRegion:(NSString *)subRegion latittude:(NSString *)latittude longitude:(NSString *)longitude expensesOver50:(NSString *)expensesOver50 areaPrinted:(NSString *)areaPrinted areaUnits:(NSString *)areaUnits inkUsage:(NSString *)inkUsage printTime:(NSString *)printTime assetDel:(NSString *)assetDel contactId:(NSString *)contactId;

-(NSMutableArray *)readInformationFromDatabase;

-(void)executeQuery;

//Activities

- (BOOL) saveActivities:(NSString *)activity activityId:(NSString *)activityId actvityName:(NSString *)actvityName activityStartDate:(NSString *)activityStartDate actvityEndDate:(NSString *)activityEndDate activityBillable:(NSString *)activityBillable activityPriority:(NSString *)activityPriority serviceOrderId:(NSString *)serviceOrderId;

-(NSMutableArray *)getActivities;

-(void)deleteActivitiesDB;


//Reqired Meterials

- (BOOL)saveOrderProductsId:(NSString *)orderProductsId orderId:(NSString *)orderId materialPartNumber:(NSString *)materialPartNumber partName:(NSString *)partName unUsedQuantity:(NSString *)unUsedQuantity usedQuantity:(NSString *)usedQuantity workOrderId:(NSString *)workOrderId pricebookEntryId:(NSString *)pricebookEntryId quantity:(NSString *)quantity unitPrice:(NSString *)unitPrice;

-(NSMutableArray *)getOrderProducts;

-(void)deleteOrderProductsDB;


// Service Results Data

- (BOOL)saveServiceResultsId:(NSString *)serviceResultsId name:(NSString *)name orderActivity:(NSString *)orderActivity rootCause:(NSString *)rootCause subSystems:(NSString *)subSystems symptoms:(NSString *)symptoms system:(NSString *)system actionTaken:(NSString *)actionTaken details:(NSString *)details createdDate:(NSString *)createdDate duration:(NSString *)duration;

-(NSMutableArray *)getServiceResultsDetails;

-(void)deleteServiceResultsDB;

// Other Parts Used Data

- (BOOL)saveOtherPartsId:(NSString *)otherPartsId partNumber:(NSString *)partNumber workOrder:(NSString *)workOrder serviceResults:(NSString *)serviceResults product:(NSString *)product quantity:(NSString *)quantity source:(NSString *)source;

-(NSMutableArray *)getOtherPartsUsedDetails;

-(void)deleteOtherPartsUsedDB;

// Assigned Technician Details

- (BOOL)saveAssignedTechnicianId:(NSString *)assignedTechnicianId technicianId:(NSString *)technicianId FSUserId:(NSString *)FSUserId name:(NSString *)name estimatedStartDate:(NSString *)estimatedStartDate estimatedEndDate:(NSString *)estimatedEndDate;

-(NSMutableArray *)getAssignedTechnicianDetails;

-(void)deleteAssignedTechnicianDB;



// Order

- (BOOL)saveOrderId:(NSString *)orderId caseId:(NSString *)caseId assetDel:(NSString *)assetDel description:(NSString *)description effectiveDate:(NSString *)effectiveDate errorMessage:(NSString *)errorMessage accountId:(NSString *)accountId workOrderId:(NSString *)workOrderId status:(NSString *)status shippingMethod:(NSString *)shippingMethod shipToContactId:(NSString *)shipToContactId sendtoSAP:(NSString *)sendtoSAP priority:(NSString *)priority printerDown:(NSString *)printerDown orderNumber:(NSString *)orderNumber pricebook2Id:(NSString *)pricebook2Id;
-(NSMutableArray *)getOrderDetails;

-(void)deleteOrderDB;


// PricebookEntryData

- (BOOL)savePricebookEntryId:(NSString *)pricebookEntryId materialPartNumber:(NSString *)materialPartNumber pricebook2Id:(NSString *)pricebook2Id product2Id:(NSString *)product2Id productCode:(NSString *)productCode productName:(NSString *)productName;

-(NSMutableArray *)getPricebookEntryDetails;

-(void)deletePricebookEntryDB;

// RMA

- (BOOL)saveRMAId:(NSString *)RMAId orderProductId:(NSString *)orderProductId partNumber:(NSString *)partNumber quantity:(NSString *)quantity RMARequired:(NSString *)RMARequired RMATrakingNumber:(NSString *)RMATrakingNumber workOrderId:(NSString *)workOrderId description:(NSString *)description;

-(NSMutableArray *)getRMADetails;

-(void)deleteRMADB;



//Time

- (BOOL) saveTime:(NSString *)timeId name:(NSString *)name timeActivity:(NSString *)timeActivity timeStartDate:(NSString *)timeStartDate timeEndDate:(NSString *)timeEndDate timeDuration:(NSString *)timeDuration comments:(NSString *)comments type:(NSString *)type;

-(NSMutableArray *)getTime;

-(void)deletegetTimeDB;


//// Escalations
//
- (BOOL) saveEscalations:(NSString *)escalationName escalationAccount:(NSString *)escalationAccount escalationCase:(NSString *)escalationCase asset:(NSString *)asset installedProduct:(NSString *)installedProduct workOrder:(NSString *)workOrder site:(NSString *)site type:(NSString *)type escalationOwner:(NSString *)escalationOwner partNumber:(NSString *)partNumber caseOwner:(NSString *)caseOwner status:(NSString *)status FSE:(NSString *)FSE casePriority:(NSString *)casePriority problemDescription:(NSString *)problemDescription escalationSymptoms:(NSString *)escalationSymptoms endDate:(NSString *)endDate timeOpen:(NSString *)timeOpen serialNumber:(NSString *)serialNumber escalationResolution:(NSString *)escalationResolution;

-(NSMutableArray *)getEscalations;

-(void)deleteEscationsDB;

// Attachments

- (BOOL) saveAttachments:(NSString *)serviceOrderId Body:(NSString *)Body Name:(NSString *)Name;

-(NSMutableArray *)getAttachments;

-(void)deleteAttachmentsDB;

//Installed Products

- (BOOL) saveInstalledProucts:(NSString *)installedProductId name:(NSString *)name serialNumber:(NSString *)serialNumber customerName:(NSString *)customerName customer:(NSString *)customer contact:(NSString *)contact assetUniqueField:(NSString *)assetUniqueField assetName:(NSString *)assetName itemId:(NSString *)itemId latittude:(NSString *)latittude longitude:(NSString *)longitude;

-(NSMutableArray *)getInstalledProducts;

-(void)deleteInstalledProductsDB;


//Installed Mod

- (BOOL) saveInstalledMod:(NSString *)installedModId name:(NSString *)name installedProducts:(NSString *)installedProducts install:(NSString *)install installedDate:(NSString *)installedDate modRequired:(NSString *)modRequired modName:(NSString *)modName existingMod:(NSString *)existingMod modNumber:(NSString *)modNumber docTitle:(NSString *)docTitle;

-(NSMutableArray *)getInstalledMods;

-(void)deleteInstalledModDB;


//Available Mod

- (BOOL) saveAvailableMod:(NSString *)availableModId name:(NSString *)name installedProducts:(NSString *)installedProducts install:(NSString *)install installedDate:(NSString *)installedDate modRequired:(NSString *)modRequired modName:(NSString *)modName existingMod:(NSString *)existingMod modNumber:(NSString *)modNumber docTitle:(NSString *)docTitle;

-(NSMutableArray *)getAvailableMods;

-(void)deleteAvailableModDB;


//Expenses

//- (BOOL) saveExpenses:(NSString *)timeId name:(NSString *)name timeActivity:(NSString *)timeActivity timeStartDate:(NSString *)timeStartDate timeEndDate:(NSString *)timeEndDate comments:(NSString *)comments type:(NSString *)type;
//
//-(NSMutableArray *)getExpenses;
//
//-(void)deletegetExpensesDB;
//



- (NSDictionary *) deleteRecordForFirstName : (NSString *)querySQL;
@end
