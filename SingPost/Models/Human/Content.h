//
//  Content.h
//  
//
//  Created by Le Khanh Vinh on 8/8/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Content : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (void)API_SingPostContentOnCompletion:(void(^)(BOOL success))completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "Content+CoreDataProperties.h"
