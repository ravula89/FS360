//
//  FSAddPartView.h
//  FS360
//
//  Created by BiznusSoft on 11/22/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSAddPartViewDelegate <NSObject>

- (void)deleteActionForButton:(UIButton *)sender;

@end

@interface FSAddPartView : UIView<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *partNumberSearchBar;
@property (strong, nonatomic) IBOutlet UILabel *partName;
@property (strong, nonatomic) IBOutlet UILabel *unusedQuantity;
@property (strong, nonatomic) IBOutlet UITextField *usedQuantity;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *sourceButton;



@property (weak, nonatomic) id<FSAddPartViewDelegate> delegate;



- (void)setUpData:(NSDictionary *)dict;

@end
