//
//  StampCollectiblesTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "StampCollectiblesTableViewCell.h"
#import "Stamp.h"
#import "UIFont+SingPost.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"
#import "PersistentBackgroundView.h"

@implementation StampCollectiblesTableViewCell
{
    UIImageView *stampImageView;
    UILabel *titleLabel, *issueDateDisplayLabel, *issueDateLabel;
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
        
        stampImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 100, 100)];
        [stampImageView setBackgroundColor:[UIColor whiteColor]];
        [stampImageView setContentMode:UIViewContentModeScaleToFill];
        [contentView addSubview:stampImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 180, 44)];
        [titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTextColor:RGB(51, 51, 51)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:titleLabel];
        
        issueDateDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 20)];
        [issueDateDisplayLabel setText:@"Date of issue"];
        [issueDateDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [issueDateDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [issueDateDisplayLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:issueDateDisplayLabel];
        
        issueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 20)];
        [issueDateLabel setBackgroundColor:[UIColor clearColor]];
        [issueDateLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [issueDateLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:issueDateLabel];
        
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

- (void)setStamp:(Stamp *)inStamp
{
    _stamp = inStamp;
    
    [titleLabel setText:_stamp.title];
    [titleLabel setVerticalAlignmentTop];
    [issueDateDisplayLabel setY:CGRectGetMaxY(titleLabel.frame) + 9.0f];
    [issueDateDisplayLabel sizeToFit];
    [issueDateLabel setY:CGRectGetMaxY(issueDateDisplayLabel.frame)];
    [issueDateLabel setText:[sDateFormatter stringFromDate:_stamp.issueDate]];
    [issueDateLabel sizeToFit];
    
    [stampImageView setImage:[UIImage imageNamed:_stamp.image]];
}

@end
