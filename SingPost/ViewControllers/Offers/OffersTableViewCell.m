//
//  OffersTableViewCell.m
//  SingPost
//
//  Created by Wei Guang on 7/1/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "OffersTableViewCell.h"
#import "Article.h"
#import "UIFont+SingPost.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"
#import "PersistentBackgroundView.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@implementation OffersTableViewCell
{
    UIImageView *offerImageView;
    UILabel *titleLabel, *expiryDateDisplayLabel, *expiryDateLabel;
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
        
        expiryDateDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 20)];
        [expiryDateDisplayLabel setText:@"Date of expiry"];
        [expiryDateDisplayLabel setBackgroundColor:[UIColor clearColor]];
        [expiryDateDisplayLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [expiryDateDisplayLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:expiryDateDisplayLabel];
        
        expiryDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 20)];
        [expiryDateLabel setBackgroundColor:[UIColor clearColor]];
        [expiryDateLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [expiryDateLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:expiryDateLabel];
        
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

- (void)setArticle:(Article *)article
{
    _article = article;
    [titleLabel setText:article.name];
    [titleLabel alignTop];
    [expiryDateDisplayLabel setY:CGRectGetMaxY(titleLabel.frame) + 9.0f];
    [expiryDateDisplayLabel sizeToFit];
    [expiryDateLabel setY:CGRectGetMaxY(expiryDateDisplayLabel.frame)];
    
    NSString *dateString = article.expireDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [newDateFormatter stringFromDate:dateFromString];
    
    [expiryDateLabel setText:strDate];
    [expiryDateLabel sizeToFit];
    
    [offerImageView setImageWithURL:[NSURL URLWithString:_article.thumbnail] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
