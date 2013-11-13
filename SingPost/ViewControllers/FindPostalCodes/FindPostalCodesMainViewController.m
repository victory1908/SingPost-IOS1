//
//  FindPostalCodesMainViewController.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "FindPostalCodesMainViewController.h"
#import "UIFont+SingPost.h"
#import "NavigationBarView.h"
#import "SectionToggleButton.h"
#import "UIView+Position.h"

#import "FindPostalCodeLandmarkViewController.h"
#import "FindPostalCodePOBoxViewController.h"
#import "FindPostalCodeStreetViewController.h"

@interface FindPostalCodesMainViewController ()

@end

typedef enum  {
    FINDPOSTALCODES_SECTION_STREET,
    FINDPOSTALCODES_SECTION_LANDMARK,
    FINDPOSTALCODES_SECTION_POBOX
} tFindPostalCodesSections;

@implementation FindPostalCodesMainViewController
{
    tFindPostalCodesSections currentSection;
    SectionToggleButton *streetSectionButton, *landmarkSectionButton, *poBoxSectionButton;
    UIButton *selectedSectionIndicatorButton;
    UIScrollView *sectionContentScrollView;
    
    FindPostalCodeLandmarkViewController *landmarkViewController;
    FindPostalCodePOBoxViewController *poBoxViewController;
    FindPostalCodeStreetViewController *streetViewController;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Find Postal Codes"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, 0.5f)];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 93.5, contentView.bounds.size.width, 0.5f)];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:bottomSeparatorView];
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 96, contentView.bounds.size.width, contentView.bounds.size.height - 96)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentView addSubview:sectionContentScrollView];
    
    streetViewController = [[FindPostalCodeStreetViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:streetViewController];
    [streetViewController.view setFrame:CGRectMake(FINDPOSTALCODES_SECTION_STREET * contentView.bounds.size.width, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:streetViewController.view];
    [streetViewController didMoveToParentViewController:self];
    
    landmarkViewController = [[FindPostalCodeLandmarkViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:landmarkViewController];
    [landmarkViewController.view setFrame:CGRectMake(FINDPOSTALCODES_SECTION_LANDMARK * contentView.bounds.size.width, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:landmarkViewController.view];
    [landmarkViewController didMoveToParentViewController:self];

    poBoxViewController = [[FindPostalCodePOBoxViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:poBoxViewController];
    [poBoxViewController.view setFrame:CGRectMake(FINDPOSTALCODES_SECTION_POBOX * contentView.bounds.size.width, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:poBoxViewController.view];
    [poBoxViewController didMoveToParentViewController:self];

    streetSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(0, 44.5, 107, 49.5)];
    [streetSectionButton setTag:FINDPOSTALCODES_SECTION_STREET];
    [streetSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [streetSectionButton setTitle:@"Street" forState:UIControlStateNormal];
    [contentView addSubview:streetSectionButton];
    
    landmarkSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(106.5, 44.5, 108, 49.5)];
    [landmarkSectionButton setTag:FINDPOSTALCODES_SECTION_LANDMARK];
    [landmarkSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [landmarkSectionButton setTitle:@"Landmark" forState:UIControlStateNormal];
    [contentView addSubview:landmarkSectionButton];
    
    poBoxSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(214, 44.5, 106.5, 49.5)];
    [poBoxSectionButton setTag:FINDPOSTALCODES_SECTION_POBOX];
    [poBoxSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [poBoxSectionButton setTitle:@"PO Box" forState:UIControlStateNormal];
    [contentView addSubview:poBoxSectionButton];
    
    selectedSectionIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedSectionIndicatorButton setBackgroundColor:RGB(36, 84, 157)];
    [selectedSectionIndicatorButton.titleLabel setFont:[UIFont SingPostBoldFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
    [selectedSectionIndicatorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedSectionIndicatorButton setFrame:streetSectionButton.frame];
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
    [self goToSection:FINDPOSTALCODES_SECTION_STREET];
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
        if (CGRectContainsPoint(streetSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:FINDPOSTALCODES_SECTION_STREET];
        else if (CGRectContainsPoint(landmarkSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:FINDPOSTALCODES_SECTION_LANDMARK];
        else if (CGRectContainsPoint(poBoxSectionButton.frame, gestureRecognizer.view.center))
            [self goToSection:FINDPOSTALCODES_SECTION_POBOX];
    }
    else {
        if (CGRectContainsPoint(streetSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Street" forState:UIControlStateNormal];
        else if (CGRectContainsPoint(landmarkSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"Landmark" forState:UIControlStateNormal];
        else if (CGRectContainsPoint(poBoxSectionButton.frame, gestureRecognizer.view.center))
            [selectedSectionIndicatorButton setTitle:@"PO Box" forState:UIControlStateNormal];
    }
}

- (void)goToSection:(tFindPostalCodesSections)section
{
    currentSection = section;
    
    if (currentSection == FINDPOSTALCODES_SECTION_STREET)
        [selectedSectionIndicatorButton setTitle:@"Street" forState:UIControlStateNormal];
    else if (currentSection == FINDPOSTALCODES_SECTION_LANDMARK)
        [selectedSectionIndicatorButton setTitle:@"Landmark" forState:UIControlStateNormal];
    else if (currentSection == FINDPOSTALCODES_SECTION_POBOX)
        [selectedSectionIndicatorButton setTitle:@"PO Box" forState:UIControlStateNormal];
    
    [sectionContentScrollView setContentOffset:CGPointMake(currentSection * sectionContentScrollView.bounds.size.width, 0) animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        if (currentSection == FINDPOSTALCODES_SECTION_STREET)
            [selectedSectionIndicatorButton setFrame:streetSectionButton.frame];
        else if (currentSection == FINDPOSTALCODES_SECTION_LANDMARK)
            [selectedSectionIndicatorButton setFrame:landmarkSectionButton.frame];
        else if (currentSection == FINDPOSTALCODES_SECTION_POBOX)
            [selectedSectionIndicatorButton setFrame:poBoxSectionButton.frame];
    }];
}

#pragma mark - IBActions

- (IBAction)sectionButtonClicked:(id)sender
{
    if (sender == streetSectionButton)
        [self goToSection:FINDPOSTALCODES_SECTION_STREET];
    else if (sender == landmarkSectionButton)
        [self goToSection:FINDPOSTALCODES_SECTION_LANDMARK];
    else if (sender == poBoxSectionButton)
        [self goToSection:FINDPOSTALCODES_SECTION_POBOX];
}

- (void)resignAllResponders
{
    [sectionContentScrollView endEditing:YES];
    [poBoxViewController.view endEditing:YES];
    [streetViewController.view endEditing:YES];
    [landmarkViewController.view endEditing:YES];
}

@end
