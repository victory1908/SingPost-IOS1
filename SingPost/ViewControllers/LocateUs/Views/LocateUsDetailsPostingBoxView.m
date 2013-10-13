//
//  LocateUsDetailsPostingBoxView.m
//  SingPost
//
//  Created by Edward Soetiono on 7/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "LocateUsDetailsPostingBoxView.h"
#import "FlatBlueButton.h"
#import "UIFont+SingPost.h"

@implementation LocateUsDetailsPostingBoxView
{
    UILabel *naLabel;
    FlatBlueButton *postingBoxButton;
}

- (id)initWithPostingBox:(EntityLocation *)postingBox andFrame:(CGRect)frame
{
    _postingBox = postingBox;
    
    if ((self = [super initWithFrame:frame])) {
        if (postingBox) {
            postingBoxButton = [[FlatBlueButton alloc] initWithFrame:CGRectMake(15, 20, self.bounds.size.width - 30, 48)];
            [postingBoxButton addTarget:self action:@selector(postingBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [postingBoxButton setTitle:@"Posting Box" forState:UIControlStateNormal];
            [self addSubview:postingBoxButton];
        }
        else {
            naLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.bounds.size.width - 20, 15)];
            [naLabel setTextColor:RGB(58, 68, 81)];
            [naLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
            [naLabel setText:@"N/A"];
            [naLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:naLabel];
        }
    }
    
    return self;
}
- (IBAction)postingBoxButtonClicked:(id)sender
{
    [self.delegate goToPostingBox:_postingBox];
}

@end
