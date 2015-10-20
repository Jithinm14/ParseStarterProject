//
//  ItemDetailTableViewCell.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/22/15.
//
//

#import <UIKit/UIKit.h>

@interface ItemDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *taste;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end
