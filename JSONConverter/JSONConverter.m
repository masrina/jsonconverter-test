//
//  JSONConverter.m
//  JSONConverter
//
//  Created by Wahyu Sumartha Priya D on 12/20/13.
//  Copyright (c) 2013 iProperty. All rights reserved.
//

#import "JSONConverter.h"

#import "APIRetriever.h"

#define API_URL @"http://mobile-api.iproperty.com/general/IDN?format=json&country=IDN&request_source=IPHONE_V2"

static NSString * const AllDictionaryFileName = @"All.plist";
static NSString * const ProvinceDictionaryFileName = @"Province.plist";
static NSString * const AreaDictionaryFileName = @"Area.plist";
static NSString * const DistrictDictionaryFileName = @"District.plist";
static NSString * const IndexedAreaDictionaryFileName = @"IndexedArea.plist";

static NSString * const IndexedDistrictDictionaryRootFolder = @"IndexedDistrict";

@interface JSONConverter()

/**
 *  Write dictionary object to local file 
 *  @params NSDictionary that will write to local file
 *  @params NSString of destination path that used to save the file 
 *  @return BOOL value, it will return YES if the file success to save  
        otherwise it will return NO
 */
- (BOOL)writeDictionary:(NSDictionary *)dictionary localPath:(NSString *)path;


/**
 * Return a string of NSDocumentDirectory Full Path
 */
- (NSString *)documentsDirectoryPath;

@end

@implementation JSONConverter

@synthesize indexedDistrictPlistPrefix;

+ (JSONConverter *)sharedInstance
{
    static JSONConverter *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[JSONConverter alloc] init];
    });
    
    return shared;
}


- (BOOL)writeDictionary:(DictionaryType)dictionaryType
{
    if (self.dictionary) {
        
        NSDictionary *dictionaryObject = [self dictionaryByDictionaryType:dictionaryType andResource:self.dictionary];

        return [self writeDictionary:dictionaryObject localPath:[self plistFileName:dictionaryType]];

    } else {
        
        return NO;
    }
    
    
}

- (NSDictionary *)groupingDictionaryType:(DictionaryType)dictionaryType
{

    DictionaryType rootDictionaryType;
    
    /**
     *  Get Root Dictionary Type
     */
    switch (dictionaryType) {
        case DictionaryTypeArea:
            rootDictionaryType = DictionaryTypeProvince;
            break;
        case DictionaryTypeDistrict:
            rootDictionaryType = DictionaryTypeArea;
            break;
        default:
            rootDictionaryType = DictionaryTypeAll;
            break;
    }
    
    
    NSDictionary *rootDictionary = [NSDictionary dictionaryWithContentsOfFile:[self plistFileName:rootDictionaryType]];
    
    /**
     * Do a grouping process
     */
    switch (dictionaryType) {
        case DictionaryTypeArea:
            return [self groupingArea:rootDictionary];
            break;
        case DictionaryTypeDistrict:
            return [self groupingDistrict:rootDictionary];
            break;
        default:
            break;
    }
    
    
    return nil;
}


#pragma mark - Private Method
- (BOOL)writeDictionary:(NSDictionary *)dictionary localPath:(NSString *)path
{
    BOOL successToWrite = [dictionary writeToFile:path atomically:YES];
    
    return successToWrite;
}

- (NSString *)documentsDirectoryPath
{
    NSArray *searchPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [searchPathArray objectAtIndex:0];
}

- (NSString *)plistFileName:(DictionaryType)dictionaryType
{
    switch (dictionaryType) {
        case DictionaryTypeAll:
            return [[self documentsDirectoryPath] stringByAppendingPathComponent:AllDictionaryFileName];
            break;
        case DictionaryTypeProvince:
            return [[self documentsDirectoryPath] stringByAppendingPathComponent:ProvinceDictionaryFileName];
            break;
        case DictionaryTypeArea:
            return [[self documentsDirectoryPath] stringByAppendingPathComponent:AreaDictionaryFileName];
            break;
        case DictionaryTypeDistrict:
            return [[self documentsDirectoryPath] stringByAppendingPathComponent:DistrictDictionaryFileName];
            break;
        case DictionaryTypeIndexedArea:
            return [[self documentsDirectoryPath] stringByAppendingPathComponent:IndexedAreaDictionaryFileName];
            break;
        case DictionaryTypeIndexedDistrict:
            return [[self documentsDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.plist", IndexedDistrictDictionaryRootFolder, self.indexedDistrictPlistPrefix]];
            break;
        default:
            return @"";
            break;
    }
}

- (NSDictionary *)dictionaryByDictionaryType:(DictionaryType)dictionaryType andResource:(id)resource
{
    NSDictionary *dictionary;
    switch (dictionaryType) {
        case DictionaryTypeAll:
        {
            dictionary = resource;
            break;
        }
        case DictionaryTypeProvince:
        {
            NSArray *provinceArrayOfDictionary = [resource objectForKey:@"ref_province"];
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:provinceArrayOfDictionary, @"province", nil];
            break;
        }
        case DictionaryTypeArea:
        {
            NSArray *areaArrayOfDictionary = [resource objectForKey:@"ref_area"];
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:areaArrayOfDictionary, @"area", nil];
            break;
        }
        case DictionaryTypeDistrict:
        {
            NSArray *districtArrayOfDictionary = [resource objectForKey:@"ref_district"];
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:districtArrayOfDictionary, @"district", nil];
            break;
        }
        default:
        {
            dictionary = resource;
            break;
        }
    }
    
    return dictionary;

}

- (NSDictionary *)groupingArea:(NSDictionary *)rootDictionary
{
    NSArray *provinceArray = [rootDictionary objectForKey:@"province"];
    
    /**
     *  Save All of Province Id Key to a NSMutableArray
     */
    NSMutableArray *provinceIdArray = [NSMutableArray array];
    for (int i = 0; i < provinceArray.count; i++) {
        
        [provinceIdArray addObject:[[[provinceArray objectAtIndex:i] objectForKey:@"province_id"] stringValue]];
        
    }
    
    
    /**
     *  Get Area Object of NSDictionary
     */
    NSDictionary *areaDictionary = [NSDictionary dictionaryWithContentsOfFile:[self plistFileName:DictionaryTypeArea]];
    
    
    NSArray *areaArray = [areaDictionary objectForKey:@"area"];
    
    NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionary];
    
    /**
     *  Grouping Area by Province Id
     */
    for (NSString *provinceId in provinceIdArray) {
        
        NSMutableArray *selectedAreaArray = [NSMutableArray array];
        
        for (int i = 0; i < areaArray.count; i++) {
            
            NSDictionary *dictionary = [areaArray objectAtIndex:i];
            NSString *dictionaryProvinceId = [[dictionary objectForKey:@"province_id"] stringValue];
            
            if ([provinceId isEqualToString:dictionaryProvinceId]) {
                [selectedAreaArray addObject:dictionary];
            }
            
            dictionary = nil;
            
        }
        
        [selectedDictionary setObject:selectedAreaArray forKey:provinceId];
        
    }
    
    return selectedDictionary;
}

- (NSDictionary *)groupingDistrict:(NSDictionary *)rootDictionary
{
    [self createIndexedDistrictDirectory];
    
    NSArray *areaArray = [rootDictionary objectForKey:@"area"];
    
    /**
     *  Assign all of areaId to areaIdArray
     */
    NSMutableArray *areaIdArray = [NSMutableArray array];
    for (int i = 0; i < areaArray.count; i++) {
        
        [areaIdArray addObject:[[[areaArray objectAtIndex:i] objectForKey:@"area_id"] stringValue]];
    
    }
    
    /**
     *  Get District Dictionary Data
     */
    NSDictionary *districtDictionary = [NSDictionary dictionaryWithContentsOfFile:[self plistFileName:DictionaryTypeDistrict]];
    NSArray *districtArray = [districtDictionary objectForKey:@"district"];
    
    
    /**
     *  Grouping District By Area Id
     */
    NSMutableArray *indexedDistrictArray = [NSMutableArray array];
    for (NSString *areaId in areaIdArray) {
        
        NSMutableArray *selectedDistrictArray = [NSMutableArray array];
        
        for (int i = 0; i < districtArray.count; i++) {
            
            NSDictionary *dictionary = [districtArray objectAtIndex:i];
            NSString *dictionaryAreaId = [[dictionary objectForKey:@"area_id"] stringValue];
            
            if ([areaId isEqualToString:dictionaryAreaId]) {
                [selectedDistrictArray addObject:dictionary];
            }
            
            dictionary = nil;
            
        }
        
        NSMutableDictionary *selectedDictionary = [NSMutableDictionary dictionary];
        [selectedDictionary setObject:selectedDistrictArray forKey:areaId];
        [indexedDistrictArray addObject:selectedDictionary];
        selectedDictionary = nil;
    }
    
    
    NSDictionary *indexedDictionary = [NSDictionary dictionaryWithObject:indexedDistrictArray forKey:@"districts"];
    
    return indexedDictionary;
    
    
}

- (void)createIndexedDistrictDirectory
{
    NSString *documentsDirectory = [self documentsDirectoryPath];
    NSString *indexedDistrictPathFolder = [documentsDirectory stringByAppendingPathComponent:IndexedDistrictDictionaryRootFolder];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:indexedDistrictPathFolder isDirectory:&isDir] && isDir == NO) {
        
        [fileManager createDirectoryAtPath:indexedDistrictPathFolder withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
}



@end
