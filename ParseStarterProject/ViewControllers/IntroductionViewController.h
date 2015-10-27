//
//  IntroductionViewController.h
//  ParseStarterProject
//
//  Created by Jithin M on 10/21/15.
//
//

#import <UIKit/UIKit.h>
#import "IntroEnglishViewController.h"

@interface IntroductionViewController : UIViewController

@property (weak, nonatomic) id <IntroEngControllerProtocol> delegate;

@end
