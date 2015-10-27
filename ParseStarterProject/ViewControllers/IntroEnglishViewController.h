//
//  IntroEnglishViewController.h
//  ParseStarterProject
//
//  Created by Jithin M on 10/23/15.
//
//

#import <UIKit/UIKit.h>

@protocol IntroEngControllerProtocol <NSObject>

-(void)loadCategoriesListView;

@end

@interface IntroEnglishViewController : UIViewController

@property (weak, nonatomic) id <IntroEngControllerProtocol> delegate;

@end
