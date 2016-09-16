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
//        UIStackView *contentView = [[UIStackView alloc]initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
//        UIStackView *contentView = [UIStackView new];
//        UIStackView *containerStackView = [UIStackView new];
//        [contentView setBackgroundColor:[UIColor whiteColor]];
        
//        serviceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, LONG_MAX)];
        serviceTitleLabel = [[UILabel alloc] init];
        [serviceTitleLabel setFont:[UIFont SingPostRegularFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [serviceTitleLabel setNumberOfLines:0];
        [serviceTitleLabel setTextColor:RGB(51, 51, 51)];
        [serviceTitleLabel setBackgroundColor:[UIColor clearColor]];
        [serviceTitleLabel setTextAlignment:NSTextAlignmentLeft];
//        [containerStackView addArrangedSubview:serviceTitleLabel];
        
//        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 30)];
        statusLabel = [UILabel new];
        [statusLabel setFont:[UIFont SingPostBoldFontOfSize:12.0f fontKey:kSingPostFontOpenSans]];
        [statusLabel setTextColor:RGB(125, 136, 149)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [statusLabel setTextAlignment:NSTextAlignmentLeft];
//        [containerStackView addArrangedSubview:statusLabel];
        
//        costLabel = [[UILabel alloc] initWithFrame:CGRectMake(216, 20, 85, 30)];
        costLabel = [UILabel new];
//        costLabel.right = contentView.right - 15;
        [costLabel setFont:[UIFont SingPostBoldFontOfSize:16.0f fontKey:kSingPostFontOpenSans]];
        [costLabel setTextColor:RGB(51, 51, 51)];
        [costLabel setTextAlignment:NSTextAlignmentRight];
        [costLabel setBackgroundColor:[UIColor clearColor]];
//        [contentView addArrangedSubview:costLabel];
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 30, 1)];
//        separatorView = [[UIView alloc]init];

//        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//        [separatorView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [separatorView setBackgroundColor:RGB(196, 197, 200)];
        [self.contentView addSubview:separatorView];
        
        
//        [self.contentView addSubview:containerStackView];
        UIStackView *containerStackView = [UIStackView new];
        [containerStackView addArrangedSubview:serviceTitleLabel];
        [containerStackView addArrangedSubview:statusLabel];
//        [containerStackView addArrangedSubview:separatorView];
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = NO;
        containerStackView.axis = UILayoutConstraintAxisVertical;
        containerStackView.distribution = UIStackViewDistributionEqualSpacing;
        containerStackView.alignment = UIStackViewAlignmentTop;
        containerStackView.spacing = 5;
        
        UIStackView *contentView = [[UIStackView alloc]init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.axis = UILayoutConstraintAxisHorizontal;
        contentView.distribution = UIStackViewAlignmentTrailing;
        contentView.alignment = UIStackViewAlignmentCenter;
        contentView.spacing = 10;
        
//        [contentView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10.0].active = YES;
//        [contentView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
//        [contentView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
//        [contentView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-30.0].active = YES;
        
        
        
        [contentView addArrangedSubview:containerStackView];
        [contentView addArrangedSubview:costLabel];
        
        [self.contentView addSubview:contentView];
        
        //autolayout the stack view - pin 30 up 20 left 20 right 30 down

        [self.contentView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-[contentView]-|"
                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(contentView)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-[contentView]-|"
                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(contentView)]];
        
//        [self.contentView.layer setBorderColor:[UIColor blueColor].CGColor];
//        [self.contentView.layer setBorderWidth:1.0f];
        
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

//- (void)layoutSubviews{
//    [self layoutIfNeeded];
//}
//
//-(void)updateConstraints {
//
//}

@end
