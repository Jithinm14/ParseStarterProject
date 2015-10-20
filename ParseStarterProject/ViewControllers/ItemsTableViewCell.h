//
//  ItemsTableViewCell.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/19/15.
//
//

#import <UIKit/UIKit.h>

@interface ItemsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;

@end
