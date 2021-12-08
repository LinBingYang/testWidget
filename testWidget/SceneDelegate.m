//
//  SceneDelegate.m
//  testWidget
//
//  Created by Admin on 2020/10/16.
//

#import "SceneDelegate.h"
#import "WzLocationInfos.h"
#import "testWidget-Swift.h"
@interface SceneDelegate ()
@property (nonatomic) dispatch_source_t badgeTimer;
@property(nonatomic,strong)WzLocationInfos *LocationInfo;//定位查询
@property(strong,nonatomic)NSTimer *timer;
@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
//    [self stratBadgeNumberCount];
//    [self startBgTask];
}
-(void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts{
    for (UIOpenURLContext *context in URLContexts) {
        NSURL *url=context.URL;
        NSLog(@"%@",url);
    }
    
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
//UIApplication *application = [UIApplication sharedApplication];
//    _badgeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(_badgeTimer, DISPATCH_TIME_NOW, 11.0 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
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
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    self.LocationInfo=[WzLocationInfos new];
    [self.LocationInfo startLocationWithScucessinfo:^(NSDictionary *locationinfo) {
        NSLog(@"***%@",locationinfo);
        NSString *district=[locationinfo objectForKey:@"district"];
        NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
        [userDf setObject:@"72321" forKey:@"currentCityID"];
        [userDf setObject:district forKey:@"currentCity"];
        [userDf synchronize];
        WidgetManager *wm=[[WidgetManager alloc]init];
        [wm reloadAlltimelines];
        } WithFailure:^(NSString *error) {
        }];
 
}
@end
