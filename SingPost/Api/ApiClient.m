//
//  ApiClient.m
//  SingPost
//
//  Created by Edward Soetiono on 8/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ApiClient.h"

@implementation ApiClient

static NSString *const BASE_URL = @"http://mobile.singpost.com//";

#pragma mark - Shared singleton instance

+ (ApiClient *)sharedInstance {
    static ApiClient *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return sharedInstance;
}

#pragma mark - API calls

- (void)getSingpostServicesArticlesOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    [self getPath:@"singpost-services.php"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success)
                  success(operation, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure)
                  failure(operation, error);
          }];
}

@end
