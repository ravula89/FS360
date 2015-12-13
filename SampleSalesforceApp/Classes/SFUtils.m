//
//  SFUtils.m
//  FS360
//
//  Created by BiznusSoft on 8/16/15.
//  Copyright (c) 2015 Biznussoft. All rights reserved.
//

#import "SFUtils.h"

@implementation SFUtils

+ (NSString *)getSavedImageForIndex:(NSInteger)index {
    
    NSString* fileName = [NSString stringWithFormat:@"%lilatest_photo.png",(long)index];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* imageFilePath = [path stringByAppendingPathComponent:fileName];
    return imageFilePath;
}

+ (NSString *)getSavedSignatureForIndex:(NSInteger)index {
    
    NSString* fileName = [NSString stringWithFormat:@"%lilatest_signature.png",(long)index];
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* imageFilePath = [path stringByAppendingPathComponent:fileName];
    return imageFilePath;
}
@end
