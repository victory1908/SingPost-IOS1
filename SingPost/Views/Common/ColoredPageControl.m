//
//  ColoredPageControl.m
//  WanBao
//
//  Created by Edward Soetiono on 20/12/12.
//  Copyright (c) 2012 SPH. All rights reserved.
//

#import "ColoredPageControl.h"

@implementation ColoredPageControl

- (void)setCurrentPage:(NSInteger)inPage
{
    _currentPage = MIN(MAX(0, inPage), _numberOfPages - 1);
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor blackColor];
        self.dotColorOtherPage = [UIColor lightGrayColor];
        self.dotDiameter = 7.0f;
        self.dotSpacer = 7.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
	
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages * self.dotDiameter + MAX(0, self.numberOfPages-1) * self.dotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds) - self.dotDiameter/2;
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, self.dotDiameter, self.dotDiameter);
        if (i == _currentPage)
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        else
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);

        CGContextSetStrokeColorWithColor(context, self.dotColorOtherPage.CGColor) ;
        CGContextStrokeEllipseInRect(context, circleRect) ;
        CGContextFillEllipseInRect(context, circleRect);
       
        x += self.dotDiameter + self.dotSpacer;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	
    CGFloat dotSpanX = self.numberOfPages * (self.dotDiameter + self.dotSpacer);
    CGFloat dotSpanY = self.dotDiameter + self.dotSpacer;
	
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
	
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
	
    self.currentPage = floor(x/(self.dotDiameter+self.dotSpacer));
    if ([self.delegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.delegate pageControlPageDidChange:self];
    }
}

@end
