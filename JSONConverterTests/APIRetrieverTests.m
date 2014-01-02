//
//  APIRetrieverTests.m
//  JSONConverter
//
//  Created by Wahyu Sumartha Priya D on 12/20/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "APIRetriever.h"

#import "Global.h"

@interface APIRetrieverTests : XCTestCase

@end

@implementation APIRetrieverTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/**
 *  This Test will Check wheter the instance of 
 *     APIRetriever is allocated properly
 */
- (void)testAPIRetrieverShouldNotBeNil
{
    XCTAssertNotNil([APIRetriever sharedInstance], @"APIRetriever Object Should not be nil");
}

/**
 *  This Spec will test whether the request will return value or not for the particular 
 *  URL that was setting up
 */
- (void)testAPIRetrieverGetReqeust
{
    StartBlock();
    
    NSString *url = @"http://mobile-api.iproperty.com/general/IDN?format=json&country=IDN&request_source=IPHONE_V2";
    [[APIRetriever sharedInstance] getRequest:url parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        XCTAssertNotNil(responseObject, @"Response Object Should Not Be Nil");
        
    } failed:^(NSError *error) {
        
    }];
    
    // Run The Loop
    WaitUntilBlockCompletes();
    
}


@end
