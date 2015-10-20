//
//  ItemsInCategory.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/20/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemsInCategory : NSManagedObject

@property (nonatomic, retain) NSString * itemObjID;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * itemPrice;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSString * tasteDescription;
@property (nonatomic, retain) NSString * imageID;

@end
