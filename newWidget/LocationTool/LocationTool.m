//
//  LocationTool.m
//  newWidgetExtension
//
//  Created by Admin on 2021/3/1.
//

#import "LocationTool.h"

static LocationTool *manager ;
@interface LocationTool (){
  
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
@implementation LocationTool
+(LocationTool *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationTool alloc]init];
        [AMapServices sharedServices].apiKey =@"bd1ed7f128e501dc1ae0b69a76c98743";
    });
    return manager;
}
- (void)startLocation
{

    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
    NSMutableArray *list=[userDf objectForKey:@"arealist"];
//    self.geocoder = [[CLGeocoder alloc] init];
//    CLLocationManager *amapl= [[CLLocationManager alloc] init];
//    self.t_locationManager=amapl;
//    self.t_locationManager.delegate = self;
//    //设置定位精度和位置更新最小距离
//    self.t_locationManager.distanceFilter = 100;
//    self.t_locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//    [self.t_locationManager requestAlwaysAuthorization];
//    [self.t_locationManager startUpdatingLocation];
}

- (void)startLocationWithScucessinfo:(void (^)(NSDictionary *))success WithFailure:(void (^)(NSString *))failure
{
    self.success = success;
    self.failure = failure;
    
    
    AMapLocationManager *amapl= [[AMapLocationManager alloc] init];
    self.t_locationManager=amapl;
    self.t_locationManager.delegate = self;
    //设置定位精度和位置更新最小距离
    self.t_locationManager.distanceFilter = 100;
    self.t_locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [self.t_locationManager startUpdatingLocation];
    //进行单次带逆地理定位请求
//    [self.t_locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}


//#pragma mark - 定位失败
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//
//}
//#pragma mark定位成功
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    CLLocation *location = [locations firstObject];//取出第一个位置
//        /*
//            使用位置前, 务必判断当前获取的位置是否有效
//            如果水平精确度小于零, 代表虽然可以获取位置对象, 但是数据错误, 不可用
//         */
//        if (location.horizontalAccuracy < 0)
//            return;
//        CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
//    [self.geocoder reverseGeocodeLocation:location
//                            completionHandler:^(NSArray *placemarks, NSError *error) {
//            CLPlacemark *placemark = [placemarks firstObject];
//            NSLog(@"详细信息:%@",placemark.addressDictionary);
//        }];
//        //如果不需要实时定位，使用完即使关闭定位服务
//        [self.t_locationManager stopUpdatingLocation];
//}
#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
}
#pragma mark - Initialization

- (void)initCompleteBlock
{
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.userInfo);
            self.failure(@"1");
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.userInfo);
            self.failure(@"1");
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.userInfo);
            self.failure(@"1");
            //存在虚拟定位的风险的定位结果
            __unused CLLocation *riskyLocateResult = [error.userInfo objectForKey:@"AMapLocationRiskyLocateResult"];
            //存在外接的辅助定位设备
            __unused NSDictionary *externalAccressory = [error.userInfo objectForKey:@"AMapLocationAccessoryInfo"];
            
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        if (regeocode)
        {
            NSString *province=regeocode.province;
            NSString *gj_name=regeocode.country;
            NSString *city=regeocode.city;
            NSString *district=regeocode.district;
            NSString *township=regeocode.township;
            NSString *formattedAddress=regeocode.formattedAddress;
            NSDictionary *addressdic=[NSDictionary dictionaryWithObjectsAndKeys: province,@"province",township,@"township",city,@"city",district,@"district",nil];
            self.success(addressdic);
        }
       
    };
}
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
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

    regeo.location                    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];


}
#pragma mark - AMapSearchDelegate地理编码
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    if (response.regeocode != nil)
    {
        AMapReGeocode *myregeocode=response.regeocode;
     
        NSString *province=myregeocode.addressComponent.province;
//        NSString *gj_name=myregeocode.addressComponent.country;
        NSString *city=myregeocode.addressComponent.city;
        NSString *district=myregeocode.addressComponent.district;
        NSString *township=myregeocode.addressComponent.township;
        NSString *formattedAddress=myregeocode.formattedAddress;

        NSString *country= formattedAddress;
        if (city.length>0) {
            if ([country rangeOfString:city options:NSLiteralSearch].location!=NSNotFound) {
                NSArray *timeArray1=[country componentsSeparatedByString:city];
                country=[timeArray1 objectAtIndex:1];

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
            [self readXML:self.DWcity];
            
            NSDictionary *addressdic=[NSDictionary dictionaryWithObjectsAndKeys:self.lat,@"lat",self.lon,@"lon",country,@"address",streetinfo,@"street", province,@"province",township,@"township",city,@"city",district,@"district",self.DWid,@"ID",nil];
            
            


        
        if (self.success) {
            self.success(addressdic);
        }
        
    }
    
    }
    
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    self.failure(@"1");
}
//定位城市id
-(NSString *)readXML:(NSString *)city{
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
    NSMutableArray *list=[userDf objectForKey:@"arealist"];
    if (list.count>0) {
        [list enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
            
            NSString *name = [obj objectForKey:@"name"];
            NSString *areaid = [obj objectForKey:@"areaid"];
            if (self.qxcity.length>0) {
                if ([name rangeOfString:self.qxcity options:NSLiteralSearch].location != NSNotFound||[self.qxcity rangeOfString:name options:NSLiteralSearch].location != NSNotFound)
                {
                    self.pname1=name;
                    self.DWid=areaid;
                    *stop=YES;
                   
            }
            }
        }];
    }
    return self.DWid;
    
}
@end
