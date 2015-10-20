//
//  FoodCategory.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/20/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FoodCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * imageID;
@property (nonatomic, retain) NSString * categoryObjectID;

@end
