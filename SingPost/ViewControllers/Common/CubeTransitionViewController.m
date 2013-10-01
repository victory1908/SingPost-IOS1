//
//  CubeTransitionViewController.m
//  WanBao
//
//  Created by Edward Soetiono on 15/3/13.
//  Copyright (c) 2013 SPH. All rights reserved.
//

#import "CubeTransitionViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CubeTransitionViewController

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        for (UIViewController *viewController in [viewControllers reverseObjectEnumerator])
        {
            [self addChildViewController:viewController];
            [viewController.view setFrame:self.view.bounds];
            [self.view addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
    }
    return self;
}

- (UIImage *)screenShot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextFillRect (UIGraphicsGetCurrentContext(), self.view.frame);
    UIGraphicsEndImageContext();

    return image;
}

- (CALayer *)createLayerFromView: (UIView *) aView transform:(CATransform3D) transform
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.anchorPoint = CGPointMake(1.0f, 1.0f);
    imageLayer.frame = (CGRect){.size = self.view.frame.size};
    imageLayer.transform = transform;
    UIImage *shot = [self screenShot:aView];
    imageLayer.contents = (__bridge id) shot.CGImage;
    
    return imageLayer;
}

- (void)animateFromCurrent:(UIViewController *)current toNext:(UIViewController *)next forward:(BOOL)forward onCompletion:(void(^)())completion
{
    CALayer *transformationLayer = [CALayer layer];
    transformationLayer.shouldRasterize = YES;
    transformationLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    transformationLayer.frame = self.view.bounds;
    transformationLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -1000;
    [transformationLayer setSublayerTransform:sublayerTransform];
    [self.view.layer addSublayer:transformationLayer];
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 0);
    [transformationLayer addSublayer:[self createLayerFromView:current.view transform:transform]];
    
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    transform = CATransform3DTranslate(transform, self.view.frame.size.width, 0, 0);
    if (!forward)
    {
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        transform = CATransform3DTranslate(transform, self.view.frame.size.width, 0, 0);
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        transform = CATransform3DTranslate(transform, self.view.frame.size.width, 0, 0);
    }
    
    [transformationLayer addSublayer:[self createLayerFromView:next.view transform:transform]];
    
    [current.view removeFromSuperview];
    [next.view removeFromSuperview];
    
    //start rotation animation
    [CATransaction begin];
    [CATransaction setCompletionBlock:^(void) {
        [self.view addSubview:next.view];
        [transformationLayer removeFromSuperlayer];
        completion();
    }];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.4f;
    
    CGFloat halfWidth = self.view.frame.size.width / 2.0f;
    float multiplier = forward ? -1.0f : 1.0f;
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.x"];
    translationX.toValue = [NSNumber numberWithFloat:multiplier * halfWidth];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.z"];
    translationZ.toValue = [NSNumber numberWithFloat:-halfWidth];
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
    rotationY.toValue = [NSNumber numberWithFloat: multiplier * M_PI_2];
    
    group.animations = [NSArray arrayWithObjects: rotationY, translationX, translationZ, nil];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [CATransaction flush];
    [transformationLayer addAnimation:group forKey:@"TransitionViewAnimation"];
}

@end
