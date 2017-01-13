//
//  AnnouncementTableViewCell.m
//  SingPost
//
//  Created by Wei Guang on 8/7/14.
//  Copyright (c) 2014 Codigo. All rights reserved.
//

#import "AnnouncementTableViewCell.h"
#import "UIFont+SingPost.h"
#import "UILabel+VerticalAlign.h"
#import "UIView+Position.h"
#import "PersistentBackgroundView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSDictionary+Additions.h"

@implementation AnnouncementTableViewCell {
    UIImageView *imageView;
    UILabel *titleLabel, *issueDateLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(204, 204, 204);
        self.selectedBackgroundView = v;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 120)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 100, 100)];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [contentView addSubview:imageView];
        
        float width2 = INTERFACE_IS_IPAD ? 620.0f : 180.0f;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, imageView.top, width2, 44)];
        [titleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTextColor:RGB(51, 51, 51)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:titleLabel];
        
        issueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, 0, 250, 20)];
        [issueDateLabel setBackgroundColor:[UIColor clearColor]];
        [issueDateLabel setFont:[UIFont SingPostRegularFontOfSize:14.0f fontKey:kSingPostFontOpenSans]];
        [issueDateLabel setTextColor:RGB(125, 136, 149)];
        [contentView addSubview:issueDateLabel];
        
        float width = INTERFACE_IS_IPAD ? 620.0f : 173.0f;
        PersistentBackgroundView *separatorView = [[PersistentBackgroundView alloc] initWithFrame:CGRectMake(130, 108, width, 0.5)];
        [separatorView setPersistentBackgroundColor:RGB(196, 197, 200)];
        [contentView addSubview:separatorView];
        
        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [titleLabel setHeight:44];
}

- (void)configureCellWithData:(NSDictionary *)info {
    
    [titleLabel setText:[info objectForKeyOrNil:@"Name"]];
    [titleLabel alignTop];
    
    NSString *issueDateString = [info objectForKeyOrNil:@"Date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *issueDate = [dateFormatter dateFromString:issueDateString];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    newDateFormatter.dateFormat = @"dd MMMM yyyy";
    
    [issueDateLabel setText:[newDateFormatter stringFromDate:issueDate]];
    issueDateLabel.top = titleLabel.bottom;
    
    [imageView setImageWithURL:[NSURL URLWithString:[info objectForKeyOrNil:@"Thumbnail"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
