//
//  ServiceDataFetcher.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/17/15.
//
//

#import "ServiceDataFetcher.h"
#import "HelperClass.h"

typedef enum : NSUInteger {
    categoryImage,
    itemImage,
    itemDetailImage,
} ImageType;

@implementation ServiceDataFetcher

+(ServiceDataFetcher *)dataFetcher{
    static ServiceDataFetcher *dataFetcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataFetcher = [[self alloc] init];
    });
    return dataFetcher;
}

-(void)loadCategoryImageFile:(PFFile *)file withObjectId:(NSString *)objectId noOfFilesToLoad:(NSInteger)noOfFiles{
    NSString *fileName = [NSString stringWithFormat:@"%@@2x.png",objectId];
    [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveImage:data withName:fileName ToCustomDirectory:@"/HM_Images/CategoryImages" noOfFilesToSave:noOfFiles imageType:categoryImage];
            });
        }
        else{
        }
    }];
}

-(void)loadItemImageFile:(PFFile *)file withObjectId:(NSString *)objectID noOfFilesToLoad:(NSInteger)noOfFiles{
    NSString *fileName = [NSString stringWithFormat:@"%@s@2x.png",objectID];
    [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveImage:data withName:fileName ToCustomDirectory:@"/HM_Images/ItemsTileImages" noOfFilesToSave:noOfFiles imageType:itemImage];
            });
        }
        else{
            
        }
    }];
}

-(void)loadItemDetailImageFile:(PFFile *)file numberOfFilesToload:(NSInteger)noOfFilesToLoad withObjectId:(NSString *)objectID{
    NSString *fileName = [NSString stringWithFormat:@"%@b@2x.png",objectID];
    [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveImage:data withName:fileName ToCustomDirectory:@"/HM_Images/ItemsDetailImages" noOfFilesToSave:noOfFilesToLoad imageType:itemDetailImage];
            });
        }
        else{
            
        }
    }];
}

-(void)saveImage:(NSData *)imageData withName:(NSString *)imageName ToCustomDirectory:(NSString *)directory noOfFilesToSave:(NSInteger)noOfFiles imageType:(NSInteger)imgType{
    NSString *customDirectoryPath = [HelperClass pathForFileInDocumentsDirectory:directory];
    NSLog(@"Image Directory: %@",customDirectoryPath);
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:customDirectoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:customDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *retinaImage = [UIImage imageWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];
    NSString *imagePath = [customDirectoryPath stringByAppendingPathComponent:imageName];
    NSData *imagePNGRepresentation=UIImagePNGRepresentation(retinaImage);
    if (![imagePNGRepresentation writeToFile:imagePath options:NSAtomicWrite error:&error]) {
        NSLog(@"Error Occured while saving Image to directory at path : %@",customDirectoryPath);
    }
    if (noOfFiles == [[NSFileManager defaultManager] contentsOfDirectoryAtPath:customDirectoryPath error:&error].count) {
        if (imgType == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedLoadingItemCategoryImagesNotification" object:self];
            });
        }
        else if (imgType == 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedLoadingItemTileImagesNotification" object:self];
            });
        }
        else if (imgType == 2){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedLoadingItemDetailImagesNotification" object:self];
            });
        }
    }
    
}

-(void)clearImageCacheInDirectory:(NSString *)directory
{
    NSString *customDirectory=[HelperClass pathForFileInDocumentsDirectory:directory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:customDirectory]){
        return;
    }
    NSError *error=nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *paths=[fileManager contentsOfDirectoryAtPath:customDirectory error:&error];
    if (!error)
    {
        for (NSString *path in paths)
        {
            NSString *fullPath=[customDirectory stringByAppendingPathComponent:path];
            BOOL deleteStatus=[fileManager removeItemAtPath:fullPath error:&error];
            if (!deleteStatus)
            {
                NSLog(@"Error occured while deleting contents of the directory: %@",[error description]);
            }
        }
    }
    else
    {
        NSLog(@"Specified directory could not be located: %@",[error description]);
    }
}


@end
