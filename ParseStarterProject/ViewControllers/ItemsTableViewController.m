//
//  ItemsTableViewController.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/19/15.
//
//

#import "ItemsTableViewController.h"
#import "ItemsTableViewCell.h"
#import <Parse/Parse.h>
#import "ServiceDataFetcher.h"
#import "ItemsInCategory.h"
#import "ItemDetailsTableViewController.h"

static NSString * cellId = @"CellIdentifier";
static NSString * ParseItemsClassName = @"Items";

@interface ItemsTableViewController ()

@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSString *selectedCategory;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *itemTileImageFolder;

@end

@implementation ItemsTableViewController

-(id)initWithCategoryId:(NSString *)categoryID andCategoryName:(NSString *)categoryName{
    if ([super init]) {
        _selectedCategory = categoryID;
        _categoryName = categoryName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ItemsTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellId];
    self.itemTileImageFolder = [HelperClass pathForFileInDocumentsDirectory:@"/HM_Images/ItemsTileImages"];
    self.navigationItem.title = self.categoryName;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:footerView];
    self.itemsArray = [self fetchItemsFromCoreDataForSelectedCategory:self.selectedCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // Configure the cell...
    if ([self.itemsArray count]) {
        ItemsInCategory *itemObject = [self.itemsArray objectAtIndex:indexPath.row];
        cell.itemName.text = itemObject.itemName;
        cell.itemPrice.text = itemObject.itemPrice;
        NSString *fileName = [NSString stringWithFormat:@"%@s@2x.png",itemObject.itemObjID];
        NSString *imageName = [self.itemTileImageFolder stringByAppendingPathComponent:fileName];
        cell.itemImage.image = [UIImage imageNamed:imageName];
        cell.itemImage.layer.cornerRadius = 4;
        cell.itemImage.layer.masksToBounds = YES;
        [cell setBackgroundColor:[UIColor colorWithRed:(249/255.0) green:(249/255.0) blue:(249/255.0) alpha:1.0]];
        }
    
    
    return cell;
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ItemsInCategory *selectedItem = [self.itemsArray objectAtIndex:indexPath.row];
    ItemDetailsTableViewController *detailViewController = [[ItemDetailsTableViewController alloc] initWithSelectedItem:selectedItem andCategoryName:self.categoryName];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}


-(NSArray *)fetchItemsFromCoreDataForSelectedCategory:(NSString *)categoryID{
    NSManagedObjectContext *context=[[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDes=[NSEntityDescription entityForName:NSStringFromClass([ItemsInCategory class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entityDes];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryID == %@", categoryID];
    [fetchRequest setPredicate:predicate];
    NSError *error=nil;
    NSArray *dataArray=[context executeFetchRequest:fetchRequest error:&error];
    return dataArray;

}

@end
