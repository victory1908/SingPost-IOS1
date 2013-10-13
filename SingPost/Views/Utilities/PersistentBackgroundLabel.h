//
//  PersistentBackgroundLabel.h
//  SingPost
//
//  Created by Edward Soetiono on 14/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <UIKit/UIKit.h>

//to workaround issue whereby uilabel background is automatically set to clear when table view cell is higlighted
@interface PersistentBackgroundLabel : UILabel

- (void)setPersistentBackgroundColor:(UIColor*)color;

@end
