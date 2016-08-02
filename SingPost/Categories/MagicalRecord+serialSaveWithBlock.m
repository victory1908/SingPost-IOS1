//
//  MagicalRecord+serialSaveWithBlock.m
//  SingPost
//
//  Created by Le Khanh Vinh on 3/8/16.
//  Copyright © 2016 Codigo. All rights reserved.
//

#import "MagicalRecord+serialSaveWithBlock.h"

@implementation MagicalRecord (serialSaveWithBlock)

+ (void)serialSaveWithBlock:(void (^)(NSManagedObjectContext *))block completion:(MRSaveCompletionHandler)completion {
    static NSManagedObjectContext *localContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSManagedObjectContext *savingContext  = [NSManagedObjectContext MR_rootSavingContext];
        localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];
    });
    
    [localContext performBlock:^{
        [localContext MR_setWorkingName:NSStringFromSelector(_cmd)];
        
        if (block) {
            block(localContext);
        }
        
        [localContext MR_saveWithOptions:MRSaveParentContexts completion:completion];
    }];
}


@end
