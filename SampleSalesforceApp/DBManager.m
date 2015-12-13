//
//  DBManager.m
//  MyNativeiOSApp
//
//  Created by Atif Mohammed on 7/15/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance {
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB {
    
    NSString *docsDir;
    
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"CONTACTS.db"]];
    BOOL isSuccess = YES;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            
            char * errMsg = nil;
            
            
            //            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (TECHID TEXT, NAME TEXT, TECHNICIAN TEXT, ACCOUNTNAME TEXT, CONTACTNAME TEXT, PHONE TEXT, ADDRESS TEXT, PRIORITY TEXT, STATUS TEXT)";
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (TECHID TEXT, NAME TEXT, TECHNICIAN TEXT, ACCOUNTNAME TEXT, ACCOUNTID TEXT, CONTACTNAME TEXT, PHONE TEXT,EMAIL TEXT, ADDRESS TEXT, PRIORITY TEXT, STATUS TEXT, CASEID TEXT, CASENAME TEXT, BILLABLE TEXT, CASEOWNER TEXT, WORKORDERPRIORITY TEXT, REGIONALCOORDINATOR TEXT,INSTALLEDPRODUCTSID TEXT, INSTALLEDPRODUCTS TEXT, SYMPTOM TEXT, SERIALNUMBER TEXT, SUBJECT TEXT, PROBLEMDESCRIPTION TEXT, SEVERITY TEXT, PRODUCT TEXT, DECRIPTION TEXT, MODELITEM TEXT, SERVICETYPE TEXT, SAPSOLDTOBILLTOACCOUNT TEXT, ACTIONTAKEN TEXT, PRIMARYADDRESS TEXT, SAPBILLTOADDRESS TEXT, SUBREGION TEXT, LATITTUDE TEXT,LONGITUDE TEXT,EXPENSESOVER50 TEXT,AREAPRINTED TEXT,AREAUNITS TEXT, INKUSAGE TEXT,PRINTTIME TEXT, ASSETDEL TEXT, CONTACTID TEXT);"

            "CREATE TABLE IF NOT EXISTS ACTIVITIES   (ACTIVITY TEXT, ACTIVITYID TEXT, ACTIVITYNAME TEXT, ACTIVITYSTARTDATE TEXT, ACTIVITYENDDATE TEXT, ACTIVITYBILLABLE TEXT, ACTIVITYPRIORITY TEXT, SERVICEORDERID TEXT);"
            
            "CREATE TABLE IF NOT EXISTS SERVICERESULTS   (SERVICEORDERID TEXT, NAME TEXT, ORDERACTIVITY TEXT, ROOTCAUSE TEXT, SUBSYSTEMS TEXT, SYMPTOMS TEXT, SYSTEM TEXT, ACTIONTAKEN TEXT, DETAILS TEXT, CREATEDDATE TEXT, DURATION TEXT);"
            
            "CREATE TABLE IF NOT EXISTS OTHERPARTSUSED   (OTHERPARTSID TEXT, PARTNUMBER TEXT, WORKORDER TEXT, SERVICERESULTS TEXT, PRODUCT TEXT, QUANTITY TEXT, SOURECE TEXT);"
            
            "CREATE TABLE IF NOT EXISTS PRICEBOOKENTRY   (PRICEBOOKENTRYID TEXT, MATERIALPARTNUMBER TEXT, PRICEBOOK2ID TEXT, PRODUCT2ID TEXT, PRODUCTCODE TEXT, PRODUCTNAME TEXT);"
          
            "CREATE TABLE IF NOT EXISTS ORDERS   (ORDERID TEXT, CASEID TEXT, ASSETDEL TEXT, DESCRIPTION TEXT,EFFECTIVEDATE TEXT,ERRORMESSAGE TEXT,ACCOUNTID TEXT,WORKORDERID TEXT,STATUS TEXT,SHIPPINGMETHOD TEXT,SHIPCONTACTID TEXT,SENDTOSAP TEXT,PRIORITY TEXT,PRINTERDOWN TEXT,ORDERNUMBER TEXT,PRICEBOOK2ID TEXT);"
            
            "CREATE TABLE IF NOT EXISTS RMA   (RMAID TEXT, ORDERPRODUCTID TEXT, PARTNUMBER TEXT, QUANTITY TEXT, RMAREQUIRED TEXT, RMATRACKINGNUMBER TEXT, WORKORDERID TEXT, DESCRIPTION TEXT);"
            
            "CREATE TABLE IF NOT EXISTS ASSIGNEDTECHNICIAN   (ASSIGNEDTECHNICIANID TEXT, TECHNICIANID TEXT, FSUSERID TEXT, NAME TEXT, ESTIMATEDSTARTDATE TEXT, ESTIMATEDENDDATE TEXT);"
           
            "CREATE TABLE IF NOT EXISTS ORDERPRODUCTS   (ORDERPRODUCTSID TEXT, ORDERID TEXT, MATERIALPARTNUMBER TEXT, PARTNAME TEXT, UNUSEDQUANTITY TEXT, USEDQUANTITY TEXT, WORKORDERID TEXT, PRICEBOOKENTRYID TEXT, QUANTITY TEXT, UNITPRICE TEXT);"

            "CREATE TABLE IF NOT EXISTS TIMEANDEXPENSES   (TIMEID TEXT, NAME TEXT, TIMEACTIVITY TEXT, TIMESTARTDATE TEXT, TIMEENDDATE TEXT, TIMEDURATION TEXT, COMMENTS TEXT, TYPE TEXT);"
            
            "CREATE TABLE IF NOT EXISTS ATTACHMENTS   (SERVICEORDERID TEXT, BODY TEXT, NAME TEXT);"
            
            "CREATE TABLE IF NOT EXISTS ESCALATION (NAME TEXT, ACCOUNT TEXT, ESCALATIONCASE TEXT, ASSET TEXT, INSTALLEDPRODUCT TEXT, WORKORDER TEXT, SITE TEXT, TYPE TEXT, ESCALATIONOWNER TEXT, PARTNUMBER TEXT, CASEOWNER TEXT, STATUS TEXT, FSE TEXT, CASEPRIORITY TEXT, PROBLEMDESCRIPTION TEXT, ESCALATIONSYMPTOMS TEXT, ENDDATE TEXT, TIMEOPEN TEXT, SERIALNUMBER TEXT, ESCALATIONRESOLUTION TEXT);"
            
            "CREATE TABLE IF NOT EXISTS INSTALLEDPRODUCTS   (INSTALLEDPRODUCTSID TEXT, NAME TEXT, SERIALNUMBER TEXT, CUSTOMERNAME TEXT, CUSTOMER TEXT, CONTACT TEXT, ASSETUNIQUEFIELD TEXT, ASSETNAME TEXT, ITEMID TEXT, LATTITUDE TEXT, LONGITUDE TEXT);"
            
            "CREATE TABLE IF NOT EXISTS INSTALLEDMOD   (INSTALLEDMODID TEXT, NAME TEXT, INSTALLEDPRODUCTS TEXT, INSTALL TEXT, INSTALLEDDATE TEXT, MODREQUIRED TEXT, MODNAME TEXT, EXISTINGMOD TEXT, MODNUMBER TEXT, DOCTITLE TEXT);"
            
            "CREATE TABLE IF NOT EXISTS AVAILABLEMOD   (AVAILABLEMODID TEXT, NAME TEXT, INSTALLEDPRODUCTS TEXT, INSTALL TEXT, INSTALLEDDATE TEXT, MODREQUIRED TEXT, MODNAME TEXT, EXISTINGMOD TEXT, MODNUMBER TEXT, DOCTITLE TEXT);" ;
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(database);
            return  isSuccess;
            
        } else {
            
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    
    return isSuccess;
}


// Save TechnicianId

//-(BOOL)saveTechnicianId:(NSString *)technicianId {
//
//    const char *dbPath=[databasePath UTF8String];
//
//    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
//    {
//        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO TECHNICIAN VALUES (\"%@\")", technicianId];
//
//        const char *insertStmt=[insertSQL UTF8String];
//
//        char *errmsg=nil;
//
//        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
//        {
//            NSLog(@"ADDED!");
//        }
//
//        sqlite3_close(database);
//    }
//
//
//    return NO;
//}
//
//
//-(NSMutableArray *)getTechnicianDetails {
//
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//
//    if (array.count ==0) {
//
//        // Setup the database object
//        sqlite3 *database;
//
//        // Open the database from the users filessytem
//        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
//
//            // Setup the SQL Statement and compile it for faster access
//
//            //SQLIte Statement
//            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select TECHNICIANID from TECHNICIAN"];
//
//            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//
//                // Loop through the results and add them to the feeds array
//
//                while(sqlite3_step(statement) == SQLITE_ROW)
//                {
//                    // Init the Data Dictionary
//                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
//
//                    NSString *technicianId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",technicianId] forKey:@"Id"];
//
//                    [array addObject:_dataDictionary];
//                }
//
//
//            } else {
//
//                NSLog(@"No Data Found");
//            }
//
//            // Release the compiled statement from memory
//            sqlite3_finalize(statement);
//        }
//
//        sqlite3_close(database);
//    }
//
//    return array;
//}
//
//
//-(void)deleteTechnicianDetails {
//
//    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
//
//        NSString  *sql = [NSString stringWithFormat:@"delete from TECHNICIAN"];
//
//        const char *insert_stmt = [sql UTF8String];
//
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//
//        if (sqlite3_step(statement) == SQLITE_DONE) {
//
//            NSLog(@"Delete successfully");
//
//        } else {
//
//            NSLog(@"Delete not successfully");
//        }
//
//        sqlite3_finalize(statement);
//        sqlite3_close(database);
//    }
//
//}
//

//Service Orders

- (BOOL) saveData:(NSString *)techId name:(NSString *)name technician:(NSString *)technician accountName:(NSString *)accountName accountId:(NSString *)accountId contactName:(NSString *)contactName phone:(NSString *)phone email:(NSString *)email address:(NSString *)address priority:(NSString *)priority status:(NSString *)status caseId:(NSString *)caseId caseName:(NSString *)caseName billable:(NSString *)billable caseOwner:(NSString *)caseOwner workOrderPriority:(NSString *)workOrderPriority regionalCoordinator:(NSString *) regionalCoordinator installedProductsId:(NSString *)installedProductsId installedProducts:(NSString *)installedProducts symptom:(NSString *)symptom serialNumber:(NSString *)serialNumber sybject:(NSString *)subject problemDescription:(NSString *)problemDescription severity:(NSString *)severity product:(NSString *)product description:(NSString *)description modelItem:(NSString *)modelItem serviceType:(NSString *)serviceType sapSlodToBillToAccount:(NSString *)sapSlodToBillToAccount actionTaken:(NSString *)actionTaken primaryAddress:(NSString *)primaryAddress sapBillToAddress:(NSString *)sapBillToAddress subRegion:(NSString *)subRegion latittude:(NSString *)latittude longitude:(NSString *)longitude expensesOver50:(NSString *)expensesOver50 areaPrinted:(NSString *)areaPrinted areaUnits:(NSString *)areaUnits inkUsage:(NSString *)inkUsage printTime:(NSString *)printTime assetDel:(NSString *)assetDel contactId:(NSString *)contactId{
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO CONTACTS VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\", \"%@\")", techId, name, technician,accountName,accountId,contactName,phone,email,address,priority,status,caseId,caseName,billable,caseOwner,workOrderPriority,regionalCoordinator,installedProductsId,installedProducts,symptom,serialNumber,subject,problemDescription,severity,product,description,modelItem,serviceType,sapSlodToBillToAccount,actionTaken,primaryAddress,sapBillToAddress,subRegion,latittude,longitude,expensesOver50,areaPrinted,areaUnits,inkUsage,printTime,assetDel,contactId];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)readInformationFromDatabase {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select TECHID, NAME, TECHNICIAN, ACCOUNTNAME,ACCOUNTID,CONTACTNAME,PHONE,EMAIL,ADDRESS,PRIORITY,STATUS,CASEID,CASENAME,BILLABLE,CASEOWNER,WORKORDERPRIORITY,REGIONALCOORDINATOR,INSTALLEDPRODUCTSID,INSTALLEDPRODUCTS,SYMPTOM,SERIALNUMBER,SUBJECT,PROBLEMDESCRIPTION,SEVERITY,PRODUCT,DECRIPTION,MODELITEM,SERVICETYPE,SAPSOLDTOBILLTOACCOUNT,ACTIONTAKEN,PRIMARYADDRESS,SAPBILLTOADDRESS,SUBREGION,LATITTUDE,LONGITUDE,EXPENSESOVER50,AREAPRINTED,AREAUNITS,INKUSAGE,PRINTTIME, ASSETDEL, CONTACTID from CONTACTS"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *techID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *technician = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *accountName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *accountId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *contacName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];

                    NSString *address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    
                    NSString *priority = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    
                    NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    
                    NSString *caseId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString *caseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString *billable = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString *caseOwner = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString *workOrderPriority = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString *regionalCoordinatoe = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString *installedProductsId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString *installedProducts = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString *symptom = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    NSString *serialNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                    NSString *subject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                    NSString *problemDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                    NSString *severity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                    NSString *product = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                    NSString *modelItem = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                    NSString *serviceType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                    NSString *sapSoldtobillToAccount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                    NSString *actionTaken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                    NSString *primaryAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
                    NSString *sapBillToAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                    NSString *subRegion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)];
                    NSString *latittude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)];
                    NSString *longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)];
                    NSString *expensesOver50 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                    NSString *areaPrinted = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                    NSString *areaUnits = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                    NSString *inkUsage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)];
                    NSString *printTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)];
                    
                    NSString *assetDel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)];

                    NSString *contactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)];

                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",techID] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",technician] forKey:@"FConnect__Technician_used__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",accountName] forKey:@"FConnect__Account_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",accountId] forKey:@"FConnect__Account__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",contacName] forKey:@"ContactName__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",phone] forKey:@"contact_Phone__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",email] forKey:@"Contact_Email__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",address] forKey:@"FConnect__Bill_To_Address__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",priority] forKey:@"FConnect__Priority__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"CaseStatus__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",caseId] forKey:@"Case__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",caseName] forKey:@"Case_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",billable] forKey:@"Billing_Status__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",caseOwner] forKey:@"Owner__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrderPriority] forKey:@"casePriority__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",regionalCoordinatoe] forKey:@"Regional_Coordinator__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedProductsId] forKey:@"FConnect__Installed_Product__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedProducts] forKey:@"FConnect__Installed_Product2__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",symptom] forKey:@"Symptom__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serialNumber] forKey:@"Serial_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",subject] forKey:@"Subject__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",problemDescription] forKey:@"FConnect__Problem_Description__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",severity] forKey:@"Severity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",product] forKey:@"Product__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",description] forKey:@"CaseDescription__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modelItem] forKey:@"Model_Item__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serviceType] forKey:@"Service_Type__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",sapSoldtobillToAccount] forKey:@"SAP_Sold_To_Bill_To_AccountText__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",primaryAddress] forKey:@"Primary_Address__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",actionTaken] forKey:@"Action_Taken__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",sapBillToAddress] forKey:@"SAP_Bill_To_Address__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",subRegion] forKey:@"Sub_Region__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",latittude] forKey:@"Latitude__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",longitude] forKey:@"Longitude__c"];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",expensesOver50] forKey:@"Expenses_over_50__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",areaPrinted] forKey:@"AreaPrinted__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",areaUnits] forKey:@"AreaUnit__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",inkUsage] forKey:@"InkUsage__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",printTime] forKey:@"PrintTime__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",assetDel] forKey:@"Asset__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",contactId] forKey:@"Contact__c"];

                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}


-(void)executeQuery {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from CONTACTS"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

//Activities

- (BOOL) saveActivities:(NSString *)activity activityId:(NSString *)activityId actvityName:(NSString *)actvityName activityStartDate:(NSString *)activityStartDate actvityEndDate:(NSString *)activityEndDate activityBillable:(NSString *)activityBillable activityPriority:(NSString *)activityPriority serviceOrderId:(NSString *)serviceOrderId {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO ACTIVITIES VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", activity, activityId, actvityName,activityStartDate,activityEndDate,activityBillable,activityPriority,serviceOrderId];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getActivities {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select ACTIVITY, ACTIVITYID, ACTIVITYNAME, ACTIVITYSTARTDATE,ACTIVITYENDDATE,ACTIVITYBILLABLE,ACTIVITYPRIORITY,SERVICEORDERID from ACTIVITIES"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *activity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *activityId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *activityName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *activityStartDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *activityEndDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *activityBILLABLE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *activityPriority = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString *activityServiceOrderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activity] forKey:@"FConnect__Activity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityName] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityStartDate] forKey:@"FConnect__Planned_Start_DateTime__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityEndDate] forKey:@"FConnect__Planned_End_Date_Time__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityBILLABLE] forKey:@"FConnect__Billable__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityPriority] forKey:@"FConnect__Priority__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activityServiceOrderId] forKey:@"FConnect__Service_OrderId__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}

-(void)deleteActivitiesDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ACTIVITIES"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

- (BOOL)saveAssignedTechnicianId:(NSString *)assignedTechnicianId technicianId:(NSString *)technicianId FSUserId:(NSString *)FSUserId name:(NSString *)name estimatedStartDate:(NSString *)estimatedStartDate estimatedEndDate:(NSString *)estimatedEndDate
{
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO ASSIGNEDTECHNICIAN VALUES (\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\")", assignedTechnicianId, technicianId, FSUserId, name,estimatedStartDate, estimatedEndDate];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getAssignedTechnicianDetails
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select ASSIGNEDTECHNICIANID, TECHNICIANID, FSUSERID, NAME, ESTIMATEDSTARTDATE, ESTIMATEDENDDATE from ASSIGNEDTECHNICIAN"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *assignedTechnicianId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *technicianId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *FSUserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *estimatedStartDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *estimatedEndDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",assignedTechnicianId] forKey:@"Id"];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",technicianId] forKey:@"Technician__c"];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",FSUserId] forKey:@"SF_User_ID__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",estimatedStartDate] forKey:@"Estimated_Start_Date__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",estimatedEndDate] forKey:@"Estimated_End_Date__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}

-(void)deleteAssignedTechnicianDB
{
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ASSIGNEDTECHNICIAN"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


// Order Products

- (BOOL)saveOrderProductsId:(NSString *)orderProductsId orderId:(NSString *)orderId materialPartNumber:(NSString *)materialPartNumber partName:(NSString *)partName unUsedQuantity:(NSString *)unUsedQuantity usedQuantity:(NSString *)usedQuantity workOrderId:(NSString *)workOrderId pricebookEntryId:(NSString *)pricebookEntryId quantity:(NSString *)quantity unitPrice:(NSString *)unitPrice{
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO ORDERPRODUCTS VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", orderProductsId, orderId, materialPartNumber, partName,unUsedQuantity, usedQuantity, workOrderId, pricebookEntryId, quantity, unitPrice];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getOrderProducts {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select ORDERPRODUCTSID, ORDERID, MATERIALPARTNUMBER, PARTNAME, UNUSEDQUANTITY, USEDQUANTITY, WORKORDERID, PRICEBOOKENTRYID, QUANTITY, UNITPRICE from ORDERPRODUCTS"];

            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *orderProductsId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *orderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *materialPartNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *partName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *unUsedQuantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *usedQuantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *workOrderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *pricebookEntryId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                   
                    NSString *quantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    
                    NSString *unitPrice = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];

                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderProductsId] forKey:@"Id"];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderId] forKey:@"OrderId"];

                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",materialPartNumber] forKey:@"Material_Part_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",partName] forKey:@"Part_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",unUsedQuantity] forKey:@"Unused_Quantity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",usedQuantity] forKey:@"Used_Quantity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrderId] forKey:@"Work_Order__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",pricebookEntryId] forKey:@"PricebookEntryId"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",quantity] forKey:@"Quantity"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",unitPrice] forKey:@"UnitPrice"];

                    [array addObject:_dataDictionary];
                }
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}

-(void)deleteOrderProductsDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ORDERPRODUCTS"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

// Service Results Data

- (BOOL)saveServiceResultsId:(NSString *)serviceResultsId name:(NSString *)name orderActivity:(NSString *)orderActivity rootCause:(NSString *)rootCause subSystems:(NSString *)subSystems symptoms:(NSString *)symptoms system:(NSString *)system actionTaken:(NSString *)actionTaken details:(NSString *)details createdDate:(NSString *)createdDate duration:(NSString *)duration {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO SERVICERESULTS VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", serviceResultsId, name, orderActivity, rootCause,subSystems,symptoms,system,actionTaken,details,createdDate,duration];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
    
    
}


-(NSMutableArray *)getServiceResultsDetails {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select SERVICEORDERID, NAME, ORDERACTIVITY, ROOTCAUSE,SUBSYSTEMS,SYMPTOMS,SYSTEM,ACTIONTAKEN, DETAILS,CREATEDDATE,DURATION from SERVICERESULTS"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                                        
                    NSString *serviceResultsId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *orderActivity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *rootCause = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *subSystems = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *symptoms = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *system = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *actionTaken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString *details = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString *createdDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString *duration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serviceResultsId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderActivity] forKey:@"Order_Activity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",rootCause] forKey:@"Root_Cause__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",subSystems] forKey:@"Sub_Systems__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",symptoms] forKey:@"Symp__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",system] forKey:@"System__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",actionTaken] forKey:@"Action_Taken__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",details] forKey:@"Details__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",createdDate] forKey:@"CreatedDate__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",duration] forKey:@"Duration__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}



-(void)deleteServiceResultsDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from SERVICERESULTS"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



// Other Parts Used Data

- (BOOL)saveOtherPartsId:(NSString *)otherPartsId partNumber:(NSString *)partNumber workOrder:(NSString *)workOrder serviceResults:(NSString *)serviceResults product:(NSString *)product quantity:(NSString *)quantity source:(NSString *)source {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO OTHERPARTSUSED VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", otherPartsId, partNumber, workOrder, serviceResults,product,quantity,source];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
    
    
}


-(NSMutableArray *)getOtherPartsUsedDetails {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select OTHERPARTSID, PARTNUMBER, WORKORDER, SERVICERESULTS,PRODUCT,QUANTITY,SOURECE from OTHERPARTSUSED"];
            
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *otherPartsId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *partNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *workOrder = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *serviceResults = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *product = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *quantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *source = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    //select Id, Part_Number__c, Work_Order__c, Service_Results__c, Product__c, Quantity__c, Source__c from Other_Part_Used__r
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",otherPartsId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",partNumber] forKey:@"Part_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrder] forKey:@"Work_Order__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serviceResults] forKey:@"Service_Results__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",product] forKey:@"Product__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",quantity] forKey:@"Quantity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",source] forKey:@"Source__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}



-(void)deleteOtherPartsUsedDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from OTHERPARTSUSED"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

// PricebookEntryData

- (BOOL)savePricebookEntryId:(NSString *)pricebookEntryId materialPartNumber:(NSString *)materialPartNumber pricebook2Id:(NSString *)pricebook2Id product2Id:(NSString *)product2Id productCode:(NSString *)productCode productName:(NSString *)productName {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO PRICEBOOKENTRY VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", pricebookEntryId, materialPartNumber, pricebook2Id, product2Id,productCode,productName];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
    
    
}

-(NSMutableArray *)getPricebookEntryDetails {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select PRICEBOOKENTRYID, MATERIALPARTNUMBER, PRICEBOOK2ID, PRODUCT2ID,PRODUCTCODE,PRODUCTNAME from PRICEBOOKENTRY"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *pricebookEntryId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *materialPartNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *pricebook2Id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *product2Id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *productCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *productName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",pricebookEntryId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",materialPartNumber] forKey:@"Material_Part_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",pricebook2Id] forKey:@"Pricebook2Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",product2Id] forKey:@"Product2Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",productCode] forKey:@"ProductCode"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",productName] forKey:@"Product_Name__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}



-(void)deletePricebookEntryDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from PRICEBOOKENTRY"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

// Order


- (BOOL)saveOrderId:(NSString *)orderId caseId:(NSString *)caseId assetDel:(NSString *)assetDel description:(NSString *)description effectiveDate:(NSString *)effectiveDate errorMessage:(NSString *)errorMessage accountId:(NSString *)accountId workOrderId:(NSString *)workOrderId status:(NSString *)status shippingMethod:(NSString *)shippingMethod shipToContactId:(NSString *)shipToContactId sendtoSAP:(NSString *)sendtoSAP priority:(NSString *)priority printerDown:(NSString *)printerDown orderNumber:(NSString *)orderNumber pricebook2Id:(NSString *)pricebook2Id {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO ORDERS VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", orderId, caseId, assetDel, description,effectiveDate,errorMessage, accountId, workOrderId, status, shippingMethod, shipToContactId, sendtoSAP,priority, printerDown, orderNumber, pricebook2Id];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
    
    
}



-(NSMutableArray *)getOrderDetails{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select ORDERID, CASEID, ASSETDEL, DESCRIPTION,EFFECTIVEDATE,ERRORMESSAGE,ACCOUNTID,WORKORDERID,STATUS,SHIPPINGMETHOD,SHIPCONTACTID,SENDTOSAP,PRIORITY,PRINTERDOWN,ORDERNUMBER,PRICEBOOK2ID from ORDERS"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                char *errmsg=nil;
                
                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *orderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *caseId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *assetDel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *effectiveDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *errorMessage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *accountId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *workOrderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    
                    NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    
                    NSString *shippingMethod = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    
                    NSString *shipToContactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    
                    NSString *sendtoSAP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    
                    NSString *priority = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    
                    NSString *printerDown = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    
                    NSString *orderNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    
                    NSString *pricebook2Id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",caseId] forKey:@"Case__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",assetDel] forKey:@"Asset_del__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",description] forKey:@"Description"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",effectiveDate] forKey:@"EffectiveDate"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",errorMessage] forKey:@"Error_Message__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",accountId] forKey:@"AccountId"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrderId] forKey:@"Work_Order__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"Status"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",shippingMethod] forKey:@"ShippingMethod__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",shipToContactId] forKey:@"ShipToContactId"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",sendtoSAP] forKey:@"Send_to_SAP__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",priority] forKey:@"Priority__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",printerDown] forKey:@"PrinterDown__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderNumber] forKey:@"OrderNumber"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",pricebook2Id] forKey:@"Pricebook2Id"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}






//{
//    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    
//    if (array.count ==0) {
//        
//        // Setup the database object
//        sqlite3 *database;
//        
//        // Open the database from the users filessytem
//        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
//            
//            // Setup the SQL Statement and compile it for faster access
//            
//            //SQLIte Statement
//            
//            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//                
//                // Loop through the results and add them to the feeds array
//                
//                //                char *errmsg=nil;
//                //                NSLog(@"errmsg:%s",errmsg);
//                
//                while(sqlite3_step(statement) == SQLITE_ROW)
//                {
//                    
//                    // Init the Data Dictionary
//                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
//                    
//                    NSString *orderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                    
//                    NSString *caseId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                    
//                    NSString *assetDel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                    
//                    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                    
//                    NSString *effectiveDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                    
//                    NSString *errorMessage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                    
//                    NSString *accountId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//
//                    NSString *workOrderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//                  
//                    NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//                   
//                    NSString *shippingMethod = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//                   
//                    NSString *shipToContactId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
//                 
//                    NSString *sendtoSAP = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
//                    
//                    NSString *priority = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
//                   
//                    NSString *printerDown = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
//                   
//                    NSString *orderNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
//                   
//                    NSString *pricebook2Id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
//
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderId] forKey:@"Id"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",caseId] forKey:@"Case__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",assetDel] forKey:@"Asset_del__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",description] forKey:@"Description"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",effectiveDate] forKey:@"EffectiveDate"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",errorMessage] forKey:@"Error_Message__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",accountId] forKey:@"AccountId"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrderId] forKey:@"Work_Order__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"Status"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",shippingMethod] forKey:@"ShippingMethod__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",shipToContactId] forKey:@"ShipToContactId"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",sendtoSAP] forKey:@"Send_to_SAP__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",priority] forKey:@"Priority__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",printerDown] forKey:@"PrinterDown__c"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderNumber] forKey:@"OrderNumber"];
//                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",pricebook2Id] forKey:@"Pricebook2Id"];
//
//                    [array addObject:_dataDictionary];
//                }
//                
//                
//            } else {
//                
//                NSLog(@"No Data Found");
//            }
//            
//            // Release the compiled statement from memory
//            sqlite3_finalize(statement);
//        }
//        
//        sqlite3_close(database);
//    }
//    
//    return array;
//}


-(void)deleteOrderDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ORDERS"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

// RMA

- (BOOL)saveRMAId:(NSString *)RMAId orderProductId:(NSString *)orderProductId partNumber:(NSString *)partNumber quantity:(NSString *)quantity RMARequired:(NSString *)RMARequired RMATrakingNumber:(NSString *)RMATrakingNumber workOrderId:(NSString *)workOrderId description:(NSString *)description {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO RMA VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", RMAId, orderProductId, partNumber,quantity, RMARequired,RMATrakingNumber,workOrderId,description];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}

-(NSMutableArray *)getRMADetails {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select RMAID, ORDERPRODUCTID, PARTNUMBER, QUANTITY, RMAREQUIRED, RMATRACKINGNUMBER, WORKORDERID, DESCRIPTION from RMA"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *RMAId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *orderProductId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *partNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *quantity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *RMARequired = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *RMATrakingNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *workOrderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",RMAId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",orderProductId] forKey:@"Order_Product__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",partNumber] forKey:@"Part_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",quantity] forKey:@"Quantity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",RMARequired] forKey:@"RMA_Required__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",RMATrakingNumber] forKey:@"RMA_Tracking_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrderId] forKey:@"Work_Order__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",description] forKey:@"Description__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}

-(void)deleteRMADB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from RMA"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



// Time & Expenses


- (BOOL) saveTime:(NSString *)timeId name:(NSString *)name timeActivity:(NSString *)timeActivity timeStartDate:(NSString *)timeStartDate timeEndDate:(NSString *)timeEndDate timeDuration:(NSString *)timeDuration comments:(NSString *)comments type:(NSString *)type {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO TIMEANDEXPENSES VALUES (\"%@\", \"%@\", \"%@\" , \"%@\" , \"%@\",\"%@\", \"%@\", \"%@\")", timeId, name, timeActivity, timeStartDate, timeEndDate,timeDuration, comments, type];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}

-(NSMutableArray *)getTime {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select TIMEID, NAME, TIMEACTIVITY, TIMESTARTDATE,TIMEENDDATE,TIMEDURATION,COMMENTS,TYPE from TIMEANDEXPENSES"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *timeId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *activity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *startDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *endDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *timeDuration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *comments = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",timeId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",activity] forKey:@"FConnect__Activity__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",startDate] forKey:@"FConnect__Start_Date_Time__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",endDate] forKey:@"FConnect__End_Date_Time__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",timeDuration] forKey:@"FConnect__Duration_MM__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",comments] forKey:@"FConnect__Comments__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",type] forKey:@"FConnect__Type__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}



-(void)deletegetTimeDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from TIMEANDEXPENSES"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



// Escalations

- (BOOL) saveEscalations:(NSString *)escalationName escalationAccount:(NSString *)escalationAccount escalationCase:(NSString *)escalationCase asset:(NSString *)asset installedProduct:(NSString *)installedProduct workOrder:(NSString *)workOrder site:(NSString *)site type:(NSString *)type escalationOwner:(NSString *)escalationOwner partNumber:(NSString *)partNumber caseOwner:(NSString *)caseOwner status:(NSString *)status FSE:(NSString *)FSE casePriority:(NSString *)casePriority problemDescription:(NSString *)problemDescription escalationSymptoms:(NSString *)escalationSymptoms endDate:(NSString *)endDate timeOpen:(NSString *)timeOpen serialNumber:(NSString *)serialNumber escalationResolution:(NSString *)escalationResolution {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO ESCALATION VALUES (\"%@\", \"%@\", \"%@\" , \"%@\" , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", escalationName, escalationAccount, escalationCase, asset, installedProduct, workOrder, site, type, escalationOwner, partNumber, caseOwner,status,FSE,casePriority,problemDescription,escalationSymptoms,endDate,timeOpen,serialNumber,escalationResolution];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getEscalations {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select NAME, ACCOUNT, ESCALATIONCASE, ASSET, INSTALLEDPRODUCT, WORKORDER, SITE, TYPE, ESCALATIONOWNER, PARTNUMBER, CASEOWNER, STATUS, FSE, CASEPRIORITY, PROBLEMDESCRIPTION, ESCALATIONSYMPTOMS, ENDDATE, TIMEOPEN, SERIALNUMBER, ESCALATIONRESOLUTION from ESCALATION"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *account = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *escalationCase = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *asset = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString *installedProduct = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString *workOrder = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString *site = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString *type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString *escalationOwner = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString *partNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    NSString *caseOwner = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    NSString *status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                    NSString *FSE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                    NSString *casePriority = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                    NSString *problemDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                    NSString *escalationSymptoms = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                    NSString *endDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                    NSString *timeOpen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                    NSString *serialNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                    NSString *escalationResolution = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",account] forKey:@"Account__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",escalationCase] forKey:@"Case__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",asset] forKey:@"Asset__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedProduct] forKey:@"Installed_Product__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",workOrder] forKey:@"Work_Order__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",site] forKey:@"Site__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",type] forKey:@"Type__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",escalationOwner] forKey:@"Escalation_Owner__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",partNumber] forKey:@"Part_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",caseOwner] forKey:@"Case_Owner__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",status] forKey:@"Status__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",FSE] forKey:@"FSE__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",casePriority] forKey:@"Case_Priority__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",problemDescription] forKey:@"Problem_Description__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",escalationSymptoms] forKey:@"Escalation_Symptoms__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",endDate] forKey:@"End_Date__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",timeOpen] forKey:@"Time_Open__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serialNumber] forKey:@"Serial_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",escalationResolution] forKey:@"Escalation_Resolution__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}


-(void)deleteEscationsDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ESCALATION"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


//Installed Mod

- (BOOL) saveInstalledMod:(NSString *)installedModId name:(NSString *)name installedProducts:(NSString *)installedProducts install:(NSString *)install installedDate:(NSString *)installedDate modRequired:(NSString *)modRequired modName:(NSString *)modName existingMod:(NSString *)existingMod modNumber:(NSString *)modNumber docTitle:(NSString *)docTitle {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO INSTALLEDMOD VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", installedModId, name, installedProducts, install, installedDate, modRequired, modName, existingMod, modNumber, docTitle];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getInstalledMods {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select INSTALLEDMODID, NAME, INSTALLEDPRODUCTS, INSTALL, INSTALLEDDATE, MODREQUIRED, MODNAME, EXISTINGMOD, MODNUMBER, DOCTITLE from INSTALLEDMOD"];
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *installedModId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *installedProducts = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *install = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString *installedDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString *modRequired = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString *modName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString *existingMod = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString *modNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString *docTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedModId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedProducts] forKey:@"Installed_Products__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",install] forKey:@"Install__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedDate] forKey:@"Installed_Date__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modRequired] forKey:@"Mod_Required__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modName] forKey:@"Mod_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",existingMod] forKey:@"Existing_Mod__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modNumber] forKey:@"Mod_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",docTitle] forKey:@"Doc_Title__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}


-(void)deleteInstalledModDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from INSTALLEDMOD"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

//Available Mod

- (BOOL) saveAvailableMod:(NSString *)availableModId name:(NSString *)name installedProducts:(NSString *)installedProducts install:(NSString *)install installedDate:(NSString *)installedDate modRequired:(NSString *)modRequired modName:(NSString *)modName existingMod:(NSString *)existingMod modNumber:(NSString *)modNumber docTitle:(NSString *)docTitle {
    
    const char *dbPath=[databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO AVAILABLEMOD VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", availableModId, name, installedProducts, install, installedDate, modRequired, modName, existingMod, modNumber, docTitle];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getAvailableMods {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select AVAILABLEMODID, NAME, INSTALLEDPRODUCTS, INSTALL, INSTALLEDDATE, MODREQUIRED, MODNAME, EXISTINGMOD, MODNUMBER, DOCTITLE from AVAILABLEMOD"];
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *availableModId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *installedProducts = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *install = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    NSString *installedDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    NSString *modRequired = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    NSString *modName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    NSString *existingMod = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSString *modNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    NSString *docTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",availableModId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedProducts] forKey:@"Installed_Products__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",install] forKey:@"Install__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedDate] forKey:@"Installed_Date__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modRequired] forKey:@"Mod_Required__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modName] forKey:@"Mod_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",existingMod] forKey:@"Existing_Mod__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",modNumber] forKey:@"Mod_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",docTitle] forKey:@"Doc_Title__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}


-(void)deleteAvailableModDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from AVAILABLEMOD"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


// Attachments

- (BOOL) saveAttachments:(NSString *)serviceOrderId Body:(NSString *)Body Name:(NSString *)Name {
    
    const char *dbPath=[databasePath UTF8String];
    
    NSLog(@"dbPath:%s",dbPath);
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO ATTACHMENTS VALUES (\"%@\", \"%@\",  \"%@\")", serviceOrderId, Body, Name];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
    
    
}


-(NSMutableArray *)getAttachments {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select SERVICEORDERID, BODY, NAME from ATTACHMENTS"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *serviceOrderId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *body = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serviceOrderId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",body] forKey:@"Body"];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}

-(void)deleteAttachmentsDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ATTACHMENTS"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}

//Installed Products

- (BOOL) saveInstalledProucts:(NSString *)installedProductId name:(NSString *)name serialNumber:(NSString *)serialNumber customerName:(NSString *)customerName customer:(NSString *)customer contact:(NSString *)contact assetUniqueField:(NSString *)assetUniqueField assetName:(NSString *)assetName itemId:(NSString *)itemId latittude:(NSString *)latittude longitude:(NSString *)longitude {
    
    const char *dbPath=[databasePath UTF8String];
    
    NSLog(@"dbPath:%s",dbPath);
    
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO INSTALLEDPRODUCTS VALUES (\"%@\", \"%@\", \"%@\" , \"%@\" , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", installedProductId, name, serialNumber, customerName, customer, contact, assetUniqueField, assetName, itemId, latittude, longitude];
        
        const char *insertStmt=[insertSQL UTF8String];
        
        char *errmsg=nil;
        
        if(sqlite3_exec(database, insertStmt, NULL, NULL, &errmsg)==SQLITE_OK)
        {
            NSLog(@"ADDED!");
        }
        
        sqlite3_close(database);
    }
    
    
    return NO;
}


-(NSMutableArray *)getInstalledProducts {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count ==0) {
        
        // Setup the database object
        sqlite3 *database;
        
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            // Setup the SQL Statement and compile it for faster access
            
            //SQLIte Statement
            NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select INSTALLEDPRODUCTSID, NAME, SERIALNUMBER, CUSTOMERNAME, CUSTOMER, CONTACT, ASSETUNIQUEFIELD, ASSETNAME, ITEMID, LATTITUDE, LONGITUDE from INSTALLEDPRODUCTS"];
            
            if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                
                // Loop through the results and add them to the feeds array
                
                //                char *errmsg=nil;
                //                NSLog(@"errmsg:%s",errmsg);
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    // Init the Data Dictionary
                    NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                    
                    NSString *installedProductId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    
                    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    
                    NSString *serialNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    
                    NSString *customerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    NSString *customer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    
                    NSString *contact = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    NSString *assetUniqueField = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    
                    NSString *assetName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    
                    NSString *itemId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    
                    NSString *latittude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    
                    NSString *longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",installedProductId] forKey:@"Id"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"Name"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",serialNumber] forKey:@"Serial_Number__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",customerName] forKey:@"Customer_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",customer] forKey:@"FConnect__Customer__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",contact] forKey:@"FConnect__Contact__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",assetUniqueField] forKey:@"AssetUniqueField__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",assetName] forKey:@"Asset_Name__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",itemId] forKey:@"FConnect__Item_ID_Used__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",latittude] forKey:@"Latitude__c"];
                    [_dataDictionary setObject:[NSString stringWithFormat:@"%@",longitude] forKey:@"Longitude__c"];
                    
                    [array addObject:_dataDictionary];
                }
                
                
            } else {
                
                NSLog(@"No Data Found");
            }
            
            // Release the compiled statement from memory
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    
    return array;
}


-(void)deleteInstalledProductsDB {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString  *sql = [NSString stringWithFormat:@"delete from INSTALLEDPRODUCTS"];
        
        const char *insert_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


-(NSDictionary *)deleteRecordForFirstName:(NSString *)querySQL {
    
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *insert_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            NSLog(@"Delete successfully");
            
            char *jNameChars = (char *) sqlite3_column_text(statement,0);
            NSString *firstName = jNameChars?[[NSString alloc]initWithUTF8String:jNameChars]:@"";
            [infoDict setObject:firstName forKey:@"FirstName"];
            
            
            char *jNameChars1 = (char *) sqlite3_column_text(statement,1);
            
            NSString *lastName = jNameChars1?[[NSString alloc]initWithUTF8String:jNameChars1]:@"";
            
            [infoDict setObject:lastName forKey:@"LastName"];
            
            char *jNameChars2 = (char *) sqlite3_column_text(statement,2);
            NSString *phone = jNameChars2?[[NSString alloc]initWithUTF8String:jNameChars2]:@"";
            
            [infoDict setObject:phone forKey:@"Phone"];
            
            
            char *jNameChars3 = (char *) sqlite3_column_text(statement,3);
            
            NSString *email = jNameChars3?[[NSString alloc]initWithUTF8String:jNameChars3]:@"";
            
            [infoDict setObject:email forKey:@"Email"];
            
        } else {
            
            NSLog(@"Delete not successfully");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return infoDict;
}


@end
