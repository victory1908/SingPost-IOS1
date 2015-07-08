//
//  ParcelDetailRowController.h
//  SingPost
//
//  Created by Wei Guang Heng on 03/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParcelStatus.h"

@interface ParcelDetailRowController : NSObject
- (void)setCellWithDetail:(ParcelStatus *)status;
@end
