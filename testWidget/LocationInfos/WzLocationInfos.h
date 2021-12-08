//
//  WzLocationInfos.h
//  温州智天气
//
//  Created by Admin on 2018/10/9.
//  Copyright © 2018年 ztq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface WzLocationInfos : NSObject<AMapLocationManagerDelegate,AMapSearchDelegate>{
    
}

@property(nonatomic,strong)AMapLocationManager *t_locationManager;
@property(nonatomic,strong)AMapSearchAPI *search;
@property (strong, nonatomic) void(^success)(NSDictionary * dataDic);
@property (strong, nonatomic) void(^failure)(NSString * error);
@property (strong, nonatomic) void(^response)(AMapDistrictSearchResponse * response);
//+(WzLocationInfos *)defaultManager;
- (void)startLocationWithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure;//定位
- (void)AMapGeocodeSearchCity:(NSString *)city WithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure;//通过城市查询经纬度
- (void)AMapGeocodeReSearchCityWithCLLocation:(CLLocation *)location WithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure;//通过经纬度查询城市信息
- (void)AMasearchDistrictWithName:(NSString *)name WithScucessinfo:(void (^)(AMapDistrictSearchResponse * response))response WithFailure:(void (^)(NSString * error))failure;//获取行政区划
- (void)AMapGeocodeReSearchCityNoDwWithCLLocation:(CLLocation *)location WithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure;
@end
