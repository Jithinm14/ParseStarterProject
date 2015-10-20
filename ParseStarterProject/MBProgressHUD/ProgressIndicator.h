//
//  ProgressIndicator.h
//  ParseStarterProject
//
//  Created by Jithin M on 9/17/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressIndicator : NSObject

-(id)initWithView:(UIView *)view;
-(void)showProgressIndicatorWithMessage:(NSString *)message;
-(void)removeProgressIndicator;

@end
