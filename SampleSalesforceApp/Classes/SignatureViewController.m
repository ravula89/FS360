//
//  SignatureViewController.m
//  MyNativeiOSApp
//
//  Created by BiznusSoft on 7/27/15.
//  Copyright (c) 2015 company. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()

@end

@implementation SignatureViewController
@synthesize mySignatureImage;
@synthesize lastContactPoint1, lastContactPoint2, currentPoint;
@synthesize imageFrame;
@synthesize fingerMoved;
@synthesize navbarHeight;
@synthesize displaySignatureViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor purpleColor];

    
    //get reference to the navigation frame to calculate navigation bar height
    CGRect navigationframe = [[self.navigationController navigationBar] frame];
    navbarHeight = navigationframe.size.height;
    
    //create a frame for our signature capture based on whats remaining
    imageFrame = CGRectMake(100,100,self.view.frame.size.width-20,self.view.frame.size.height-400);
    
    //allocate an image view and add to the main view
    mySignatureImage = [[UIImageView alloc] initWithImage:nil];
    mySignatureImage.frame = imageFrame;
    mySignatureImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mySignatureImage];
    
    UIButton * saveSigBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveSigBtn addTarget:self
                     action:@selector(saveSignature:)
           forControlEvents:UIControlEventTouchUpInside];
    [saveSigBtn setTitle:@"Save" forState:UIControlStateNormal];
    saveSigBtn.frame = CGRectMake(100, self.view.frame.size.height-300, 100, 40.0);
    //    savePhotoBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:saveSigBtn];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancel addTarget:self
                   action:@selector(cancelSignature:)
         forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(saveSigBtn.frame.origin.x+100, self.view.frame.size.height-300, 100, 40.0);
    //    savePhotoBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:cancel];


    // Do any additional setup after loading the view from its nib.
}

//save button was clicked, its time to save the signature
- (void) saveSignature:(id)sender {
    
    
    if (mySignatureImage.image == nil) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"No Signature" message:@"No Signature to Save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
    }

    
    //get reference to the button that requested the action
    UIButton *myButton = (UIButton *)sender;
    
    //check which button it is, if you have more than one button on the screen
    //you must check before taking necessary action
    if([myButton.titleLabel.text isEqualToString:@"Save"]){
        NSLog(@"Clicked on the bar button");
        
        [self saveSignatureImage];
        
        //display an alert to capture the person's name
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saving signature with name"
//                                                            message:@"Please enter your name"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Ok", nil];
//        alertView.tag = 1;
//        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        [alertView show];
    }
    
}

- (void) cancelSignature:(id)sender {
    
    mySignatureImage.image = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




//when one or more fingers touch down in a view or window
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //did our finger moved yet?
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        mySignatureImage.image = nil;
        return;
    }
    
    //we need 3 points of contact to make our signature smooth using quadratic bezier curve
    currentPoint = [touch locationInView:mySignatureImage];
    lastContactPoint1 = [touch previousLocationInView:mySignatureImage];
    lastContactPoint2 = [touch previousLocationInView:mySignatureImage];
    
}

//when one or more fingers associated with an event move within a view or window
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //well its obvious that our finger moved on the screen
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    //save previous contact locations
    lastContactPoint2 = lastContactPoint1;
    lastContactPoint1 = [touch previousLocationInView:mySignatureImage];
    //save current location
    currentPoint = [touch locationInView:mySignatureImage];
    
    //find mid points to be used for quadratic bezier curve
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    //create a bitmap-based graphics context and makes it the current context
    UIGraphicsBeginImageContext(imageFrame.size);
    
    //draw the entire image in the specified rectangle frame
    [mySignatureImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
    
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //begin a new new subpath at this point
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midPoint1.x, midPoint1.y);
    //create quadratic Bézier curve from the current point using a control point and an end point
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                                 lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    //set the miter limit for the joins of connected lines in a graphics context
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    //paint a line along the current path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //set the image based on the contents of the current bitmap-based graphics context
    mySignatureImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
    //lastContactPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        mySignatureImage.image = nil;
        return;
    }
    
    //if the finger never moved draw a point
    if(!fingerMoved) {
        
        UIGraphicsBeginImageContext(imageFrame.size);
        [mySignatureImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        mySignatureImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

//calculate midpoint between two points
- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

//some action was taken on the alert view
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //user wants to save the signature now
    if (alertView.tag == 1){
        NSLog(@"Ok button was pressed.");
        NSLog(@"Name of the person is: %@", [[alertView textFieldAtIndex:0] text]);
        NSString * personName = [[alertView textFieldAtIndex:0] text];
        
        //create path to where we want the image to be saved
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
       // NSLog(@"Signatur File Path: %@",filePath);
        //if the folder doesn't exists then just create one
//        NSError *error = nil;
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            [[NSFileManager defaultManager] createDirectoryAtPath:filePath
//                                      withIntermediateDirectories:NO
//                                                       attributes:nil
//                                                            error:&error];
//        
//        //convert image into .png format.
      NSData *imageData = UIImagePNGRepresentation(mySignatureImage.image);
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@latest_signature.png", personName]];
        
        //creates an image file with the specified content and attributes at the given location
        [fileManager createFileAtPath:fileName contents:imageData attributes:nil];
        NSLog(@"image saved");
        [self showAlertView];
        
        //check if the display signature view controller doesn't exists then create it
        if(self.displaySignatureViewController == nil) {
            
//            DisplaySignatureViewController *displayView = [[DisplaySignatureViewController alloc] init];
//            self.displaySignatureViewController = displayView;
        }
    }
    else if (alertView.tag == 2){
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(willDisplaySignature:)]) {
            [_delegate willDisplaySignature:mySignatureImage.image];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
       
    }
    
}


- (void)saveSignatureImage {
    
    //create path to where we want the image to be saved
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    // NSLog(@"Signatur File Path: %@",filePath);
    //if the folder doesn't exists then just create one
    //        NSError *error = nil;
    //        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    //            [[NSFileManager defaultManager] createDirectoryAtPath:filePath
    //                                      withIntermediateDirectories:NO
    //                                                       attributes:nil
    //                                                            error:&error];
    //
    //        //convert image into .png format.
    NSData *imageData = UIImagePNGRepresentation(mySignatureImage.image);
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%lilatest_signature.png",(long)_selectedRow]];
    
    //creates an image file with the specified content and attributes at the given location
    [fileManager createFileAtPath:fileName contents:imageData attributes:nil];
    NSLog(@"image saved");
    [self showAlertView];
    
    //check if the display signature view controller doesn't exists then create it
    if(self.displaySignatureViewController == nil) {
        
        //            DisplaySignatureViewController *displayView = [[DisplaySignatureViewController alloc] init];
        //            self.displaySignatureViewController = displayView;
    }
}

- (void)showAlertView {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saving signature" message:@"Image Saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    alertView.tag = 2;
    
    [alertView show];
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
