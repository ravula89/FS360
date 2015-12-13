//
//  FSAddPartView.m
//  FS360
//
//  Created by BiznusSoft on 11/22/15.
//  Copyright © 2015 Biznussoft. All rights reserved.
//

#import "FSAddPartView.h"

@interface FSAddPartView ()<UISearchBarDelegate>

@end

@implementation FSAddPartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setUpData:(NSDictionary *)dict  {
    
    NSLog(@"Dict is %@",dict);
    
    _partNumberSearchBar.text = [dict valueForKey:@"Part_Number__c"];
    _partName.text = [dict valueForKey:@"Part_Number__c"];
    _usedQuantity.text = [dict valueForKey:@"Quantity__c"];
    _unusedQuantity.text = [dict valueForKey:@"Quantity__c"];
    [_sourceButton setTitle:[dict valueForKey:@"Source__c"] forState:UIControlStateNormal];
    _deleteButton.tag = self.tag;
    _partNumberSearchBar.tag = self.tag;
    _partNumberSearchBar.delegate = self;
}


- (IBAction)deleteButtonAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteActionForButton:)]) {
        [_delegate deleteActionForButton:_deleteButton];
    }
    
}

- (IBAction)sourceBtnAction:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Central", @"Customer", @"Distributer", @"Other", nil];
    
    [actionSheet showFromRect:CGRectMake(_sourceButton.frame.origin.x, _sourceButton.frame.origin.y+_sourceButton.frame.size.height, 75, 150) inView:self animated:YES];
    
    //    actionSheet.frame = CGRectMake(520, 45, 75, 150);
    
    [actionSheet showInView:self];
    
}


#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Central"]) {
        
        [_sourceButton setTitle:@"Central" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"Customer"]) {
        
        [_sourceButton setTitle:@"Customer" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"Distributer"]) {
        
        [_sourceButton setTitle:@"Distributer" forState:UIControlStateNormal];
    }
    if ([buttonTitle isEqualToString:@"Other"]) {
        
        [_sourceButton setTitle:@"Other" forState:UIControlStateNormal];
    }
    
}




@end
