//
//  UIImage+Extensions.h
//  Club21
//
//  Created by Edward on 5/4/11.
//  Copyright 2011 codigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Extensions)

+ (UIImage *)imageWithColor:(UIColor *)color;

// rotate UIImage to any angle
- (UIImage*)rotate:(UIImageOrientation)orient;

// rotate and scale image from iphone camera
- (UIImage*)rotateAndScaleFromCameraWithMaxSize:(CGFloat)maxSize;

// scale this image to a given maximum width and height
- (UIImage*)scaleWithMaxSize:(CGFloat)maxSize;
- (UIImage*)scaleWithMaxSize:(CGFloat)maxSize
                     quality:(CGInterpolationQuality)quality;

@end
