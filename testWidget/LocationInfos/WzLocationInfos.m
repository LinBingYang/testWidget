//
//  WzLocationInfos.m
//  温州智天气
//
//  Created by Admin on 2018/10/9.
//  Copyright © 2018年 ztq. All rights reserved.
//

#import "WzLocationInfos.h"

static WzLocationInfos *manager ;
@interface WzLocationInfos (){
  
    BOOL issw;
    BOOL isdw;
    BOOL isMapTap;
    BOOL isShowaddress;//逐时预报显示位置信息
}
@property(assign)BOOL istownship;
@property(strong,nonatomic)NSDictionary *location_info;
@property(strong,nonatomic)NSString *DWcity,*DWid,*pname,*pname1;
@property(strong,nonatomic)NSString *loctcity,*qxcity,*lat,*lon;
@property(strong,nonatomic)NSString *provice,*swcity;

//@property(strong,nonatomic)NSMutableArray *marr;
//@property(assign)NSInteger citycount;
@end
@implementation WzLocationInfos
//+(WzLocationInfos *)defaultManager {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[WzLocationInfos alloc]init];
//    });
//    return manager;
//}
- (void)startLocationWithScucessinfo:(void (^)(NSDictionary *))success WithFailure:(void (^)(NSString *))failure
{
    self.success = success;
    self.failure = failure;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapLocationManager *amapl= [[AMapLocationManager alloc] init];
    self.t_locationManager=amapl;
    self.t_locationManager.delegate = self;
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self.t_locationManager stopUpdatingLocation];
        if (self.failure) {
            self.failure(@"1");
        }

    }
    else
    {
        
        self.t_locationManager.locationTimeout = 5;
        self.t_locationManager.reGeocodeTimeout = 3;
        self.t_locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        [self.t_locationManager startUpdatingLocation];
        
    }
}
#pragma mark--通过地区查询经纬度
- (void)AMapGeocodeSearchCity:(NSString *)city WithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure{
    self.success = success;
    self.failure = failure;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = city;
    [self.search AMapGeocodeSearch:geo];

    return;
}
#pragma mark--通过经纬度查询城市信息
- (void)AMapGeocodeReSearchCityWithCLLocation:(CLLocation *)location WithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure{
    self.success = success;
    self.failure = failure;
    isMapTap=YES;
    self.lat=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.lon=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
}
#pragma mark--通过经纬度查询城市信息没有定位更新首页城市
- (void)AMapGeocodeReSearchCityNoDwWithCLLocation:(CLLocation *)location WithScucessinfo:(void (^)(NSDictionary * locationinfo))success WithFailure:(void (^)(NSString * error))failure{
    self.success = success;
    self.failure = failure;
    isShowaddress=YES;
    self.lat=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.lon=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
}
#pragma mark--获取对应区域的行政区划边界
- (void)AMasearchDistrictWithName:(NSString *)name WithScucessinfo:(void (^)(AMapDistrictSearchResponse * response))response WithFailure:(void (^)(NSString * error))failure{
    self.response = response;
    self.failure = failure;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = name;
    dist.requireExtension = YES;
    [self.search AMapDistrictSearch:dist];
}
#pragma mark - AMapSearchDelegate行政
- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    [self.search AMapDistrictSearch:request];
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    if (self.response) {
        self.response(response);
    }
}
#pragma mark - 定位失败
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.t_locationManager stopUpdatingLocation];
    if (self.failure) {
        self.failure(@"1");
    }
    
    
}
#pragma mark定位成功
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{

    [self.t_locationManager stopUpdatingLocation];
    self.t_locationManager.delegate=nil;
    self.lat=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.lon=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

    regeo.location                    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];


}
//-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
//    NSString *province=reGeocode.province;
//    NSString *gj_name=reGeocode.country;
//    NSString *city=reGeocode.city;
//    NSString *district=reGeocode.district;
//    NSString *township=reGeocode.township;
//    NSString *formattedAddress=reGeocode.formattedAddress;
//
//    NSString *country= formattedAddress;
//    if (city.length>0) {
//        if ([country rangeOfString:city options:NSLiteralSearch].location!=NSNotFound) {
//            NSArray *timeArray1=[country componentsSeparatedByString:city];
//            country=[timeArray1 objectAtIndex:1];
////                if (district.length>0) {
////                    if ([country rangeOfString:district options:NSLiteralSearch].location!=NSNotFound) {
////                        NSArray *timeArray1=[country componentsSeparatedByString:district];
////                        country=[timeArray1 objectAtIndex:1];
////
////                    }
////                }
////                country=[self removeStrxtys:country];
////                NSLog(@"***%@",country);
//        }
//
//    }
//    NSString *streetinfo=country;
//
//
//    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
//    NSDictionary *addressdic=[NSDictionary dictionaryWithObjectsAndKeys:self.lat,@"lat",self.lon,@"lon",country,@"address",streetinfo,@"street", province,@"province",township,@"township",city,@"city",district,@"district",nil];
//    [userDef setObject:addressdic forKey:@"formattedAddress"];
//    [userDef synchronize];//定位信息
//
//    self.location_info=addressdic;
//    if (self.success) {
//        self.success(self.location_info);
//    }
//}
-(void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}
#pragma mark - AMapSearchDelegate地理编码
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    if (response.regeocode != nil)
    {
        AMapReGeocode *myregeocode=response.regeocode;
     
        NSString *province=myregeocode.addressComponent.province;
        NSString *gj_name=myregeocode.addressComponent.country;
        NSString *city=myregeocode.addressComponent.city;
        NSString *district=myregeocode.addressComponent.district;
        NSString *township=myregeocode.addressComponent.township;
        NSString *formattedAddress=myregeocode.formattedAddress;

        NSString *country= formattedAddress;
        if (city.length>0) {
            if ([country rangeOfString:city options:NSLiteralSearch].location!=NSNotFound) {
                NSArray *timeArray1=[country componentsSeparatedByString:city];
                country=[timeArray1 objectAtIndex:1];
//                if (district.length>0) {
//                    if ([country rangeOfString:district options:NSLiteralSearch].location!=NSNotFound) {
//                        NSArray *timeArray1=[country componentsSeparatedByString:district];
//                        country=[timeArray1 objectAtIndex:1];
//
//                    }
//                }
//                country=[self removeStrxtys:country];
//                NSLog(@"***%@",country);
            }

        }
        NSString *streetinfo=country;

        NSLog(@"***%@",country);
        if ([province isEqualToString:@"福建省"]){//过滤详细位置信息重复数据
            streetinfo = [streetinfo stringByReplacingOccurrencesOfString:township withString:@""];
            streetinfo = [streetinfo stringByReplacingOccurrencesOfString:district withString:@""];

        }else{
         
            streetinfo = [streetinfo stringByReplacingOccurrencesOfString:district withString:@""];
        }
        
        if (myregeocode.addressComponent.streetNumber.street.length>0&&myregeocode.addressComponent.streetNumber.number.length>0) {
            streetinfo=[NSString stringWithFormat:@"%@%@",myregeocode.addressComponent.streetNumber.street,myregeocode.addressComponent.streetNumber.number];
        }else if(myregeocode.addressComponent.streetNumber.street.length>0){
            streetinfo=myregeocode.addressComponent.streetNumber.street;
        }
        NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
        NSDictionary *addressdic=[NSDictionary dictionaryWithObjectsAndKeys:self.lat,@"lat",self.lon,@"lon",country,@"address",streetinfo,@"street", province,@"province",township,@"township",city,@"city",district,@"district",nil];
        [userDef setObject:addressdic forKey:@"formattedAddress"];
        [userDef synchronize];//定位信息
        
        self.location_info=addressdic;
        if (province.length>0&&city.length>0){
            
            NSLog(@"反向地理编码成功，城市： %@ &&& %@",district,township);
       
            self.loctcity=city;
            self.qxcity=district;
            if ([district rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound)
            {
                NSArray* arr = [district componentsSeparatedByString:@"市"];
                if ([arr count] > 0)
                {
                    self.qxcity = [NSString stringWithFormat:@"%@", [arr objectAtIndex:0]];
                }
            }
            if (township.length>0) {
                self.DWcity=township;
            }else if (district.length>0){
                self.DWcity=district;
            }else{
                self.DWcity=city;
            }
            
            self.DWid=nil;
            
            
            
            


        
        if (self.success) {
            self.success(self.location_info);
        }
        
    }
    
    }
    
}
#pragma mark - AMapSearchDelegate逆向地理编码查经纬度
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        self.failure(@"1");
        return;
    }else{
        AMapGeocode *gecode=response.geocodes.firstObject;
        AMapGeoPoint *location=gecode.location;
        CLLocation *lc=[[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
//        NSLog(@"%f^^^%f",location.latitude,location.longitude);
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:lc,@"city", nil];
//        NSString *str=[NSString stringWithFormat:@"%@,%@,%lf,%lf",gecode.province,[NSString stringWithFormat:@"%@,%@",gecode.city,gecode.district],lc.coordinate.latitude,lc.coordinate.longitude];
//
//        self.citycount=self.citycount+1;
//        NSLog(@"%@,%@,%lf,%lf,%ld/%ld",gecode.formattedAddress,[NSString stringWithFormat:@"%@,%@",gecode.city,gecode.district],lc.coordinate.latitude,lc.coordinate.longitude,self.citycount,[m_treeNodelovecity.children count]);
//        [self.marr addObject:str];
//        if (self.citycount==[m_treeNodelovecity.children count]-1) {
//            NSLog(@"*** %@",self.marr);
//        }
        
        self.success(dic);
    }
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    self.failure(@"1");
}
//-(void)recogedCity{
//
//
//    self.t_locationManager.delegate=nil;
//    [self.t_locationManager stopUpdatingLocation];
//    [self.t_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//
//        }
//
//        if (regeocode)
//        {
//            if (regeocode.province.length>0) {
//
//                NSLog(@"反向地理编码成功，城市： %@ &&& %@",regeocode.district,regeocode.township);
//                //省外测试
//                //                regeocode.city=@"广州市";
//                //                regeocode.district=@"白云区";
//                //                regeocode.province=@"广东省";
//                //                regeocode.street=@"北太路";
//
//                self.loctcity=regeocode.city;
//                self.qxcity=regeocode.district;
//                if ([regeocode.district rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound)
//                {
//                    NSArray* arr = [regeocode.district componentsSeparatedByString:@"市"];
//                    if ([arr count] > 0)
//                    {
//                        self.qxcity = [NSString stringWithFormat:@"%@", [arr objectAtIndex:0]];
//                    }
//                }
//                if (regeocode.township.length>0) {
//                    self.DWcity=regeocode.township;
//                }else if (regeocode.district.length>0){
//                    self.DWcity=regeocode.district;
//                }else{
//                    self.DWcity=regeocode.city;
//                }
//
//                self.DWid=nil;
//
//                if ([regeocode.province isEqualToString:@"福建省"]) {
//                    if (self.DWcity.length>0) {
//                        self.DWid=[self readXML:self.DWcity];
//                    }
//
//                }else{
//                    if (regeocode.province.length>0) {
//                        self.provice=[regeocode.province substringToIndex:[regeocode.province length]-1];
//                    }
//                    //                    [setting sharedSetting].launchcity=regeocode.city;
//                }
//
//                NSString *country = regeocode.formattedAddress;
//                if (regeocode.city.length>0) {
//                    if ([country rangeOfString:regeocode.city options:NSLiteralSearch].location!=NSNotFound) {
//                        NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
//                        country=[timeArray1 objectAtIndex:1];
//
//
//                    }
//                }
//                NSString *streetinfo=country;
//                if (regeocode.township.length>0) {
//                    if ([country rangeOfString:regeocode.township options:NSLiteralSearch].location!=NSNotFound) {
//                        NSArray *timeArray1=[country componentsSeparatedByString:regeocode.township];
//                        streetinfo=[timeArray1 objectAtIndex:1];
//
//
//                    }
//                }else if (regeocode.district.length>0){
//                    if ([country rangeOfString:regeocode.district options:NSLiteralSearch].location!=NSNotFound) {
//                        NSArray *timeArray1=[country componentsSeparatedByString:regeocode.district];
//                        streetinfo=[timeArray1 objectAtIndex:1];
//
//
//                    }
//                }
//                if (regeocode.street.length>0&&regeocode.number.length>0) {
//                    streetinfo=[NSString stringWithFormat:@"%@%@",regeocode.street,regeocode.number];
//                }
//                NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
//                double lat=location.coordinate.latitude;
//                double lon=location.coordinate.longitude;
//                NSDictionary *addressdic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",lat],@"lat",[NSString stringWithFormat:@"%f",lon],@"lon",country,@"address",streetinfo,@"street", regeocode.province,@"province",regeocode.township,@"township",regeocode.city,@"city",regeocode.district,@"district",nil];
//                [userDef setObject:addressdic forKey:@"formattedAddress"];
//                [userDef synchronize];
//
//
//                if (country.length>8) {
//                    [setting sharedSetting].locatcity=[country substringFromIndex:8];
//                }else{
//                    [setting sharedSetting].locatcity=country;
//                }
//
//                [[setting sharedSetting] saveSetting];
//                //                regeocode.province=@"北京市";
//                if (![regeocode.province isEqualToString:@"福建省"]) {
//
//                    NSArray *t_array = [regeocode.district componentsSeparatedByString:@"市"];
//                    if ([regeocode.district rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound) {
//                        if ([t_array count] > 0)
//                        {
//                            self.DWcity = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
//                            if (self.DWcity.length>0) {
//                                self.DWid=[self readswXML:self.DWcity];
//                            }
//
//                        }
//                    }else if ([regeocode.district rangeOfString:@"区"options:NSLiteralSearch].location != NSNotFound)
//                    {
//                        if (!self.DWid.length>0) {
//                            self.DWcity=regeocode.district;
//                            self.DWid=[self readswXML:regeocode.district];
//                            if (self.DWid.length==0) {
//                                t_array = [regeocode.district componentsSeparatedByString:@"区"];
//
//                                if ([t_array count] > 0)
//                                {
//                                    self.DWcity = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
//                                }
//                                if (self.DWcity.length>0) {
//                                    self.DWid=[self readswXML:self.DWcity];
//                                }
//
//                            }
//                        }
//                    }else if ([regeocode.district rangeOfString:@"县"options:NSLiteralSearch].location != NSNotFound)
//                    {
//                        if (!self.DWid.length>0) {
//                            self.DWcity=regeocode.district;
//                            self.DWid=[self readswXML:regeocode.district];
//                            if (self.DWid.length==0) {
//                                t_array = [regeocode.district componentsSeparatedByString:@"县"];
//
//                                if ([t_array count] > 0)
//                                {
//                                    self.DWcity = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
//                                }
//                                if (self.DWcity.length>0) {
//                                    self.DWid=[self readswXML:self.DWcity];
//                                }
//                            }
//
//                        }
//                    }
//
//                    if (!self.DWid.length>0) {
//                        t_array = [regeocode.city componentsSeparatedByString:@"市"];
//
//                        if ([t_array count] > 0)
//                        {
//                            self.DWcity = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
//                        }
//                        if (self.DWcity.length>0) {
//                            self.DWid=[self readswXML:self.DWcity];
//                        }
//                        if ([regeocode.province rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound) {
//                            if ([t_array count] > 0)
//                            {
//                                self.DWcity = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
//                                if (self.DWcity.length>0) {
//                                    self.DWid=[self readswXML:self.DWcity];
//                                }
//                            }
//                        }
//                    }
//                    [setting sharedSetting].zqzbID = self.DWid;
//                    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"省外",@"sw",self.DWcity ,@"city",self.DWid,@"ID", nil];
//
//                    //定位开关是否开启
//                    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
//                    if (isdw==YES) {
//                        NSString *c=regeocode.city;
//                        if ([regeocode.city rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound) {
//                            NSArray *arr=[c componentsSeparatedByString:@"市"];
//                            c=arr[0];
//                        }
//
//                        NSString *descity=[NSString stringWithFormat:@"%@.%@.%@",regeocode.province,c,regeocode.district];
//                        NSString *provice=regeocode.province;
//                        if ([regeocode.province rangeOfString:@"省"options:NSLiteralSearch].location != NSNotFound) {
//                            NSArray *a=[regeocode.province componentsSeparatedByString:@"省"];
//                            if (a.count>0) {
//                                provice=a[0];
//                            }
//                        }
//                        if ([regeocode.province rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound) {
//                            NSArray *a=[regeocode.province componentsSeparatedByString:@"市"];
//                            if (a.count>0) {
//                                provice=a[0];
//                            }
//                        }
//                        [setting sharedSetting].Pcity=provice;
//                        if ([provice isEqualToString:c]) {
//                            if ([c isEqualToString:self.DWcity]) {
//                                descity=[NSString stringWithFormat:@"%@",self.DWcity];
//                            }else{
//                                if (c.length>0) {
//                                    descity=[NSString stringWithFormat:@"%@.%@",c,self.DWcity];
//                                }
//
//                            }
//
//                        }else{
//                            descity=[NSString stringWithFormat:@"%@.%@.%@",provice,c,self.DWcity];
//                        }
//                        if ([self.DWcity rangeOfString:c options:NSLiteralSearch].location != NSNotFound||[c rangeOfString:self.DWcity options:NSLiteralSearch].location != NSNotFound) {
//                            descity=[NSString stringWithFormat:@"%@.%@",provice,self.DWcity];
//                            if ([self.DWcity rangeOfString:provice options:NSLiteralSearch].location != NSNotFound) {
//                                descity=[NSString stringWithFormat:@"%@",self.DWcity];
//                            }
//                        }
//                        [setting sharedSetting].descity=descity;
//                        //                        ex_descity=descity;
//                        issw=YES;
//                        [setting sharedSetting].issw=@"1";
//                        if (![[setting sharedSetting].citys containsObject:dic]) {
//                            if ([setting sharedSetting].citys.count==0) {
//                                [[setting sharedSetting].citys addObject:dic];
//                                [[setting sharedSetting] saveSetting];
//                            }else{
//                                if (![self.DWcity isEqualToString:[setting sharedSetting].dingweicity]) {
//                                    //                                    [[setting sharedSetting].citys removeObjectAtIndex:0];
//                                    if ([setting sharedSetting].dingweicity==nil) {
//                                        [[setting sharedSetting].citys insertObject:dic atIndex:0 ];
//                                    }else
//                                        [[setting sharedSetting].citys replaceObjectAtIndex:0 withObject:dic];
//                                }else{
//                                    [[setting sharedSetting].citys insertObject:dic atIndex:0 ];
//                                }
//                                [[setting sharedSetting] saveSetting];
//                            }
//                        }
//                        else{
//
//                            for (int k=0; k<[setting sharedSetting].citys.count; k++) {
//                                NSDictionary *nowdic=[[setting sharedSetting].citys objectAtIndex:k];
//                                if ([dic isEqual:nowdic]) {
//                                    [[setting sharedSetting].citys removeObject:nowdic];
//                                }
//                            }
//                            [[setting sharedSetting].citys insertObject:dic atIndex:0 ];
//                        }
//                        if (![setting sharedSetting].currentCity.length>0) {
//                            [setting sharedSetting].currentCity=@"福州市";
//                            [setting sharedSetting].currentCityID=@"30900";
//                            [setting sharedSetting].xianshiid=@"1069";
//                        }
//                        [setting sharedSetting].dingweicity=self.DWcity;
//                        [setting sharedSetting].currentCity=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"city"];
//                        [setting sharedSetting].currentCityID=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"ID"];
////                        [setting sharedSetting].morencity=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"city"];
////                        [setting sharedSetting].morencityID=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"ID"];
//                        [setting sharedSetting].xianshi=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"city"];
//                        [setting sharedSetting].xianshiid=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"ID"];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingweiupdata" object:nil];
//                        [[setting sharedSetting] saveSetting];
//                    }
//
//
//
//                }else{
//#pragma mark-----福建省
//                    if (self.DWid.length>0) {
//                        NSString *street=nil;
//                        [setting sharedSetting].zqzbID = self.DWid;
//                        if (regeocode.district.length>0) {
//                            if ([country rangeOfString:regeocode.district options:NSLiteralSearch].location!=NSNotFound) {
//                                NSArray *timeArray1=[country componentsSeparatedByString:regeocode.district];
//                                street=[timeArray1 objectAtIndex:1];
//                            }
//
//                        }else if (regeocode.city.length>0) {
//                            if ([country rangeOfString:regeocode.city options:NSLiteralSearch].location!=NSNotFound) {
//                                NSArray *timeArray1=[country componentsSeparatedByString:regeocode.city];
//                                street=[timeArray1 objectAtIndex:1];
//                            }
//
//                        }
//
//                        [[NSUserDefaults standardUserDefaults]setObject:street forKey:@"locationaddress"];
//
//                        [[NSUserDefaults standardUserDefaults]setObject:street forKey:@"zqzblocatinAddress"];
//
//
//
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//                        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.DWcity,@"city",self.DWid,@"ID", nil];
//
//                        [[NSUserDefaults standardUserDefaults]synchronize];
//
//                        BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
//                        if (isdw==YES) {
//                            NSString *c=regeocode.city;
//                            if ([regeocode.city rangeOfString:@"市"options:NSLiteralSearch].location != NSNotFound) {
//                                NSArray *arr=[c componentsSeparatedByString:@"市"];
//                                c=arr[0];
//                                self.pname=c;
//                            }
//
//                            NSString *descity=[NSString stringWithFormat:@"%@.%@.%@",c,regeocode.district,regeocode.township];
//
//                            if ([self iscontationstressWithtownship:self.DWcity WithPnameid:[setting sharedSetting].xianshiid]==YES) {
//                                if (self.pname1.length>0&&self.DWcity.length>0) {
//                                    descity=[NSString stringWithFormat:@"%@.%@.%@",c,self.pname1,self.DWcity];
//                                    if ([self.DWcity rangeOfString:self.pname1 options:NSLiteralSearch].location != NSNotFound||[self.pname1  rangeOfString:self.DWcity options:NSLiteralSearch].location != NSNotFound) {
//                                        descity=[NSString stringWithFormat:@"%@.%@",c,self.DWcity];
//                                        if ([self.DWcity rangeOfString:c options:NSLiteralSearch].location != NSNotFound||[c rangeOfString:self.DWcity options:NSLiteralSearch].location != NSNotFound) {
//                                            descity=[NSString stringWithFormat:@"%@",self.DWcity];
//                                        }
//                                    }
//                                }else{
//                                    descity=[NSString stringWithFormat:@"%@",c];
//                                }
//                            }else{
//                                if (self.pname1.length>0) {
//                                    descity=[NSString stringWithFormat:@"%@.%@",c,regeocode.district];
//                                    if ([regeocode.district rangeOfString:c options:NSLiteralSearch].location != NSNotFound) {
//                                        descity=[NSString stringWithFormat:@"%@",c];
//
//                                    }
//                                }else{
//                                    descity=[NSString stringWithFormat:@"%@",c];
//                                }
//                            }
//
//                            if ([regeocode.district rangeOfString:@"平潭"options:NSLiteralSearch].location != NSNotFound) {
//                                if (self.DWcity.length>0) {
//                                    if ([self.DWcity rangeOfString:@"平潭"options:NSLiteralSearch].location != NSNotFound) {
//                                        descity=@"平潭";
//                                    }else
//                                    descity=[NSString stringWithFormat:@"平潭.%@",self.DWcity];
//                                }
//                            }
//                            [setting sharedSetting].Pcity=self.pname;
//                            [setting sharedSetting].descity=descity;
//                            zqzbLoctionCity=descity;
//                            //                            ex_descity=descity;
//                            issw=NO;
//                            [setting sharedSetting].issw=@"0";
//                            if (![[setting sharedSetting].citys containsObject:dic]) {
//
//
//                                if ([setting sharedSetting].citys.count==0) {
//                                    [[setting sharedSetting].citys addObject:dic];
//                                    [[setting sharedSetting] saveSetting];
//                                }else{
//                                    if (![self.DWcity isEqualToString:[setting sharedSetting].dingweicity]) {
//                                        if ([setting sharedSetting].dingweicity==nil) {
//                                            [[setting sharedSetting].citys insertObject:dic atIndex:0 ];//无定位城市
//                                        }else
//                                            [[setting sharedSetting].citys replaceObjectAtIndex:0 withObject:dic];//有定位城市
//                                    }else{
//                                        [[setting sharedSetting].citys insertObject:dic atIndex:0 ];
//                                    }
//                                    [[setting sharedSetting] saveSetting];
//                                }
//
//                            }
//                            else{
//
//                                for (int k=0; k<[setting sharedSetting].citys.count; k++) {
//
//                                    NSDictionary *nowdic=[[setting sharedSetting].citys objectAtIndex:k];
//
//                                    if ([dic isEqual:nowdic]) {
//                                        [[setting sharedSetting].citys removeObject:nowdic];
//
//                                    }
//                                }
//                                [[setting sharedSetting].citys insertObject:dic atIndex:0];
//
//
//                            }
//                            [setting sharedSetting].dingweicity=self.DWcity;
//                            [setting sharedSetting].currentCity=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"city"];
//                            [setting sharedSetting].currentCityID=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"ID"];
////                            [setting sharedSetting].morencity=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"city"];
////                            [setting sharedSetting].morencityID=[[[setting sharedSetting].citys objectAtIndex:0] objectForKey:@"ID"];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingweiupdata" object:nil];
//                            [[setting sharedSetting] saveSetting];
//                        }
//                    }
//
//                }
//            }
//        }
//        if (isdw==NO) {
//            //加载主题
//            isdw=YES;
//        }
//    }];
//}





-(NSString *)removeStrxtys:(NSString *)origStr{
    NSString *temp = nil;
    NSMutableArray *arr_0 = [NSMutableArray new];
    for(int i =0; i < [origStr length]; i++)
    {
        temp = [origStr substringWithRange:NSMakeRange(i, 1)];
        BOOL isbool = [arr_0 containsObject:temp];
        if (!isbool) {
            [arr_0 addObject:temp];
        }
    }
    NSString *result = [arr_0 componentsJoinedByString:@""];
    return result;
}
@end
