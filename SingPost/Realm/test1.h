//
//  test1.h
//  SingPost
//
//  Created by Le Khanh Vinh on 5/8/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import <Realm/Realm.h>

@interface test1 : RLMObject
//<# Add properties here to define the model #>
@end

// This protocol enables typed collections. i.e.:
// RLMArray<test1>
RLM_ARRAY_TYPE(test1)
