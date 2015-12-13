//
//  SignatureViewController.h
//  MyNativeiOSApp
//
//  Created by BiznusSoft on 7/27/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplaySignatureViewController.h"

@protocol SignatureViewControllerDelegate <NSObject>

- (void)willDisplaySignature:(UIImage *)image;

@end

@interface SignatureViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *mySignatureImage;
@property (nonatomic, assign) CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL fingerMoved;
@property (nonatomic, assign) float navbarHeight;
@property (nonatomic, assign) NSInteger selectedRow;

@property (strong, nonatomic) DisplaySignatureViewController *displaySignatureViewController;

@property (weak , nonatomic) id <SignatureViewControllerDelegate> delegate;


@end
