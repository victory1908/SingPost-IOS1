//
//  APIManager.m
//  SingPost
//
//  Created by Wei Guang Heng on 07/07/2015.
//  Copyright (c) 2015 Codigo. All rights reserved.
//

#import "APIManager.h"
#import "ApiClient.h"
#import "AFNetworking.h"

@interface APIManager()
@property (strong, nonatomic) AFHTTPClient *httpManager;
@end

@implementation APIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static id __singleton = nil;
    dispatch_once(&pred, ^{__singleton = [[self alloc]init];});
    return __singleton;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.httpManager = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}

@end
