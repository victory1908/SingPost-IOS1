//
//  Content.m
//  
//
//  Created by Le Khanh Vinh on 8/8/16.
//
//

#import "Content.h"
#import "ApiClient.h"

@implementation Content

// Insert code here to add functionality to your managed object subclass

typedef void (^ SuccessBlock)(BOOL success, id response);
typedef void (^ FailureBlock)(NSError *error, NSInteger statusCode);

+ (void)API_SingPostContentOnCompletion:(void (^) (BOOL success))completionBlock {

//    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            __block NSString *faq = nil;
//            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
//                if ([attributes[@"Name"] isEqualToString:@"name"]) {
//                    faq = attributes[@"content"];
//                    *stop = YES;
//                }
//            }];
//            
//            if (completionBlock) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(faq);
//                });
//            }
//        });
//    } onFailure:^(NSError *error) {
//        if (completionBlock) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock(nil);
//            });
//        }
//    }];
    
    
    
    [[ApiClient sharedInstance] getSingpostContentsOnSuccess:^(id responseJSON) {
        
        NSLog(@"%@",responseJSON);
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                Content *content = [Content MR_findFirstOrCreateByAttribute:@"name" withValue:attributes[@"Name"] inContext:localContext];
                content.content = attributes[@"content"];
            }];
            
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (error) {
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO);
                //                    });
            }else {
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(YES);
                //                    });
            }
        }];

//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            __block NSString *termsOfUse = nil;
//            NSLog(@"%@",responseJSON);
//            
//            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//                
//                [responseJSON[@"root"] enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
//                    Content *content = [Content MR_findFirstOrCreateByAttribute:@"name" withValue:attributes[@"Name"] inContext:localContext];
//                    content.content = attributes[@"content"];
//                }];
//
//            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//                if (error) {
////                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completionBlock(NO);
////                    });
//                }else {
////                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completionBlock(YES);
////                    });
//                }
//            }];
            
//        });
    } onFailure:^(NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO);
            });
        }
        NSLog(@"Failed to get SingPost Content");
    }];

}

@end
