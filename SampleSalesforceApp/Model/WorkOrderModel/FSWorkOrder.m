//
//  WorkOrder.m
//  FS360
//
//  Created by BiznusSoft on 11/22/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import "FSWorkOrder.h"

@implementation FSWorkOrder

- (id)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        _wAccountId = [dict objectForKey:@"AccountId"];
        _wAssetDelC= [dict objectForKey:@"Asset_del__c"];
        _wCaseC= [dict objectForKey:@"Case__c"];
        _wDescription= [dict objectForKey:@"Description"];
        _wEffectiveDate = [dict objectForKey:@"EffectiveDate"];
        _wPrinterDownC = [dict objectForKey:@"PrinterDown__c"];
        _wErrorMessageC= [dict objectForKey:@"Error_Message__c"];
        _wID= [dict objectForKey:@"Id"];
        _wOrderNumber= [dict objectForKey:@"OrderNumber"];
        _wPricebook2ID= [dict objectForKey:@"Pricebook2Id"];
        _wPriorityC= [dict objectForKey:@"Priority__c"];
        _wSendToSapC= [[dict objectForKey:@"Send_to_SAP__c"] boolValue];
        _wShipToContact= [dict objectForKey:@"ShipToContactId"];
        _wShippingMethod= [dict objectForKey:@"ShippingMethod__c"];
        _wStatus= [dict objectForKey:@"Status"];
        _wWorkOrderC= [dict objectForKey:@"Work_Order__c"];
    }
    return self;
}

@end
