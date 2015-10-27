//
//  MasterSyncFromParse.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/20/15.
//
//

#import "MasterSyncFromParse.h"
#import "CoreDataManager.h"
#import "FoodCategory.h"
#import "ServiceDataFetcher.h"
#import "ItemsInCategory.h"

static NSString * const ParseCategoryClassName = @"Categories";
static NSString * const ParseItemsClassName = @"Items";

@interface MasterSyncFromParse ()

@property (nonatomic, copy) void(^completionBlock)(void);
@property (nonatomic, strong) NSArray *itemObjectsArray;

@end

@implementation MasterSyncFromParse

+(MasterSyncFromParse *)sharedMasterSync{
    static MasterSyncFromParse *sharedMasterSyn = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMasterSyn = [[self alloc] init];
    });
    return sharedMasterSyn;
}

-(id)init{
    if ([super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoadingItemTileImages:) name:@"CompletedLoadingItemTileImagesNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoadingItemDetailImages:) name:@"CompletedLoadingItemDetailImagesNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoadingCategoryImages:) name:@"CompletedLoadingItemCategoryImagesNotification" object:nil];
    }
    return self;
}

-(void)doMasterSyncFromParseWithCompletionBlock:(void (^)(void))completionBlock{
    self.completionBlock = completionBlock;
    [self queuryCategoriesListFromParse];
}

-(void)queuryCategoriesListFromParse{
    PFQuery *query = [PFQuery queryWithClassName:ParseCategoryClassName];
    [query whereKey:@"userID" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Categories List : %@",[objects description]);
        if (!error) {
            [self saveCategoryDataToCoreData:objects];
            [self loadAndSaveCategoryImagesFromParse:objects];
            NSLog(@"Category Data : %@",[objects description]);
        } else {
            NSLog(@"Error msg : %@",[error description]);
        }
    }];
}

-(void)queryItemsListFromParse{
    PFQuery *query = [PFQuery queryWithClassName:ParseItemsClassName];
    [query whereKey:@"userID" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"ItemsList : %@",[objects description]);
        if (!error) {
            if (objects.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.itemObjectsArray = objects;
                    [self saveItemsDataToCoreData:objects];
                    [self loadAndSaveItemsImagesFromParse:objects];
                });
            }
            NSLog(@"Items Data : %@",[objects description]);
        } else {
            NSLog(@"Error msg : %@",[error description]);
        }
    }];

}

-(void)saveCategoryDataToCoreData:(NSArray *)dataArray{
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSArray *allRecords=[self fetchFromCoreData:NSStringFromClass([FoodCategory class])];
    
    // Clear the old data from core data before inserting the new set of records to avoid data duplication.
    
    if (allRecords) {
        for (NSManagedObject *managedObject in allRecords) {
            [context deleteObject:managedObject];
        }
    }
    NSError *saveError=nil;
    if ([context save:&saveError]) {
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FoodCategory *category = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([FoodCategory class]) inManagedObjectContext:context];
            PFObject *dataObject = obj;
            category.categoryName = [dataObject objectForKey:@"category_name"];
            category.categoryObjectID = dataObject.objectId;
            category.imageID = dataObject.objectId;
            NSError *error=nil;
            if (![context save:&error]) {
                NSLog(@"Following error occured while saving to core data:%@",[error description]);
            }

        }];
    }
}

-(void)saveItemsDataToCoreData:(NSArray *)dataArray{
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSArray *allRecords=[self fetchFromCoreData:NSStringFromClass([ItemsInCategory class])];
    
    // Clear the old data from core data before inserting the new set of records to avoid data duplication.
    
    if (allRecords) {
        for (NSManagedObject *managedObject in allRecords) {
            [context deleteObject:managedObject];
        }
    }
    NSError *saveError=nil;
    if ([context save:&saveError]) {
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ItemsInCategory *itemObj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ItemsInCategory class]) inManagedObjectContext:context];
            PFObject *dataObject = obj;
            NSString* newStr1 = [dataObject objectForKey:@"itemNameArabic"];
//            NSString* newStr1 = [[NSString alloc] initWithData:arabicText1 encoding:NSUTF8StringEncoding];
            NSString* newStr2 = [dataObject objectForKey:@"itemDescArabic"];
//            NSString* newStr2 = [[NSString alloc] initWithData:darabicText2 encoding:NSUTF8StringEncoding];
            itemObj.itemArabicName = newStr1;
            itemObj.itemArabicDescription = newStr2;
            itemObj.itemObjID = dataObject.objectId;
            itemObj.itemName = [dataObject objectForKey:@"item_name"];
            itemObj.itemPrice = [dataObject objectForKey:@"item_price"];
            itemObj.itemDescription = [dataObject objectForKey:@"item_desc"];
            PFObject *categoryObject = [dataObject objectForKey:@"obj_category"];
            itemObj.categoryID = categoryObject.objectId;
            itemObj.tasteDescription = [dataObject objectForKey:@"Taste"];
            itemObj.imageID = dataObject.objectId;
            NSError *error=nil;
            if (![context save:&error]) {
                NSLog(@"Following error occured while saving to core data:%@",[error description]);
            }
        }];
    }
}

-(NSArray *)fetchFromCoreData:(NSString *)entity
{
    NSManagedObjectContext *context=[[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDes=[NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [fetchRequest setEntity:entityDes];
    NSError *error=nil;
    NSArray *dataArray=[context executeFetchRequest:fetchRequest error:&error];
    return dataArray;
}

-(void)loadAndSaveCategoryImagesFromParse:(NSArray *)dataArray{
    NSInteger numberOfObjectsToLoad = 0;
    for (PFObject *obj in dataArray) {
        PFFile *itemDetailImageFile = [obj objectForKey:@"CategoryImage"];
        if (itemDetailImageFile) {
            ++numberOfObjectsToLoad;
        }
    }
    if (numberOfObjectsToLoad == 0) {
        [self queryItemsListFromParse];
        return;
    }
    [[ServiceDataFetcher dataFetcher] clearImageCacheInDirectory:@"/HM_Images/CategoryImages"];
    for (PFObject *pfObject in dataArray) {
        PFFile *imageFile = [pfObject objectForKey:@"CategoryImage"];
        if (imageFile) {
            [[ServiceDataFetcher dataFetcher] loadCategoryImageFile:imageFile withObjectId:pfObject.objectId noOfFilesToLoad:numberOfObjectsToLoad];
        }
    }
}

-(void)loadAndSaveItemsImagesFromParse:(NSArray *)dataArray{
    NSInteger numberOfObjectsToLoad = 0;
    for (PFObject *obj in dataArray) {
        PFFile *itemDetailImageFile = [obj objectForKey:@"itemImage"];
        if (itemDetailImageFile) {
            ++numberOfObjectsToLoad;
        }
    }
    if (numberOfObjectsToLoad == 0) {
        [self loadAndSaveItemDetailsImagesFromParse:dataArray];
        return;
    }
    [[ServiceDataFetcher dataFetcher] clearImageCacheInDirectory:@"/HM_Images/ItemsTileImages"];
    for (PFObject *pfObject in dataArray) {
        PFFile *itemImageFile = [pfObject objectForKey:@"itemImage"];
        if (itemImageFile) {
            [[ServiceDataFetcher dataFetcher] loadItemImageFile:itemImageFile withObjectId:pfObject.objectId noOfFilesToLoad:numberOfObjectsToLoad];
        }
    }
}

-(void)loadAndSaveItemDetailsImagesFromParse:(NSArray *)dataArray{
    NSInteger numberOfObjectsToLoad = 0;
    for (PFObject *obj in dataArray) {
        PFFile *itemDetailImageFile = [obj objectForKey:@"detailImage"];
        if (itemDetailImageFile) {
            ++numberOfObjectsToLoad;
        }
    }
    if (numberOfObjectsToLoad == 0) {
        self.completionBlock();
        return;
    }
    [[ServiceDataFetcher dataFetcher] clearImageCacheInDirectory:@"/HM_Images/ItemsDetailImages"];
    PFObject *testObj = [dataArray objectAtIndex:0];
    PFFile *testFile = [testObj objectForKey:@"detailImage"];
    [[ServiceDataFetcher dataFetcher] loadItemDetailImageFile:testFile numberOfFilesToload:numberOfObjectsToLoad withObjectId:testObj.objectId];
    for (PFObject *pfObject in dataArray) {
        PFFile *itemDetailImageFile = [pfObject objectForKey:@"detailImage"];
        if (itemDetailImageFile) {
            [[ServiceDataFetcher dataFetcher] loadItemDetailImageFile:itemDetailImageFile numberOfFilesToload:numberOfObjectsToLoad withObjectId:pfObject.objectId];
        }
    }
}

-(void)finishedLoadingItemTileImages:(NSNotification *)notif{
    [self loadAndSaveItemDetailsImagesFromParse:self.itemObjectsArray];
}

-(void)finishedLoadingItemDetailImages:(NSNotification *)noti{
    self.completionBlock();
}

-(void)finishedLoadingCategoryImages:(NSNotification *)notif{
    [self queryItemsListFromParse];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompletedLoadingItemTileImagesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompletedLoadingItemDetailImagesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompletedLoadingItemCategoryImagesNotification" object:nil];
    self.itemObjectsArray = nil;
}

@end
