//
//  ParcelStatus.h
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "RLMObject.h"

@interface ParcelStatus : RLMObject
@property NSDate *date;
@property NSString *location;
@property NSString *statusDescription;
@end

RLM_ARRAY_TYPE(ParcelStatus)