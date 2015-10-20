//
//  MasterSyncActivityViewController.m
//  ParseStarterProject
//
//  Created by Jithin M on 9/20/15.
//
//

#import "MasterSyncActivityViewController.h"
#import "MasterSyncFromParse.h"

@interface MasterSyncActivityViewController ()

@property (nonatomic, strong) ProgressIndicator *progressView;
@property (nonatomic, copy) void(^completionBlock)(void);
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpacingLayoutConstraint;

- (IBAction)loginUserAction:(id)sender;
- (IBAction)cancelLoginAction:(id)sender;

@end

@implementation MasterSyncActivityViewController

-(id)initWithCompletionBlock:(void (^)(void))completionBlock{
    if ([super init]) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginView.layer.cornerRadius = 9;
    self.loginView.layer.masksToBounds = YES;
    if ([PFUser currentUser]) {
        [self.loginView setHidden:YES];
        [self startSyncFromParseForUser:[PFUser currentUser]];
    }
}

-(void)startSyncFromParseForUser:(PFUser *)user{
    self.progressView = [[ProgressIndicator alloc] initWithView:self.view];
    [self.progressView showProgressIndicatorWithMessage:@"Please wait, Sync in progress"];
    MasterSyncFromParse __block *masterSync = [MasterSyncFromParse sharedMasterSync];
    [masterSync doMasterSyncFromParseWithCompletionBlock:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsSyncDataAvailable"];
        masterSync = nil;
        [self.progressView removeProgressIndicator];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
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

- (IBAction)loginUserAction:(id)sender {
    [self.view endEditing:YES];
    [self animateLoginViewToBottom];
    NSString *userName = [self.userNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *password = [self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *PF_NULLABLE_S user, NSError *PF_NULLABLE_S error){
        if (!error) {
            [self.loginView setHidden:YES];
            [self startSyncFromParseForUser:[PFUser currentUser]];
        }
        else{
            [self.loginView setHidden:YES];
            if (NSClassFromString(@"UIAlertController")) {
                UIAlertController *alertControl=[UIAlertController alertControllerWithTitle:@"Login Failed" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                [alertControl.view setOpaque:YES];
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.loginView setHidden:NO];
                }];
                [alertControl addAction:action1];
                [self presentViewController:alertControl animated:YES completion:nil];
            }
        }
    }];
}

- (IBAction)cancelLoginAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self animateLoginViewToBottom];
    return [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateLoginViewToTop];
}

-(void)animateLoginViewToBottom{
    if (self.topSpacingLayoutConstraint.constant == 14) {
        [UIView animateWithDuration:9.0 animations:^{
            self.topSpacingLayoutConstraint.constant = 108;
        }];
    }
}

-(void)animateLoginViewToTop{
    if (self.topSpacingLayoutConstraint.constant == 108) {
        [UIView animateWithDuration:9.0 animations:^{
            self.topSpacingLayoutConstraint.constant = 14;
        }];
    }
}

@end
