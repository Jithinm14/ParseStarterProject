/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import "CategoriesCollectionViewController.h"
#import "IntroEnglishViewController.h"

@interface HotelMenuAppDelegate : NSObject <UIApplicationDelegate,IntroEngControllerProtocol>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) CategoriesCollectionViewController *categoryCollectionView;

@end
