//
//  ASActionView.m
//  Trac
//
//  Created by srachha on 10/11/14.
//  Copyright (c) 2014 Appshark. All rights reserved.
//

#import "ASActionView.h"

@implementation ASActionView
@synthesize pickerDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setupActionViewWithPickerViewWithFrame:(CGRect)frame target:(id)target title:(NSString *)title;
{
	 
	 [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

	 targetController = (UIViewController *) target;
	 self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:227.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
	 UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:frame];
	 [pickerView setBackgroundColor:[UIColor clearColor]];
	 pickerView.tag = 100;
	 pickerView.delegate = target;
	 pickerView.dataSource = target;
	 self.pickerDelegate = target;
	 [self addSubview:[self setNavbarView:title]];
	 [self setUserInteractionEnabled:YES];
	 [self addSubview:pickerView];

}


- (UIView *)setNavbarView:(NSString *)title
{
	 UINavigationBar *navBar = [[UINavigationBar alloc] init];
	 navBar.tag = 200;
	 CGSize navSize = [navBar sizeThatFits:CGSizeMake(0, 0)];
	 navBar.frame = CGRectMake(0, 0, self.frame.size.width, navSize.height);
    

	 navBar.translucent = YES;
	 navBar.barTintColor = [UIColor colorWithRed:240.0f/255.0f green:227/255.0f blue:166.0f/255.0f alpha:1.0];
	 navBar.tintColor =[UIColor blackColor];
	 
	 UINavigationItem *item = [[UINavigationItem alloc] init];
	 item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(cancelButtonPressed:)];
	 item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
																					style:UIBarButtonItemStylePlain
																				  target:self
																				  action:@selector(doneButtonPressed:)];
	 item.title = title;
	 navBar.items = [NSArray arrayWithObject:item];
	 
	 return navBar;
}



-(void)setupCollectionActionViewViewWithFrame:(CGRect)frame withCollections:(NSArray *)collections target:(UIViewController *)target;
{
	 targetController = target;
	 collectionItems = [[NSMutableArray alloc]initWithArray:collections];
//	 Log(@"%@collections",collectionItems);
	 
	 for (UIButton *btn in collectionItems) {
		  [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//		  Log(@"%@currentTitle",btn.currentTitle);
		  [btn setHidden:YES];
		  
		  }
	 UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	 [closeBtn setTitle:@"X" forState:UIControlStateNormal];
	 closeBtn.frame = CGRectMake(self.frame.size.width/2,80.0f, 20.0f, 20.0f);
	 [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	 [closeBtn addTarget:self action:@selector(closebuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	 [self addSubview:closeBtn];
	 
	 
	 UILabel * statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, closeBtn.frame.origin.y+closeBtn.frame.size.height+10.0f, 300, 30)];
	 [statusLabel setTextAlignment:NSTextAlignmentCenter];
	 [statusLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
	 statusLabel.text = @"please rearrange the position of the icons";
	 [self addSubview:statusLabel];

	 self.alpha = 0.8f;
	 self.backgroundColor = [UIColor whiteColor];
	 
	 [self presentModalActionViewWithFrame:frame];
	 

	 
	 float yOrigin=150;
	 UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, yOrigin, self.frame.size.width, self.frame.size.height-(yOrigin+50))];
	 [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
	 collectionView.backgroundColor = [UIColor clearColor];
	 collectionView.dataSource=self;
	 collectionView.delegate = self;
	 [self addSubview:collectionView];
	 

}


-(void)setupDatePickerWithFrame:(CGRect)frame target:(id)target title:(NSString *)title {
	 
	 [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	 
	 targetController = (UIViewController *) target;
	 self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:227.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
	 UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];
	 [datePicker setBackgroundColor:[UIColor clearColor]];
	 datePicker.tag = 300;
	 [datePicker addTarget:targetController action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
	 self.pickerDelegate = target;
	 [self addSubview:[self setNavbarView:title]];
	 [self setUserInteractionEnabled:YES];
	 [self addSubview:datePicker];

	 
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	 return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	 return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	 
	 UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	 
		  //cell.backgroundColor=[UIColor greenColor];
	 UIButton *button = (UIButton *)[collectionItems objectAtIndex:indexPath.row];
	 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,80.0f, 80.0f)];
	 imageView.image = [button currentImage];
	 [cell.contentView addSubview:imageView];

	 return cell;

}


#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
	 UICollectionViewCell *playingCard = collectionItems[fromIndexPath.item];
	 
	 [collectionItems removeObjectAtIndex:fromIndexPath.item];
	 [collectionItems insertObject:playingCard atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
	 
	 return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
	 
	 return YES;
	 
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//	 Log(@"will begin drag");
	 
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//	 Log(@"did begin drag");
	 
//	 [self.profileImageView setHidden:YES];
	 
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//	 Log(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//	 Log(@"did end drag");
//	 [self.profileImageView setHidden:NO];
}


-(void)presentModalActionViewWithFrame:(CGRect)frame
{
		  [UIView animateWithDuration:20.0f animations:^{
				self.frame = frame;
		  } completion:nil];
	 
}


-(void)closebuttonPressed:(id)sender
{
	 for (UIButton *btn in collectionItems) {
		  [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//		  Log(@"%@currentTitle",btn.currentTitle);
		  [btn setHidden:NO];
		  
	 }

	 [targetController.tabBarController.tabBar setUserInteractionEnabled:YES];
	 [targetController.tabBarController.tabBar setAlpha:1.0f];
	 [self removeFromSuperview];
}

-(void)cancelButtonPressed:(id)sender
{

	 if ([[self viewWithTag:100] isKindOfClass:[UIPickerView class]]) {
		  UIPickerView *pickerView = (UIPickerView *)[self viewWithTag:100];
		  [self hidePickerView];

		  [self.pickerDelegate pickerviewCancelPressed:pickerView];
		  

	 } else {
		  UIDatePicker *pickerView = (UIDatePicker *)[self viewWithTag:300];
		  [self hidePickerView];

		  [self.pickerDelegate pickerviewCancelPressed:pickerView];

	 }
	 

}


-(void)doneButtonPressed:(id)sender
{
	 
	 if ([[self viewWithTag:100] isKindOfClass:[UIPickerView class]]) {
		  UIPickerView *pickerView = (UIPickerView *)[self viewWithTag:100];
		  [self hidePickerView];

		  [self.pickerDelegate pickerviewDonePressed:pickerView];

	 } else {
		  UIDatePicker *pickerView = (UIDatePicker *)[self viewWithTag:300];
		  [self hidePickerView];

		  [self.pickerDelegate pickerviewDonePressed:pickerView];
	 }
	 

}

-(void)hidePickerView
{
	 UINavigationBar *navBar = (UINavigationBar *)[self viewWithTag:200];
	 [navBar removeFromSuperview];
	 if ([[self viewWithTag:100] isKindOfClass:[UIPickerView class]]) {
		  UIPickerView *pickerView = (UIPickerView *)[self viewWithTag:100];
		  [pickerView removeFromSuperview];

	 } else {
		  UIDatePicker *pickerView = (UIDatePicker *)[self viewWithTag:300];
		  [pickerView removeFromSuperview];

	 }
	 [self removeFromSuperview];

}

@end
