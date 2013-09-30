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

#import "FindPostalCodeStreetView.h"
#import "FindPostalCodeLandmarkView.h"
#import "FindPostalCodePOBoxView.h"

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
    UIScrollView *sectionContentScrollView;
    FindPostalCodeStreetView *streetSectionView;
    FindPostalCodeLandmarkView *landmarkSectionView;
    FindPostalCodePOBoxView *poBoxSectionView;
}

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [contentView setBackgroundColor:RGB(250, 250, 250)];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc] initWithFrame:NAVIGATIONBAR_FRAME];
    [navigationBarView setTitle:@"Find Postal Codes"];
    [navigationBarView setShowSidebarToggleButton:YES];
    [contentView addSubview:navigationBarView];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, 1)];
    [topSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 95, contentView.bounds.size.width, 1)];
    [bottomSeparatorView setBackgroundColor:RGB(196, 197, 200)];
    [contentView addSubview:bottomSeparatorView];
    
    sectionContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 96, contentView.bounds.size.width, contentView.bounds.size.height - 96)];
    [sectionContentScrollView setBackgroundColor:[UIColor clearColor]];
    [sectionContentScrollView setDelaysContentTouches:NO];
    [sectionContentScrollView setPagingEnabled:YES];
    [sectionContentScrollView setScrollEnabled:NO];
    [contentView addSubview:sectionContentScrollView];
    
    streetSectionView = [[FindPostalCodeStreetView alloc] initWithFrame:CGRectMake(FINDPOSTALCODES_SECTION_STREET * contentView.bounds.size.width, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:streetSectionView];
    
    landmarkSectionView = [[FindPostalCodeLandmarkView alloc] initWithFrame:CGRectMake(FINDPOSTALCODES_SECTION_LANDMARK * contentView.bounds.size.width, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:landmarkSectionView];
    
    poBoxSectionView = [[FindPostalCodePOBoxView alloc] initWithFrame:CGRectMake(FINDPOSTALCODES_SECTION_POBOX * contentView.bounds.size.width, 0, sectionContentScrollView.bounds.size.width, sectionContentScrollView.bounds.size.height)];
    [sectionContentScrollView addSubview:poBoxSectionView];
    
    streetSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(0, 45, 107, 50)];
    [streetSectionButton setTag:FINDPOSTALCODES_SECTION_STREET];
    [streetSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [streetSectionButton setTitle:@"Street" forState:UIControlStateNormal];
    [streetSectionButton setSelected:YES];
    [contentView addSubview:streetSectionButton];
    
    landmarkSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(107, 45, 107, 50)];
    [landmarkSectionButton setTag:FINDPOSTALCODES_SECTION_LANDMARK];
    [landmarkSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [landmarkSectionButton setTitle:@"Landmark" forState:UIControlStateNormal];
    [landmarkSectionButton setSelected:NO];
    [contentView addSubview:landmarkSectionButton];
    
    poBoxSectionButton = [[SectionToggleButton alloc] initWithFrame:CGRectMake(214, 45, 108, 50)];
    [poBoxSectionButton setTag:FINDPOSTALCODES_SECTION_POBOX];
    [poBoxSectionButton addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [poBoxSectionButton setTitle:@"PO Box" forState:UIControlStateNormal];
    [poBoxSectionButton setSelected:NO];
    [contentView addSubview:poBoxSectionButton];
    
    self.view = contentView;
}

#pragma mark - IBActions

- (IBAction)sectionButtonClicked:(id)sender
{
    [streetSectionButton setSelected:(streetSectionButton == sender)];
    [landmarkSectionButton setSelected:(landmarkSectionButton == sender)];
    [poBoxSectionButton setSelected:(poBoxSectionButton == sender)];
    
    [self resignAllResponders];
    
    currentSection = ((UIButton *)sender).tag;
    [sectionContentScrollView setContentOffset:CGPointMake(currentSection * sectionContentScrollView.bounds.size.width, 0) animated:YES];
}

- (void)resignAllResponders
{
    [sectionContentScrollView endEditing:YES];
    [streetSectionView endEditing:YES];
    [landmarkSectionView endEditing:YES];
    [poBoxSectionView endEditing:YES];
}

@end
