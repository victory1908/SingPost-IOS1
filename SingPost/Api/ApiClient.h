//
//  ApiClient.h
//  SingPost
//
//  Created by Edward Soetiono on 8/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <AFNetworking.h>

@interface ApiClient : AFHTTPClient

typedef void (^ApiClientSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^ApiClientFailure)(AFHTTPRequestOperation *operation, NSError *error);

+ (ApiClient *)sharedInstance;

- (void)getSingpostServicesArticlesOnSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure;

@end
