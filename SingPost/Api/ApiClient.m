//
//  ApiClient.m
//  SingPost
//
//  Created by Edward Soetiono on 8/10/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import "ApiClient.h"

@implementation ApiClient

static NSString *const BASE_URL = @"https://uatesb1.singpost.com";

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
                  success(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure)
                  failure(error);
          }];
}

- (void)calculateSingaporePostageForFromPostalCode:(NSString *)fromPostalCode andToPostalCode:(NSString *)toPostalCode andWeight:(NSString *)weightInGrams onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<SingaporePostalInfoDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
                     "<ToPostalCode>%@</ToPostalCode>"
                     "<FromPostalCode>%@</FromPostalCode>"
                     "<Weight>%@</Weight>"
                     "<DeliveryServiceName></DeliveryServiceName>"
                     "</SingaporePostalInfoDetailsRequest>", toPostalCode, fromPostalCode, weightInGrams];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/FilterSingaporePostalInfo" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        NSLog(@"%@", XMLElement);
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        NSLog(@"%@", error);
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)calculateOverseasPostageForCountryCode:(NSString *)countryCode andWeight:(NSString *)weightInGrams andItemTypeCode:(NSString *)itemTypeCode andDeliveryCode:(NSString *)deliveryCode onSuccess:(ApiClientSuccess)success onFailure:(ApiClientFailure)failure
{
    NSString *xml = [NSString stringWithFormat:@"<OverseasPostalInfoDetailsRequest xmlns=\"http://singpost.com/paw/ns\">"
         "<Country>%@</Country>"
         "<Weight>%@</Weight>"
         "<DeliveryServiceName></DeliveryServiceName>"
         "<ItemType>%@</ItemType>"
         "<PriceRange>999</PriceRange>"
         "<DeliveryTimeRange>%@</DeliveryTimeRange>"
         "</OverseasPostalInfoDetailsRequest>", countryCode, weightInGrams, itemTypeCode, deliveryCode];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"ma/FilterOverseasPostalInfo" parameters:nil];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        NSLog(@"%@", XMLElement);
        if (success)
            success(XMLElement);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        NSLog(@"%@", error);
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

@end
