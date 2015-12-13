//
//  DisplaySignatureViewController.h
//  SignatureSampleApp
//
//  Created by Atif Mohammed on 7/22/15.
//  Copyright (c) 2015 Atif Mohammed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplaySignatureViewController : UIViewController
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) UILabel *signedBy;
@property (nonatomic, strong) UIImageView *mySignatureView;


@end
