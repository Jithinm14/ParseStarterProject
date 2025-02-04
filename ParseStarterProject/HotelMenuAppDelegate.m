/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Parse/Parse.h>

// If you want to use any of the UI components, uncomment this line
// #import <ParseUI/ParseUI.h>

// If you are using Facebook, uncomment this line
// #import <ParseFacebookUtils/PFFacebookUtils.h>

// If you want to use Crash Reporting - uncomment this line
// #import <ParseCrashReporting/ParseCrashReporting.h>

#import "HotelMenuAppDelegate.h"
#import "IntroductionViewController.h"

@interface HotelMenuAppDelegate ()

@property (strong, nonatomic) UINavigationController *rootController;
@property (strong, nonatomic) IntroductionViewController *introController;

@end

@implementation HotelMenuAppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       // Enable storing and querying data from Local Datastore. Remove this line if you don't want to
    // use Local Datastore features or want to use cachePolicy.
    [Parse enableLocalDatastore];
    [self setAppearance];
    // ****************************************************************************
    // Uncomment this line if you want to enable Crash Reporting
    // [ParseCrashReporting enable];
    //
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"OhOJ59OdLkyrJ9KHeFmW5BSW52UN6ojvYEZi8OSx"
                  clientKey:@"WVpEsQFi7sj2jHR2BPBf70GpE1mDleRBCVCganJs"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************

  //  [PFUser enableAutomaticUser];

    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];

    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.introController = [[IntroductionViewController alloc] init];
    self.introController.delegate = self;
    self.rootController = [[UINavigationController alloc] initWithRootViewController:self.introController];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];

//    if (application.applicationState != UIApplicationStateBackground) {
//        // Track an app open here if we launch with a push, unless
//        // "content_available" was used to trigger a background push (introduced in iOS 7).
//        // In that case, we skip tracking here to avoid double counting the app-open.
//        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
//        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
//        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//        }
//    }
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                        UIUserNotificationTypeBadge |
//                                                        UIUserNotificationTypeSound);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                                 categories:nil];
//        [application registerUserNotificationSettings:settings];
//        [application registerForRemoteNotifications];
//    } else
//#endif
//    {
//        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                         UIRemoteNotificationTypeAlert |
//                                                         UIRemoteNotificationTypeSound)];
//    }

    return YES;
}

#pragma mark Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];

    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
        } else {
            NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];

    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

///////////////////////////////////////////////////////////
// Uncomment this method if you want to use Push Notifications with Background App Refresh
///////////////////////////////////////////////////////////
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    if (application.applicationState == UIApplicationStateInactive) {
//        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
//    }
//}

#pragma mark Facebook SDK Integration

///////////////////////////////////////////////////////////
// Uncomment this method if you are using Facebook
///////////////////////////////////////////////////////////
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [PFFacebookUtils handleOpenURL:url];
//}

#pragma mark - SetUpNavigationBar Appearance

-(void)setAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(246/255.0) green:(132/255.0) blue:(9/255.0) alpha:1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:18.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

#pragma mark - IntroEngControllerProtocol Methods.

-(void)loadCategoriesListView{
    self.introController = nil;
    self.rootController = nil;
    self.categoryCollectionView = [[CategoriesCollectionViewController alloc] initWithNibName:NSStringFromClass([CategoriesCollectionViewController class]) bundle:[NSBundle mainBundle]];
    self.rootController = [[UINavigationController alloc] initWithRootViewController:self.categoryCollectionView];
    self.window.rootViewController = self.rootController;
}

@end
