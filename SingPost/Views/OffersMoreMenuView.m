//
//  OffersMoreMenuView.m
//  SingPost
//
//  Created by Edward Soetiono on 13/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "OffersMoreMenuView.h"
#import "UIFont+SingPost.h"

@interface OffersMoreMenuButton : UIButton

@end

@implementation OffersMoreMenuButton

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setTitleColor:RGB(112, 120, 130) forState:UIControlStateNormal];
        [self setTitleColor:RGB(82, 90, 100) forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

@end

@implementation OffersMoreMenuView
{
    UIButton *toggleMenuButton;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:RGB(239, 242, 246)];
        [self setClipsToBounds:NO];
        
        toggleMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleMenuButton setFrame:CGRectMake(110, -5, 110, 44)];
        [toggleMenuButton.titleLabel setFont:[UIFont SingPostLightFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [toggleMenuButton setImage:[UIImage imageNamed:@"offersmore_indicator"] forState:UIControlStateNormal];
        [toggleMenuButton setTitle:@"Offers & More" forState:UIControlStateNormal];
        [toggleMenuButton setTitleColor:RGB(36, 84, 157) forState:UIControlStateNormal];
        [toggleMenuButton setTitleColor:RGB(58, 68, 81) forState:UIControlStateHighlighted];
        [toggleMenuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [toggleMenuButton addTarget:self action:@selector(toggleMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [toggleMenuButton setBackgroundColor:[UIColor clearColor]];
        toggleMenuButton.imageEdgeInsets = UIEdgeInsetsMake(1, 89, 0, 0);
        [self addSubview:toggleMenuButton];
        
        CGFloat offsetY = 32.0f;
        
        UIView *horizontalSeparatorView1 = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, self.bounds.size.width, 0.5f)];
        [horizontalSeparatorView1 setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:horizontalSeparatorView1];
        
        offsetY += 10.0f;
        
        OffersMoreMenuButton *offersButton = [[OffersMoreMenuButton alloc] initWithFrame:CGRectMake(10, offsetY, 140, 42)];
        [offersButton setTag:OFFERSMENUBUTTON_OFFERS];
//        [offersButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [offersButton setTitle:@"Offers" forState:UIControlStateNormal];
        [self addSubview:offersButton];
        
        UIView *separatorMenuView1 = [[UIView alloc] initWithFrame:CGRectMake(floorf(self.bounds.size.width / 2.0f), offsetY, 0.5, 42)];
        [separatorMenuView1 setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:separatorMenuView1];
        
        OffersMoreMenuButton *feedbackButton = [[OffersMoreMenuButton alloc] initWithFrame:CGRectMake(170, offsetY, 140, 42)];
        [feedbackButton setTag:OFFERSMENUBUTTON_FEEDBACK];
        [feedbackButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [feedbackButton setTitle:@"Feedback" forState:UIControlStateNormal];
        [self addSubview:feedbackButton];
        
        offsetY += 52.0f;
        
        UIView *horizontalSeparatorView1A = [[UIView alloc] initWithFrame:CGRectMake(10, offsetY, 145, 0.5f)];
        [horizontalSeparatorView1A setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:horizontalSeparatorView1A];
        
        UIView *horizontalSeparatorView1B = [[UIView alloc] initWithFrame:CGRectMake(165, offsetY, 145, 0.5f)];
        [horizontalSeparatorView1B setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:horizontalSeparatorView1B];
        
        offsetY += 10.0f;
        
        OffersMoreMenuButton *aboutThisAppButton = [[OffersMoreMenuButton alloc] initWithFrame:CGRectMake(10, offsetY, 140, 42)];
        [aboutThisAppButton setTag:OFFERSMENUBUTTON_ABOUTTHISAPP];
        [aboutThisAppButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [aboutThisAppButton setTitle:@"About this App" forState:UIControlStateNormal];
        [self addSubview:aboutThisAppButton];
        
        UIView *separatorMenuView2 = [[UIView alloc] initWithFrame:CGRectMake(floorf(self.bounds.size.width / 2.0f), offsetY, 0.5, 42)];
        [separatorMenuView2 setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:separatorMenuView2];

        OffersMoreMenuButton *termsOfUseButton = [[OffersMoreMenuButton alloc] initWithFrame:CGRectMake(170, offsetY, 140, 42)];
        [termsOfUseButton setTag:OFFERSMENUBUTTON_TERMSOFUSE];
        [termsOfUseButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [termsOfUseButton setTitle:@"Terms of use" forState:UIControlStateNormal];
        [self addSubview:termsOfUseButton];

        offsetY += 52.0f;
        
        UIView *horizontalSeparatorView2A = [[UIView alloc] initWithFrame:CGRectMake(10, offsetY, 145, 0.5f)];
        [horizontalSeparatorView2A setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:horizontalSeparatorView2A];
        
        UIView *horizontalSeparatorView2B = [[UIView alloc] initWithFrame:CGRectMake(165, offsetY, 145, 0.5f)];
        [horizontalSeparatorView2B setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:horizontalSeparatorView2B];
        
        offsetY += 10.0f;
        
        OffersMoreMenuButton *faqButton = [[OffersMoreMenuButton alloc] initWithFrame:CGRectMake(10, offsetY, 140, 42)];
        [faqButton setTag:OFFERSMENUBUTTON_FAQS];
//        [faqButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [faqButton setTitle:@"FAQs" forState:UIControlStateNormal];
        [self addSubview:faqButton];
        
        UIView *separatorMenuView3 = [[UIView alloc] initWithFrame:CGRectMake(floorf(self.bounds.size.width / 2.0f), offsetY, 0.5, 42)];
        [separatorMenuView3 setBackgroundColor:RGB(212, 214, 216)];
        [self addSubview:separatorMenuView3];

        OffersMoreMenuButton *rateOurAppButton = [[OffersMoreMenuButton alloc] initWithFrame:CGRectMake(170, offsetY, 140, 42)];
        [rateOurAppButton setTag:OFFERSMENUBUTTON_RATEOURAPP];
//        [rateOurAppButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rateOurAppButton setTitle:@"Rate our app" forState:UIControlStateNormal];
        [self addSubview:rateOurAppButton];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(toggleMenuButton.frame, point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - IBActions

- (IBAction)toggleMenuButtonClicked:(id)sender
{
    [self.delegate toggleShowOffersMoreMenu];
}

- (IBAction)menuButtonClicked:(id)sender
{
    [self.delegate offersMenuButtonClicked:(tOffersMenuButtons)((UIView *)sender).tag];
}

#pragma mark - Accessors

- (void)setIsShown:(BOOL)inIsShown
{
    _isShown = inIsShown;
    
    UIImageView *indicatorImageView = toggleMenuButton.imageView;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         indicatorImageView.transform = _isShown ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
                     }];
}

@end
