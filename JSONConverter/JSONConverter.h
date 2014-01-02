//
//  JSONConverter.h
//  JSONConverter
//
//  Created by Wahyu Sumartha Priya D on 12/20/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DictionaryType) {
    DictionaryTypeAll = 1,
    DictionaryTypeProvince,
    DictionaryTypeArea,
    DictionaryTypeDistrict,
    DictionaryTypeIndexedArea,
    DictionaryTypeIndexedDistrict
};



@interface JSONConverter : NSObject

/**
 *  NSDictionary a NSDictionary Object that will used to save to specific path that given
 */
@property (nonatomic, strong) NSDictionary *dictionary;

/**
 *  NSString a NSString value that will used as a prefix file name
 */
@property (nonatomic, strong) NSString *indexedDistrictPlistPrefix;

/**
 *  Singleton Object of JSONConverter 
 *  @return an Object of JSONConverter Class
 */
+ (JSONConverter *)sharedInstance;

/**
 *  Write The Whole Dictionary to Local File 
 *  @param DictionaryType Enumeration Type which will segment the data based on
        the paramter that given
 *  @return BOOL value, it will return YES if the file is saved otherwise it will return NO
 */
- (BOOL)writeDictionary:(DictionaryType)dictionaryType;

/**
 *  A String Builder to get Plist File Path based on DictionaryType Enumeration
 *  @params dictionaryType is a type of data that represent province, district, and area
 *  @return Plist file path
 */
- (NSString *)plistFileName:(DictionaryType)dictionaryType;

/**
 *  Function to grouping dictionary according to parameter that assigned
 *  Parameter that assigned will become the key of the dictionary itself 
 *  @params DictionaryType Enumeration type that will segment which dictionary file that will grouped 
 *  @return NSDictionary grouped NSDictionary object
 */
- (NSDictionary *)groupingDictionaryType:(DictionaryType)dictionaryType;


@end
