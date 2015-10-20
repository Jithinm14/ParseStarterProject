//
//  ItemDetailsTableViewController.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/22/15.
//
//

#import <UIKit/UIKit.h>

@class ItemsInCategory;

@interface ItemDetailsTableViewController : UITableViewController

-(id)initWithSelectedItem:(ItemsInCategory *)selectedItem andCategoryName:(NSString *)categoryName;

@end
