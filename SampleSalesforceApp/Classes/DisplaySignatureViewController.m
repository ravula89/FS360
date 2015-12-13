//
//  DisplaySignatureViewController.m
//  SignatureSampleApp
//
//  Created by Atif Mohammed on 7/22/15.
//  Copyright (c) 2015 Atif Mohammed. All rights reserved.
//

#import "DisplaySignatureViewController.h"

@interface DisplaySignatureViewController ()

@end

@implementation DisplaySignatureViewController

@synthesize personName;
@synthesize signedBy;
@synthesize mySignatureView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set the title of the navigation view
    [self.navigationItem setTitle:@"Display Signature"];
    
    //create a label to display the name of the person who signed the document
    CGRect myFrame = CGRectMake(10.0f, 0.0f, 300.0f, 30.0f);
    signedBy = [[UILabel alloc] initWithFrame:myFrame];
    signedBy.font = [UIFont boldSystemFontOfSize:16.0f];
    signedBy.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:signedBy];
    
    //get reference to the navigation frame to calculate bar height
    CGRect navigationframe = [[self.navigationController navigationBar] frame];
    int navbarHeight = navigationframe.size.height;
    
    //frame for our signature image
    
//    CGRect imageFrame = CGRectMake(self.view.frame.origin.x+10, 30,
//                                   self.view.frame.size.width-20,
//                                   self.view.frame.size.height-navbarHeight-30);
    
    CGRect imageFrame = CGRectMake(self.view.frame.origin.x+10,
                                   self.view.frame.origin.y+70,
                                   self.view.frame.size.width-20,
                                   self.view.frame.size.height-navbarHeight-400);

    //create an image view to display our signature image
    self.mySignatureView = [[UIImageView alloc] init];
    [self.mySignatureView setFrame:imageFrame];
    [self.mySignatureView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.mySignatureView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //who signed the document
    signedBy.text = [NSString stringWithFormat:@"Signed by: %@", personName];
    
    //create the path to our image file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    NSString *fileName = [filePath stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", personName]];
    
    //get the contents of the image file into the image
    UIImage *signature = [UIImage imageWithContentsOfFile:fileName];
    //display our signature image
    mySignatureView.image = signature;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end