//
//  Content+CoreDataProperties.h
//  
//
//  Created by Le Khanh Vinh on 8/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Content.h"

NS_ASSUME_NONNULL_BEGIN

@interface Content (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *content;

@end

NS_ASSUME_NONNULL_END
