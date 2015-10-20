//
//  ServiceDataFetcher.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/17/15.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ServiceDataFetcher : NSObject

+(ServiceDataFetcher *)dataFetcher;
-(void)clearImageCacheInDirectory:(NSString *)directory;
-(void)loadItemImageFile:(PFFile *)file withObjectId:(NSString *)objectID noOfFilesToLoad:(NSInteger)noOfFiles;
-(void)loadItemDetailImageFile:(PFFile *)file numberOfFilesToload:(NSInteger)noOfFilesToLoad withObjectId:(NSString *)objectID;
-(void)loadCategoryImageFile:(PFFile *)file withObjectId:(NSString *)objectId noOfFilesToLoad:(NSInteger)noOfFiles;
@end
