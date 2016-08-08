//
//  Article+CoreDataProperties.h
//  
//
//  Created by Le Khanh Vinh on 6/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article

@property (nullable, nonatomic, retain) NSString *buttonType;
@property (nullable, nonatomic, retain) NSString *expireDate;
@property (nullable, nonatomic, retain) NSString *htmlContent;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *ordering;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) NSString *websiteURL;
@property (nullable, nonatomic, retain) ArticleCategory *articlecategory;

@end

NS_ASSUME_NONNULL_END
