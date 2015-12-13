//
//  ASActionView.h
//  Trac
//
//  Created by srachha on 10/11/14.
//  Copyright (c) 2014 Appshark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pickerViewDelegate1<NSObject>

@required
-(void)pickerviewDonePressed:(id)pickeview;
-(void)pickerviewCancelPressed:(id)pickerview;

@end
@interface ASActionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate >
{
	 NSMutableArray * collectionItems;
	 UIViewController *targetController;
	 NSObject <pickerViewDelegate1> *pickerDelegate;
}
@property(nonatomic,retain)	 NSObject <pickerViewDelegate1> *pickerDelegate;


-(void)setupActionViewWithPickerViewWithFrame:(CGRect)frame target:(id)target title:(NSString *)title;
-(void)setupCollectionActionViewViewWithFrame:(CGRect)frame withCollections:(NSArray *)collections target:(UIViewController *)target;
-(void)setupDatePickerWithFrame:(CGRect)frame target:(id)target title:(NSString *)title;

-(void)presentModalActionViewWithFrame:(CGRect)frame;
-(void)doneButtonPressed:(id)sender;
-(void)cancelButtonPressed:(id)sender;

@end
