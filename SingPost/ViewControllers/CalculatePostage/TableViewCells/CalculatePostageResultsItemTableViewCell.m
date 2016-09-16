//
//  CalculatePostageResultsItemTableViewCell.m
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "CalculatePostageResultsItemTableViewCell.h"
#import "UIFont+SingPost.h"
#import "CalculatePostageResultItem.h"
#import "UIView+Position.h"

@implementation CalculatePostageResultsItemTableViewCell
{
    UILabel *serviceTitleLabel, *statusLabel, *costLabel;
    UIView *separatorView;
    UIStackView *hStackView, *vStackView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        CGFloat width;
        if (INTERFACE_IS_IPAD)
            width = 768;
        else
            width = 320;
        
//        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 80)];
//        [contentView setBackgroundColor:[UIColor whiteColor]];
        
//        serviceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, LONG_MAX)];
        serviceTitleLabel = [UILabel new];
        [serviceTitleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [serviceTitleLabel setNumberOfLines:0];
        [serviceTitleLabel setTextColor:RGB(51, 51, 51)];
        [serviceTitleLabel setBackgroundColor:[UIColor clearColor]];
        [serviceTitleLabel setTextAlignment:NSTextAlignmentLeft];
//        [contentView addSubview:serviceTitleLabel];
        
//        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 30)];
        statusLabel = [UILabel new];
        [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(125, 136, 149)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
//        [contentView addSubview:statusLabel];
        
//        costLabel = [[UILabel alloc] initWithFrame:CGRectMake(216, 20, 85, 30)];
        costLabel = [UILabel new];
//        costLabel.right = contentView.right - 15;
        [costLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [costLabel setTextColor:RGB(51, 51, 51)];
        [costLabel setTextAlignment:NSTextAlignmentRight];
        [costLabel setBackgroundColor:[UIColor clearColor]];
//        [contentView addSubview:costLabel];
        
//        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 69, self.contentView.bounds.size.width - 30, 2)];
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 30, 10)];

//        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//        [separatorView setBackgroundColor:RGB(196, 197, 200)];
//        [self.contentView addSubview:separatorView];
        
        vStackView = [UIStackView new];
        [vStackView addArrangedSubview:serviceTitleLabel];
        [vStackView addArrangedSubview:statusLabel];
        vStackView.axis = UILayoutConstraintAxisVertical;
        vStackView.spacing = 5;
        vStackView.distribution = UIStackViewDistributionFill;
        vStackView.alignment = UIStackViewAlignmentLeading;
        
        hStackView = [UIStackView new];
        [hStackView addArrangedSubview:vStackView];
        [hStackView addArrangedSubview:costLabel];
        hStackView.translatesAutoresizingMaskIntoConstraints = false;
        hStackView.axis = UILayoutConstraintAxisHorizontal;
        hStackView.spacing = 5;
        hStackView.distribution = UIStackViewDistributionFill;
        hStackView.alignment = UIStackViewAlignmentCenter;
        
        
//        vStackView.frame = contentView.frame;
        
//        [vStackView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor].active = true;
//        [vStackView.centerYAnchor constraintEqualToAnchor:contentView.centerYAnchor].active = true;
        
//        NSDictionary *views = @{@"vStackView": vStackView};
        
        
        [self.contentView addSubview:hStackView];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[hStackView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hStackView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[hStackView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hStackView)]];
        
        
        
//        [self.contentView addSubview:contentView];
    }
    return self;
}

- (void)setItem:(CalculatePostageResultItem *)inItem
{
    _item = inItem;
    
//    [serviceTitleLabel setWidth:190 andHeight:LONG_MAX];
//    [serviceTitleLabel setWidth:190 andHeight:INT_MAX];
    NSString * text = [_item.deliveryServiceName stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    [serviceTitleLabel setText:text];
//    [serviceTitleLabel sizeToFit];
    [statusLabel setText:[NSString stringWithFormat:@"%@ working days", _item.deliveryTime]];
//    [statusLabel setY:CGRectGetMaxY(serviceTitleLabel.frame)];
//    [separatorView setY:CGRectGetMaxY(serviceTitleLabel.frame) + 40.0f];
//    [separatorView setY:CGRectGetMaxY(serviceTitleLabel.frame) + 40.0f];

    
    if([_item.deliveryServiceType isEqual:@"Mail"])
        [costLabel setText:_item.netPostageCharges];
    else
        [costLabel setText:_item.postageCharges];
//    [costLabel setCenter:CGPointMake(costLabel.center.x, serviceTitleLabel.bounds.size.height / 2.0f + 23.0f)];
}

@end
