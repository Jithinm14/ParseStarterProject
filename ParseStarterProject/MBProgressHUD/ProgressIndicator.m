//
//  ProgressIndicator.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/17/15.
//
//

#import "ProgressIndicator.h"
#import "MBProgressHUD.h"

@interface ProgressIndicator ()

@property (nonatomic, strong) MBProgressHUD *progressView;

@end

@implementation ProgressIndicator

-(id)initWithView:(UIView *)superView{
    if ([super init]) {
        self.progressView = [[MBProgressHUD alloc] initWithView:superView];
        [superView addSubview:self.progressView];
    }
    return self;
}
-(void)showProgressIndicatorWithMessage:(NSString *)message{
    self.progressView.labelText = message;
    [self.progressView show:YES];
}
-(void)removeProgressIndicator{
    [self.progressView hide:YES];
    [self.progressView removeFromSuperview];
}
@end
