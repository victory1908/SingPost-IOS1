//
//  CalculatePostageViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 28/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageViewController.h"
#import "NavigationBarView.h"
#import "UIFont+SingPost.h"
#import "CalculatePostageSingaporeView.h"
#import "CalculatePostageOverseasView.h"

@interface CalculatePostageToggleButton : UIButton

@end

@implementation CalculatePostageToggleButton
{
    UIImageView *selectedIndicatorImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        
        selectedIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_indicator"]];
        [selectedIndicatorImageView setFrame:CGRectMake(70, self.bounds.size.height, 17, 8)];
        [self addSubview:selectedIndicatorImageView];
        
        [self setSelected:NO];
    }
    
    return self;
}
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
        [self.titleLabel setTextColor:[UIColor darkGrayColor]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [self setBackgroundColor:RGB(36, 84, 157)];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [selectedIndicatorImageView setHidden:NO];
    }
    else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:RGB(36, 84, 157)];
        [selectedIndicatorImageView setHidden:YES];
    }
}

@end

@interface CalculatePostageViewController ()

@end

typedef enum  {
    CALCULATEPOSTAGE_SECTION_OVERSEAS,
    CALCULATEPOSTAGE_SECTION_SINGAPORE
} tCalculatePostageSections;

@implementation CalculatePostageViewController
{
    tCalculatePostageSections currentSection;
    CalculatePostageToggleButton *overseasSectionButton, *singaporeSectionButton;
    CalculatePostageOverseasView *overseasSectionView;
    CalculatePostageSingaporeView *singaporeSectionView;
    UIScrollView *sectionContentScrollView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(240, 240, 240)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Calculate Postage"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, contentView.bounds.size.width - 30, 60)];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setText:@"Lorem ipstum dolor amet, consectetur adipiscing elit. Cras metus massa, lacinia et neque vel, feugiat condimentum odio."];
    [instructionsLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:instructionsLabel];
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 190, contentView.bounds.size.width, contentView.bounds.size.height - 190)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentView addSubview:sectionContentScrollView];
    
    overseasSectionView = [[CalculatePostageOverseasView alloc] initWithFrame:CGRectMake(contentView.bounds.size.width * CALCULATEPOSTAGE_SECTION_OVERSEAS, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [overseasSectionView setUserInteractionEnabled:YES];
    [overseasSectionView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView addSubview:overseasSectionView];
    
    singaporeSectionView = [[CalculatePostageSingaporeView alloc] initWithFrame:CGRectMake(contentView.bounds.size.width * CALCULATEPOSTAGE_SECTION_SINGAPORE, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [singaporeSectionView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView addSubview:singaporeSectionView];
    
    overseasSectionButton = [[CalculatePostageToggleButton alloc] initWithFrame:CGRectMake(0, 140, contentView.bounds.size.width / 2.0f, 50)];
    [overseasSectionButton setTag:CALCULATEPOSTAGE_SECTION_OVERSEAS];
    [overseasSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [overseasSectionButton setTitle:@"Overseas" forState:UIControlStateNormal];
    [overseasSectionButton setSelected:YES];
    [contentView addSubview:overseasSectionButton];
    
    singaporeSectionButton = [[CalculatePostageToggleButton alloc] initWithFrame:CGRectMake(contentView.bounds.size.width / 2.0f, 140, contentView.bounds.size.width / 2.0f, 50)];
    [singaporeSectionButton setTag:CALCULATEPOSTAGE_SECTION_SINGAPORE];
    [singaporeSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singaporeSectionButton setTitle:@"Singapore" forState:UIControlStateNormal];
    [singaporeSectionButton setSelected:NO];
    [contentView addSubview:singaporeSectionButton];
     
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)sectionButtonClicked:(id)sender
{
    [overseasSectionButton setSelected:(overseasSectionButton == sender)];
    [singaporeSectionButton setSelected:(singaporeSectionButton == sender)];
    
    [self resignAllResponders];
    
    currentSection = ((UIButton *)sender).tag;
    [sectionContentScrollView setContentOffset:CGPointMake(currentSection * sectionContentScrollView.bounds.size.width, 0) animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self resignAllResponders];
}

- (void)resignAllResponders
{
    [sectionContentScrollView endEditing:YES];
    [overseasSectionView endEditing:YES];
    [singaporeSectionView endEditing:YES];
}

@end
