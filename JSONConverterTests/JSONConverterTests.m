//
//  JSONConverterTests.m
//  JSONConverterTests
//
//  Created by Wahyu Sumartha Priya D on 12/20/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JSONConverter.h"
#import "APIRetriever.h"

#import "Global.h"

#define API_URL @"http://mobile-api.iproperty.com/general/IDN?format=json&country=IDN&request_source=IPHONE_V2"


@interface JSONConverterTests : XCTestCase

@property (nonatomic, strong) NSDictionary *dictionaryResponse;

@end

@implementation JSONConverterTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testRetrieveAllDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        /**
         * Dictionary should have 5 keys which is ref_area, listing_summary, ref_province, ref_district, and status
         */
        NSInteger sumOfDictionaryKeys = [[responseObject allKeys] count];
        XCTAssertEqual(sumOfDictionaryKeys, 5, @"Dictionary should have 5 keys");
        
        /**
         *  Check whether those 5 keys is ref_area, listing_summary, ref_province, ref_district, and status
         */
        NSArray *keysArray = [NSArray arrayWithObjects:@"ref_area", @"listing_summary", @"ref_province", @"ref_district", @"status", nil];
        NSArray *responseDictKeys = [responseObject allKeys];
        
        for (NSString *key in keysArray) {
            
            NSInteger index = [responseDictKeys indexOfObject:key];
            XCTAssertNotEqual(index, NSNotFound, @"the key is not found");
            
        }
        
        
    } failed:^(NSError *error) {
        
        NSLog(@"Fail : %@", [error localizedDescription]);
        
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testRetrieveProvinceDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        NSArray *provinceArray = [responseObject objectForKey:@"ref_province"];
        
        /**
         *  The First Dictionary Data must be "Bali"
         */
        NSDictionary *firstDictionary = [provinceArray objectAtIndex:0];
        XCTAssertEqualObjects([firstDictionary objectForKey:@"desc"], @"Cyberjaya", @"The First Description data must be bali");
        
        
    } failed:^(NSError *error) {
    
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testRetrieveAreaDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        NSArray *areaArray = [responseObject objectForKey:@"ref_area"];
        
        /**
         *  The First Dictionary Data must be "Aceh Barat"
         */
        NSDictionary *firstDictionary = [areaArray objectAtIndex:0];
        XCTAssertEqualObjects([firstDictionary objectForKey:@"desc"], @"Aceh Barat", @"The First Description data must be bali");
        
        
    } failed:^(NSError *error) {
        
    }];
    
    WaitUntilBlockCompletes();

}

- (void)testRetrieveDistrictDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        NSArray *districtArray = [responseObject objectForKey:@"ref_district"];
        
        /**
         *  The First Dictionary Data must be "Intercon"
         */
        NSDictionary *firstDictionary = [districtArray objectAtIndex:0];
        XCTAssertEqualObjects([[firstDictionary objectForKey:@"desc"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], @"Intercon", @"The First Description data must be bali");
        
        
    } failed:^(NSError *error) {
        
    }];
    
    WaitUntilBlockCompletes();

}

- (void)testWriteAllDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        [[JSONConverter sharedInstance] setDictionary:responseObject];
        BOOL success = [[JSONConverter sharedInstance] writeDictionary:DictionaryTypeAll];
        XCTAssertTrue(success, @"Failed to write all dictionary plist file");
        
        
    } failed:^(NSError *error) {
        
    }];
    
    WaitUntilBlockCompletes();

}

- (void)testWriteProvinceDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        [[JSONConverter sharedInstance] setDictionary:responseObject];
        BOOL success = [[JSONConverter sharedInstance] writeDictionary:DictionaryTypeProvince];
        XCTAssertTrue(success, @"Failed to write province dictionary plist file");
        
        
    } failed:^(NSError *error) {
        
    }];
    
    WaitUntilBlockCompletes();

}

- (void)testWriteAreaDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        [[JSONConverter sharedInstance] setDictionary:responseObject];
        BOOL success = [[JSONConverter sharedInstance] writeDictionary:DictionaryTypeArea];
        XCTAssertTrue(success, @"Failed to write area dictionary plist file");
        
        
    } failed:^(NSError *error) {
        
    }];
    
    WaitUntilBlockCompletes();

}

- (void)testWriteDistrictDictionary
{
    StartBlock();
    
    [[APIRetriever sharedInstance] getRequest:API_URL parameter:nil success:^(id responseObject) {
        
        EndBlock();
        
        [[JSONConverter sharedInstance] setDictionary:responseObject];
        BOOL success = [[JSONConverter sharedInstance] writeDictionary:DictionaryTypeDistrict];
        XCTAssertTrue(success, @"Failed to write district dictionary plist file");
        
        
    } failed:^(NSError *error) {
        
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testGroupingAreaByProvinceId
{
    NSDictionary *dictionary = [[JSONConverter sharedInstance] groupingDictionaryType:DictionaryTypeArea];
    XCTAssertNotNil(dictionary, @"Indexed Grouped Dictionary Should Not Be Nil");
    
    [[JSONConverter sharedInstance] setDictionary:dictionary];
    BOOL success = [[JSONConverter sharedInstance] writeDictionary:DictionaryTypeIndexedArea];
    XCTAssertTrue(success, @"Failed to save indexed dictionary");
    
}


- (void)testGroupingDistrictByAreaId
{
    NSDictionary *dictionary = [[JSONConverter sharedInstance] groupingDictionaryType:DictionaryTypeDistrict];
    
    XCTAssertNotNil(dictionary, @"Indexed District Dictionary SHould not be nil");
    
    NSArray *districtArray = [dictionary objectForKey:@"districts"];
    
    for (int i = 0; i < districtArray.count; i++) {
        NSDictionary *districtByAreaIdDict = [districtArray objectAtIndex:i];
        NSString *areaId = [[districtByAreaIdDict allKeys] lastObject];
        
        [[JSONConverter sharedInstance] setDictionary:districtByAreaIdDict];
        [[JSONConverter sharedInstance] setIndexedDistrictPlistPrefix:areaId];
        BOOL success = [[JSONConverter sharedInstance] writeDictionary:DictionaryTypeIndexedDistrict];
        XCTAssertTrue(success, @"Failed To Write Indexed District File");
        districtByAreaIdDict = nil;
    }
}

//- (void)testCleanupData
//{
//    [self cleanupData];
//}
//
//- (void)cleanupData
//{
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                        NSUserDomainMask,
//                                                                        YES) lastObject];
//
//    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
//    for (NSString *filename in fileArray)  {
//        
//        [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
//    }
//
//}


@end
