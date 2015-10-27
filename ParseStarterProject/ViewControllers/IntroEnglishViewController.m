//
//  IntroEnglishViewController.m
//  ParseStarterProject
//
//  Created by Jithin M on 10/23/15.
//
//

#import "IntroEnglishViewController.h"

@interface IntroEnglishViewController ()
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *continueAction;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)continueButtonAction:(id)sender;

@end

@implementation IntroEnglishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    self.backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.continueAction.titleLabel.textAlignment = NSTextAlignmentLeft;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)continueButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loadCategoriesListView)]) {
        [self.delegate loadCategoriesListView];
    }
}
@end
