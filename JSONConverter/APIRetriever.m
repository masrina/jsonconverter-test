//
//  APIRetriever.m
//  JSONConverter
//
//  Created by Wahyu Sumartha Priya D on 12/20/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#import "APIRetriever.h"

@interface APIRetriever()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSError *apiError;
@property (nonatomic, strong) NSDictionary *response;

@property (nonatomic, copy) Success onSuccess;
@property (nonatomic, copy) Failed onFailed;
@end


@implementation APIRetriever

+ (APIRetriever *)sharedInstance
{
    static APIRetriever *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [[APIRetriever alloc] init];
        
    });
    
    return shared;
}

- (void)getRequest:(NSString *)url parameter:(NSDictionary *)dictionary success:(Success)success failed:(Failed)failed
{
    
    self.onSuccess = success;
    self.onFailed = failed;
    
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:5];
    [urlRequest setHTTPMethod:@"GET"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
}

#pragma mark -  NSURLConnection Method 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.responseData) {
        
        self.response = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
        
        if (self.onSuccess) {
            self.onSuccess(self.response);
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        self.apiError = error;
        
        if (self.onFailed) {
            self.onFailed(self.apiError);
        }
    }
}


@end
