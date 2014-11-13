//
//  UIView+Screenshot.m
//  SingPost
//
//  Created by Li Le on 30/10/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
