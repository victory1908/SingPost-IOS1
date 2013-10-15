//
//  OfferTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 15/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "OfferTableViewCell.h"
#import "Offer.h"
#import "UIFont+SingPost.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"
#import "PersistentBackgroundView.h"

@implementation OfferTableViewCell
{
    UIImageView *offerImageView;
    UILabel *titleLabel, *offerDateDisplayLabel, *offerDateLabel;
}

static NSDateFormatter *sDateFormatter;

+ (void)initialize
{
    if (!sDateFormatter) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setDateFormat:@"dd MMMM yyyy"];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(204, 204, 204);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 70)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        offerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 100, 100)];
        [offerImageView setBackgroundColor:[UIColor whiteColor]];
        [offerImageView setContentMode:UIViewContentModeScaleToFill];
        [contentView addSubview:offerImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 180, 44)];
        [titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTextColor:RGB(51, 51, 51)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:titleLabel];
        
        offerDateDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 20)];
        [offerDateDisplayLabel setText:@"Date of issue"];
        [offerDateDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [offerDateDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [offerDateDisplayLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:offerDateDisplayLabel];
        
        offerDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 20)];
        [offerDateLabel setBackgroundColor:[UIColor clearColor]];
        [offerDateLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [offerDateLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:offerDateLabel];
        
        PersistentBackgroundView *separatorView = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(130, 108, 173, 0.5)];
        [separatorView setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [titleLabel setHeight:44];
}

#pragma mark - Accessors

- (void)setOffer:(Offer *)inOffer
{
    _offer = inOffer;
    
    [titleLabel setText:_offer.title];
    [titleLabel setVerticalAlignmentTop];
    [offerDateDisplayLabel setY:CGRectGetMaxY(titleLabel.frame) + 9.0f];
    [offerDateDisplayLabel sizeToFit];
    [offerDateLabel setY:CGRectGetMaxY(offerDateDisplayLabel.frame)];
    [offerDateLabel setText:[sDateFormatter stringFromDate:_offer.offerDate]];
    [offerDateLabel sizeToFit];
    
    [offerImageView setImage:_offer.displayImage];
}

@end
