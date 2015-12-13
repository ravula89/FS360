//
//  WorkOrder.h
//  FS360
//
//  Created by BiznusSoft on 11/22/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSWorkOrder : NSObject

@property (nonatomic, strong) NSString *wAccountId;
@property (nonatomic, strong) NSString *wAssetDelC;
@property (nonatomic, strong) NSString *wCaseC;
@property (nonatomic, strong) NSString *wEffectiveDate;
@property (nonatomic, strong) NSString *wPrinterDownC;
@property (nonatomic, strong) NSString *wDescription;
@property (nonatomic, strong) NSString *wErrorMessageC;
@property (nonatomic, strong) NSString *wID;
@property (nonatomic, strong) NSString *wOrderNumber;
@property (nonatomic, strong) NSString *wPricebook2ID;
@property (nonatomic, strong) NSString *wPriorityC;
@property (nonatomic, assign) BOOL wSendToSapC;
@property (nonatomic, strong) NSString *wShipToContact;
@property (nonatomic, strong) NSString *wShippingMethod;
@property (nonatomic, strong) NSString *wStatus;
@property (nonatomic, strong) NSString *wWorkOrderC;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
