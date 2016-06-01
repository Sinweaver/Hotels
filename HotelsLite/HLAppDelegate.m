//
//  AppDelegate.m
//  HotelsLite
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alexander Borovikov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "HLAppDelegate.h"

#import "HLSplitVC.h"
#import "HLHotelLoader.h"
#import "HLHotelsListVC.h"
#import "HLHotelDetailVC.h"

@interface HLAppDelegate () <UISplitViewControllerDelegate>

@property(strong, nonatomic) HLSplitVC *splitviewController;

@end

@implementation HLAppDelegate

#pragma mark - Lifecycle
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.splitviewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive
    // state; here you can undo many of the changes made on entering the
    // background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UISplitViewControllerDelegate
- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
        && [[(UINavigationController *)secondaryViewController topViewController]
            isKindOfClass:[HLHotelDetailVC class]]) {
        // Return YES to indicate that we have handled the collapse by doing
        // nothing; the secondary controller will be discarded.
        return YES;
        
    } else {
        return NO;
    }
}

#pragma mark - Getters (Private)
- (HLSplitVC *)splitviewController {
    if (!_splitviewController) {
        // Create the navigation-run root view
        HLHotelsListVC *rootVC = [[HLHotelsListVC alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc]
                                           initWithRootViewController:rootVC];
        
        // Create the navigation-run detail view
        HLHotelDetailVC *detailVC = [[HLHotelDetailVC alloc] init];
        UINavigationController *detailNav = [[UINavigationController alloc]
                                             initWithRootViewController:detailVC];
        
        // Add both to the split view controller
        _splitviewController = [[HLSplitVC alloc] init];
        _splitviewController.viewControllers = @[rootNav, detailNav];
        _splitviewController.delegate = self;
        _splitviewController.preferredDisplayMode =
        UISplitViewControllerDisplayModeAllVisible;
    }
    
    return _splitviewController;
}

@end
