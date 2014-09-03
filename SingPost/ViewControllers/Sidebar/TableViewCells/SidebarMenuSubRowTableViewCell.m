//
//  SidebarMenuSubRowTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 2/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "SidebarMenuSubRowTableViewCell.h"
#import "UIFont+SingPost.h"

@implementation SidebarMenuSubRowTableViewCell
{
    UILabel *menuNameLabel;
    UIView *separatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(204, 204, 204);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [contentView setBackgroundColor:RGB(239, 242, 246)];
        
        menuNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 140, 21)];
        [menuNameLabel setBackgroundColor:[UIColor clearColor]];
        [menuNameLabel setTextColor:RGB(128, 134, 142)];
        [menuNameLabel setFont:[UIFont SingPostRegularFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [contentView addSubview:menuNameLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(35, contentView.bounds.size.height - 1, contentView.bounds.size.width - 35, 1)];
        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [separatorView setBackgroundColor:RGB(209, 209, 211)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    
    return self;
}

- (void)setShowBottomSeparator:(BOOL)showBottomSeparator
{
    [separatorView setHidden:!showBottomSeparator];
}

- (void)setSubrowMenuOffersMore:(tSubRowsOffersMore)inSubrowMenuOffersMore
{
    _subrowMenuOffersMore = inSubrowMenuOffersMore;
    
    switch (_subrowMenuOffersMore) {
        case SUBROWS_OFFERSMORE_ANNOUNCEMENTS:
            [menuNameLabel setText:@"Announcements"];
            break;
        case SUBROWS_OFFERSMORE_OFFERS:
            [menuNameLabel setText:@"Offers"];
            break;
        case SUBROWS_OFFERSMORE_FEEDBACK:
            [menuNameLabel setText:@"Feedback"];
            break;
        case SUBROWS_OFFERSMORE_ABOUTTHISAPP:
            [menuNameLabel setText:@"About this app"];
            break;
        case SUBROWS_OFFERSMORE_TERMSOFUSE:
            [menuNameLabel setText:@"Terms of use"];
            break;
        case SUBROWS_OFFERSMORE_FAQ:
            [menuNameLabel setText:@"FAQs"];
            break;
        case SUBROWS_OFFERSMORE_RATEOURAPP:
            [menuNameLabel setText:@"Rate our app"];
            break;
        case SUBROWS_OFFERSMORE_SIGNOFF:
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                [menuNameLabel setText:@"Sign Out"];
             
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // Success! Include your code to handle the results here
                        NSLog(@"user info: %@", result);
                    } else {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                    }
                }];
            }
            
            else
                [menuNameLabel setText:@"Sign In"];
            break;
        default:
            NSAssert(NO, @"unknown type in subrowMenuOffersMore");
            break;
    }
}


@end
