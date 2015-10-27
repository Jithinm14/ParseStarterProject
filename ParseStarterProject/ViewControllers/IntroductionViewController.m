//
//  IntroductionViewController.m
//  ParseStarterProject
//
//  Created by Jithin M on 10/21/15.
//
//

#import "IntroductionViewController.h"
#import "HotelIntroView.h"


@interface IntroductionViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)continueAction:(id)sender;
@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  [self prepareScrollView];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  //  [self prepareScrollView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareScrollView{
    
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.bounds.size.width*2, self.contentScrollView.bounds.size.height)];
    
    
    for (int i = 0; i<2; i++) {
        UIImageView *contentView = [[UIImageView alloc] init];
        HotelIntroView *hotelInfoView = (HotelIntroView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomViewSet" owner:self options:nil] objectAtIndex:2];
        CGRect frame = CGRectMake(self.contentScrollView.frame.size.width*i, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        contentView.frame = frame;
        hotelInfoView.frame =frame;
        contentView.image = [UIImage imageNamed:@"TestImage.jpg"];
        hotelInfoView.introImage.image = [UIImage imageNamed:@"TestImage.jpg"];
        
//        self.contentScrollView.minimumZoomScale = 1.0  ;
//        self.contentScrollView.maximumZoomScale = contentView.image.size.width / self.contentScrollView.frame.size.width;
//        self.contentScrollView.zoomScale = 1.0;
//        NSDictionary* viewDict = NSDictionaryOfVariableBindings(self.contentScrollView, contentView);
//        [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:0 views:viewDict]];
//        [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:0 views:viewDict]];
 
      //  contentView.image = [UIImage imageNamed:@"WelcomeEN.jpg"];
        CGRect visibleRect;
        visibleRect.origin = [self.contentScrollView contentOffset];
        visibleRect.size = [self.contentScrollView bounds].size;
       // [hotelInfoView setNeedsDisplayInRect:visibleRect];
        
        [self.contentScrollView addSubview:hotelInfoView];
        
        [self.contentScrollView addConstraint:[NSLayoutConstraint constraintWithItem:hotelInfoView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentScrollView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0]];
        [self.contentScrollView addConstraint:[NSLayoutConstraint constraintWithItem:hotelInfoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0]];
        
    }
}

- (IBAction)continueAction:(id)sender {
    IntroEnglishViewController *intrEnglish = [[IntroEnglishViewController alloc] init];
    intrEnglish.delegate = self.delegate;
    [self.navigationController pushViewController:intrEnglish animated:YES];
}
@end
