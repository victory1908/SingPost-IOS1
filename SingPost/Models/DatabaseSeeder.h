//
//  DatabaseSeeder.h
//  SingPost
//
//  Created by Edward Soetiono on 30/9/13.
//  Copyright (c) 2013 Codigo. All rights reserved.
//

#import <Foundation/Foundation.h>

//use this to perform initial seeding of the sqlite db

@interface DatabaseSeeder : NSObject

+ (void)seedLocationsDataIfRequired;
+ (void)seedOffersDataIfRequired;

@end
