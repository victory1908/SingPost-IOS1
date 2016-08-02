//
//  MagicalRecord+serialSaveWithBlock.h
//  SingPost
//
//  Created by Le Khanh Vinh on 3/8/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>

@interface MagicalRecord (serialSaveWithBlock)

+ (void)serialSaveWithBlock:(void (^)(NSManagedObjectContext *))block completion:(MRSaveCompletionHandler)completion;

@end
