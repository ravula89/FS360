//
//  FSAddNewPartView.h
//  FS360
//
//  Created by BiznusSoft on 11/30/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FSAddNewPartViewDelegate <NSObject>


-(void)addProductdeleteActionForButton:(UIButton *)sender;


@end

@interface FSAddNewPartView : UIView

//Added Add Parts here

@property (strong, nonatomic) IBOutlet UISearchBar *addProductPartNumberSearchBar;

@property (strong, nonatomic) IBOutlet UILabel *addProductName;

@property (strong, nonatomic) IBOutlet UITextField *addProductQuantity;


@property (strong, nonatomic) IBOutlet UIButton *addProductDeleteButton;

@property (weak, nonatomic) id<FSAddNewPartViewDelegate> delegate;

- (void)setUpAddNewData:(NSDictionary *)dict;

@end
