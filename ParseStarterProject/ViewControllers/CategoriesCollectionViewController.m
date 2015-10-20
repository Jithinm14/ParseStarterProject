//
//  CategoriesCollectionViewController.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/17/15.
//
//

#import "CategoriesCollectionViewController.h"
#import <Parse/Parse.h>
#import "CategoryCollectionViewCell.h"
#import "ProgressIndicator.h"
#import "ServiceDataFetcher.h"
#import "ItemsTableViewController.h"
#import "MasterSyncActivityViewController.h"
#import "FoodCategory.h"

@interface CategoriesCollectionViewController ()

@property (nonatomic, strong) NSArray *categoryObjects;
@property (nonatomic, strong) ProgressIndicator *progressView;
@property (nonatomic, strong) NSString *categoryImageFolder;
@property (nonatomic, strong) UIBarButtonItem *rightBarbuttonItem;

@end

@implementation CategoriesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const ParseCategoryClassName = @"Categories";

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  [self queuryCategoriesListFromParse];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    self.navigationItem.title = @"Main Categories";
    self.rightBarbuttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItem = self.rightBarbuttonItem;
    self.categoryImageFolder = [HelperClass pathForFileInDocumentsDirectory:@"/HM_Images/CategoryImages"];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsSyncDataAvailable"]) {
        NSArray *dataArray = [[MasterSyncFromParse sharedMasterSync] fetchFromCoreData:NSStringFromClass([FoodCategory class])];
        if (dataArray) {
            self.categoryObjects = dataArray;
            [self.collectionView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.categoryObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    FoodCategory *categoryObject = [self.categoryObjects objectAtIndex:indexPath.row];
    cell.categoryNameLabel.text = categoryObject.categoryName;
    NSString *fileName = [NSString stringWithFormat:@"%@@2x.png",categoryObject.imageID];
    NSString *imageName = [self.categoryImageFolder stringByAppendingPathComponent:fileName];
    cell.categoryImage.image = [UIImage imageNamed:imageName];
    cell.categoryImage.layer.cornerRadius = 9;
    cell.categoryImage.layer.masksToBounds = YES;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FoodCategory *categoryObject = [self.categoryObjects objectAtIndex:indexPath.row];
    ItemsTableViewController *itemsList = [[ItemsTableViewController alloc] initWithCategoryId:categoryObject.categoryObjectID andCategoryName:categoryObject.categoryName];
    [self.navigationController pushViewController:itemsList animated:YES];
}

#pragma mark - Parse Query Methods

-(void)showMenu:(id)sender{
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *alertControl=[UIAlertController alertControllerWithTitle:@"Settings Menu" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertControl.view setOpaque:YES];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"Sync contents from server" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            MasterSyncActivityViewController *syncView = [[MasterSyncActivityViewController alloc] init];
            [self presentViewController:syncView animated:YES completion:nil];
                    }];
        [alertControl addAction:action1];
        if ([PFUser currentUser]) {
            UIAlertAction *action2=[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [PFUser logOutInBackground];
                
            }];
            [alertControl addAction:action2];
        }
        UIAlertAction *action3=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertControl addAction:action3];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            alertControl.popoverPresentationController.barButtonItem = sender;
            [self presentViewController:alertControl animated:NO completion:nil];
            }
        else{
            [self presentViewController:alertControl animated:YES completion:nil];
        }
    }
    else
    {
//        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"CHOOSE A PICTURE TO UPLOAD" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Pic With Camera",@"Select From Photos", nil];
//        [actionSheet showInView:self.view];
    }

}

@end
