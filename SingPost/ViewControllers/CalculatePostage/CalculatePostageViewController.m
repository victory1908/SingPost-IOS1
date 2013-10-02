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
#import "CalculatePostageResultsViewController.h"
#import "AppDelegate.h"
#import "SectionToggleButton.h"
#import "UIView+Position.h"

@interface CalculatePostageViewController () <CalculatePostageOverseasDelegate, CalculatePostageSingaporeDelegate>

@end

typedef enum  {
    CALCULATEPOSTAGE_SECTION_OVERSEAS,
    CALCULATEPOSTAGE_SECTION_SINGAPORE
} tCalculatePostageSections;

@implementation CalculatePostageViewController
{
    tCalculatePostageSections currentSection;
    SectionToggleButton *overseasSectionButton, *singaporeSectionButton;
    CalculatePostageOverseasView *overseasSectionView;
    CalculatePostageSingaporeView *singaporeSectionView;
    UIScrollView *sectionContentScrollView;
    UIButton *selectedSectionIndicatorButton;
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
    [overseasSectionView setDelegate:self];
    [overseasSectionView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView addSubview:overseasSectionView];
    
    singaporeSectionView = [[CalculatePostageSingaporeView alloc] initWithFrame:CGRectMake(contentView.bounds.size.width * CALCULATEPOSTAGE_SECTION_SINGAPORE, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [singaporeSectionView setDelegate:self];
    [singaporeSectionView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView addSubview:singaporeSectionView];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 139, contentView.bounds.size.width, 1)];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, contentView.bounds.size.width, 1)];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:bottomSeparatorView];
    
    overseasSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(0, 140, contentView.bounds.size.width / 2.0f, 50)];
    [overseasSectionButton setTag:CALCULATEPOSTAGE_SECTION_OVERSEAS];
    [overseasSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [overseasSectionButton setTitle:@"Overseas" forState:UIControlStateNormal];
    [overseasSectionButton setSelected:NO];
    [contentView addSubview:overseasSectionButton];
    
    singaporeSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(contentView.bounds.size.width / 2.0f, 140, contentView.bounds.size.width / 2.0f, 50)];
    [singaporeSectionButton setTag:CALCULATEPOSTAGE_SECTION_SINGAPORE];
    [singaporeSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singaporeSectionButton setTitle:@"Singapore" forState:UIControlStateNormal];
    [singaporeSectionButton setSelected:NO];
    [contentView addSubview:singaporeSectionButton];
    
    selectedSectionIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedSectionIndicatorButton setBackgroundColor:RGB(36, 84, 157)];
    [selectedSectionIndicatorButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [selectedSectionIndicatorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedSectionIndicatorButton setFrame:overseasSectionButton.frame];
    [contentView addSubview:selectedSectionIndicatorButton];
    
    UIImageView *selectedIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_indicator"]];
    [selectedIndicatorImageView setFrame:CGRectMake((int)(selectedSectionIndicatorButton.bounds.size.width / 2) - 8, selectedSectionIndicatorButton.bounds.size.height, 17, 8)];
    [selectedSectionIndicatorButton addSubview:selectedIndicatorImageView];
    
    UIPanGestureRecognizer *sectionSelectionPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSectionSelectionPanGesture:)];
    [selectedSectionIndicatorButton addGestureRecognizer:sectionSelectionPanGestureRecognizer];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self goToSection:CALCULATEPOSTAGE_SECTION_OVERSEAS];
}

- (void)handleSectionSelectionPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y);
    [gestureRecognizer.view setX:MIN(MAX(0, gestureRecognizer.view.frame.origin.x), self.view.bounds.size.width - gestureRecognizer.view.bounds.size.width)];
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self resignAllResponders];;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(overseasSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:CALCULATEPOSTAGE_SECTION_OVERSEAS];
        else if (CGRectContainsPoint(singaporeSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:CALCULATEPOSTAGE_SECTION_SINGAPORE];
    }
    else {
        if (CGRectContainsPoint(overseasSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Overseas" forState:UIControlStateNormal];
        else if (CGRectContainsPoint(singaporeSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Singapore" forState:UIControlStateNormal];
    }
}

- (void)goToSection:(tCalculatePostageSections)section
{
    currentSection = section;
    
    if (currentSection == CALCULATEPOSTAGE_SECTION_OVERSEAS)
        [selectedSectionIndicatorButton setTitle:@"Overseas" forState:UIControlStateNormal];
    else if (currentSection == CALCULATEPOSTAGE_SECTION_SINGAPORE)
        [selectedSectionIndicatorButton setTitle:@"Singapore" forState:UIControlStateNormal];
    
    [sectionContentScrollView setContentOffset:CGPointMake(currentSection * sectionContentScrollView.bounds.size.width, 0) animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        if (currentSection == CALCULATEPOSTAGE_SECTION_OVERSEAS)
            [selectedSectionIndicatorButton setFrame:overseasSectionButton.frame];
        else if (currentSection == CALCULATEPOSTAGE_SECTION_SINGAPORE)
            [selectedSectionIndicatorButton setFrame:singaporeSectionButton.frame];
    }];
}


#pragma mark - Section Delegates

- (void)calculatePostageOverseas:(CalculatePostageOverseasView *)sender
{
    CalculatePostageResultsViewController *viewController = [[CalculatePostageResultsViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

- (void)calculatePostageSingapore:(CalculatePostageSingaporeView *)sender
{
    CalculatePostageResultsViewController *viewController = [[CalculatePostageResultsViewController alloc] initWithNibName:nil bundle:nil];
    [[AppDelegate sharedAppDelegate].rootViewController cPushViewController:viewController];
}

#pragma mark - IBActions

- (IBAction)sectionButtonClicked:(id)sender
{
    if (sender == overseasSectionButton)
        [self goToSection:CALCULATEPOSTAGE_SECTION_OVERSEAS];
    else if (sender == singaporeSectionButton)
        [self goToSection:CALCULATEPOSTAGE_SECTION_SINGAPORE];
}

#pragma mark -

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
