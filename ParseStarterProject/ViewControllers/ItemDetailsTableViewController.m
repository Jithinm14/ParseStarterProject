//
//  ItemDetailsTableViewController.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/22/15.
//
//

#import "ItemDetailsTableViewController.h"
#import "ItemsInCategory.h"
#import "ItemDetailTableViewCell.h"
#import "ItemDetailFooterView.h"

static NSString *CellID = @"DetailCellIdentifier";

@interface ItemDetailsTableViewController ()

@property (nonatomic, strong) ItemsInCategory *selcItem;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *detailImagePath;

@end

@implementation ItemDetailsTableViewController

-(id)initWithSelectedItem:(ItemsInCategory *)selectedItem andCategoryName:(NSString *)categoryName{
    if ([super init]) {
        _selcItem = selectedItem;
        _categoryName = categoryName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.detailImagePath = [HelperClass pathForFileInDocumentsDirectory:@"/HM_Images/ItemsDetailImages"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ItemDetailTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
//    [self.tableView registerClass:[ItemDetailTableViewCell class] forCellReuseIdentifier:CellID];
}

-(void)viewWillAppear:(BOOL)animated{
//    [self.tableView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    [self.tableView setContentOffset:CGPointZero];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ItemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
        
        // Configure the cell...
        
        cell.itemName.text = self.selcItem.itemName;
        cell.itemPrice.text = self.selcItem.itemPrice;
        cell.categoryName.text = self.categoryName;
        cell.taste.text = self.selcItem.tasteDescription;
        NSString *fileName = [NSString stringWithFormat:@"%@b@2x.png",self.selcItem.imageID];
        NSString *imageName = [self.detailImagePath stringByAppendingPathComponent:fileName];
        cell.itemImage.image = [UIImage imageNamed:imageName];
        cell.itemImage.layer.cornerRadius = 9;
        cell.itemImage.layer.masksToBounds = YES;
        return cell;
    }
    else{
        ItemDetailFooterView *secondCell = (ItemDetailFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomViewSet" owner:self options:nil] objectAtIndex:1];
        [secondCell.itemDescription sizeToFit];
        secondCell.itemName.text = self.selcItem.itemName;
        secondCell.itemDescription.text = self.selcItem.itemDescription;
        secondCell.itemDescription.lineBreakMode = NSLineBreakByWordWrapping;
        secondCell.itemDescription.preferredMaxLayoutWidth = CGFLOAT_MAX;
        [secondCell.itemDescription sizeToFit];
        return secondCell;
    }
    
}


/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end
