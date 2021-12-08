//
//  AppDelegate.m
//  testWidget
//
//  Created by Admin on 2020/10/16.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapServices.h>
#import "WzLocationInfos.h"
@interface AppDelegate ()
@property (nonatomic) dispatch_source_t badgeTimer;
@property(nonatomic,strong)WzLocationInfos *LocationInfo;//定位查询
@property(strong,nonatomic)NSTimer *timer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AMapServices sharedServices].apiKey =@"ab2bc18720f8f8f3b88d54b54856aed9";
    UIUserNotificationSettings * set = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:set];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSString *widgetStr=url.absoluteString;
   
    NSLog(@"跳转到URL schema中配置的地址-->%@",url);//跳转到URL schema中配置的地址
    
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
//    //销毁定时器
//    [_timer invalidate];
//    _timer = nil;
//    [self stratBadgeNumberCount];
//    [self startBgTask];
}

- (void)startBgTask{
    UIApplication *application = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        //这里延迟的系统时间结束
        [application endBackgroundTask:bgTask];
        NSLog(@"%f",application.backgroundTimeRemaining);
    }];

}

- (void)stratBadgeNumberCount{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
        
        //加入runloop循环池
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        //开启定时器
        [_timer fire];
//    _badgeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(_badgeTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(_badgeTimer, ^{
//
//        [UIApplication sharedApplication].applicationIconBadgeNumber++;
//
//        self.LocationInfo=[WzLocationInfos new];
//        [self.LocationInfo startLocationWithScucessinfo:^(NSDictionary *locationinfo) {
//            NSLog(@"***%@",locationinfo);
//            NSString *district=[locationinfo objectForKey:@"district"];
//            NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
//            [userDf setObject:@"72321" forKey:@"currentCityID"];
//            [userDf setObject:district forKey:@"currentCity"];
//            [userDf synchronize];
//            } WithFailure:^(NSString *error) {
//            }];
//    });
//    dispatch_resume(_badgeTimer);
}
-(void)timerStart:(NSTimer *)timer{
    NSLog(@"%s-----%lf",__func__,timer.timeInterval);
//    self.LocationInfo=[WzLocationInfos new];
//    [self.LocationInfo startLocationWithScucessinfo:^(NSDictionary *locationinfo) {
//        NSLog(@"***%@",locationinfo);
//        NSString *district=[locationinfo objectForKey:@"district"];
//        NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
//        [userDf setObject:@"72321" forKey:@"currentCityID"];
//        [userDf setObject:district forKey:@"currentCity"];
//        [userDf synchronize];
//        } WithFailure:^(NSString *error) {
//        }];
 
}
@end
