//
//  ActivitiesTableViewCell.h
//  FS360
//
//  Created by BiznusSoft on 12/12/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderPriorityLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderShippingMethodLabel;
@property (strong, nonatomic) IBOutlet UIButton *orderPrinterDownButton;
@property (strong, nonatomic) IBOutlet UILabel *orderDescriptionLabel;


@end
