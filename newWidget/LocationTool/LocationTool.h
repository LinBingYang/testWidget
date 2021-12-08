//
//  LocationTool.h
//  newWidgetExtension
//
//  Created by Admin on 2021/3/1.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>
#import "TreeNode.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LocationTool : NSObject<AMapLocationManagerDelegate,AMapSearchDelegate>
///<g)CLLocationManager *t_locationManager;
//@property(strong,nonatomic)CLGeocoder *geocoder;
@property (nonatomic, strong) AMapLocationManager *t_locationManager;
@property(nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (strong, nonatomic) void(^success)(NSDictionary * dataDic);
@property (strong, nonatomic) void(^failure)(NSString * error);
+(LocationTool *)defaultManager;
//-(void)startLocation;//定位
- (void)startLocationWithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure;//定位

@end

NS_ASSUME_NONNULL_END
