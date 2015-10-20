//
//  MasterSyncActivityViewController.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/20/15.
//
//

#import <UIKit/UIKit.h>

@interface MasterSyncActivityViewController : UIViewController<UITextFieldDelegate>

-(id)initWithCompletionBlock:(void (^)(void))completionBlock;

@end
