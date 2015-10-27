//
//  ItemsInCategory+CoreDataProperties.h
//  ParseStarterProject
//
//  Created by Jithin M on 10/23/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ItemsInCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemsInCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *categoryID;
@property (nullable, nonatomic, retain) NSString *imageID;
@property (nullable, nonatomic, retain) NSString *itemDescription;
@property (nullable, nonatomic, retain) NSString *itemName;
@property (nullable, nonatomic, retain) NSString *itemObjID;
@property (nullable, nonatomic, retain) NSString *itemPrice;
@property (nullable, nonatomic, retain) NSString *tasteDescription;
@property (nullable, nonatomic, retain) NSString *itemArabicName;
@property (nullable, nonatomic, retain) NSString *itemArabicDescription;

@end

NS_ASSUME_NONNULL_END
