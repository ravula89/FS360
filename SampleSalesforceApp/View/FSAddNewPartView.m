//
//  FSAddNewPartView.m
//  FS360
//
//  Created by BiznusSoft on 11/30/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import "FSAddNewPartView.h"

@interface FSAddNewPartView ()<UISearchBarDelegate>

@end
@implementation FSAddNewPartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setUpAddNewData:(NSDictionary *)dict  {
    
    NSLog(@"Dict is %@",dict);
        //add parts added here
    
        _addProductPartNumberSearchBar.text=[dict valueForKey:@""];
        _addProductName.text=[dict valueForKey:@""];
        _addProductQuantity.text=[dict valueForKey:@""];
        _addProductDeleteButton.tag=self.tag;
        _addProductPartNumberSearchBar.tag=self.tag;
        _addProductPartNumberSearchBar.delegate=self;
    
}



- (IBAction)addProductDeleteButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addProductdeleteActionForButton:)]) {
        [self.delegate addProductdeleteActionForButton:self.addProductDeleteButton];
    }
    
}


@end
