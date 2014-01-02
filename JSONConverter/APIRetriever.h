//
//  APIRetriever.h
//  JSONConverter
//
//  Created by Wahyu Sumartha Priya D on 12/20/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(id responseObject);
typedef void (^Failed)(NSError *error);

@interface APIRetriever : NSObject

/**
 *  Function that will return singleton object of APIRetriever 
 *  @return an object of APIRetriever class
 */
+ (APIRetriever *)sharedInstance;

/**
 *  Function that will do Get Request to the server 
 *  @params a NSString of URL Server 
 *  @params Body that will send to the server and encapsulate with NSDictionary Object 
 *  @params Block which will called if it's succes to request to the server 
 *  @params Block which will called if it's error to request to the server
 */
- (void)getRequest:(NSString *)url parameter:(NSDictionary *)dictionary success:(Success)success failed:(Failed)failed;

@end
