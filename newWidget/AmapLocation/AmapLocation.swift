//
//  AmapLocation.swift
//  newWidgetExtension
//
//  Created by Admin on 2021/2/26.
//

//import UIKit
import Foundation



class AmapLocation: NSObject , AMapLocationManagerDelegate{
    var locationManager: AMapLocationManager?
    var successCallBack:((String)->(Void))?
    var failResponseStatusCodeCallBack:((Int)->(Void))?
    
    override init() {
        super.init()
        //初始化AMapLocationManager对象，设置代理。
        locationManager = AMapLocationManager()
        locationManager?.delegate = self
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为2s
//        locationManager?.locationTimeout = 2
//        //   逆地理请求超时时间，最低2s，此处设置为2s
//        locationManager?.reGeocodeTimeout = 2
        
        //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        AMapServices.shared().enableHTTPS = true
    }
    func userLocationInfo(locationSuccessInfo: @escaping LocationSuccessInfo,
                         locationFail: @escaping LocationFail) {
        
//        self.successCallBack=LocationSuccessInfo
//        self.failResponseStatusCodeCallBack = locationFail
        // 带逆地理（返回坐标和地址信息）。将下面代码中的 true 改成 false ，则不会返回地址信息。
        locationManager?.requestLocation(withReGeocode: true, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    self.failResponseStatusCodeCallBack!(error.code)
                
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    self.failResponseStatusCodeCallBack!(error.code)
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            var addressInfo: String = ""
            
            
            if let location = location {
                NSLog("location:%@", location)
                
                addressInfo.append("经纬度：\(location.coordinate) \n")
            }
            
            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
                
                addressInfo.append("国家：\(String(describing: reGeocode.country))\n")
                addressInfo.append("省份：\(String(describing: reGeocode.province))\n")
                addressInfo.append("城市：\(String(describing: reGeocode.city))\n")
                addressInfo.append("区：\(String.init(format: "%@", reGeocode.district))\n")
                addressInfo.append("街道：\(String.init(format: "%@", reGeocode.street))\n")
                addressInfo.append(contentsOf: "详细地址：\(String(describing: reGeocode.formattedAddress))\n")
                
                self.successCallBack!(addressInfo)
                
            }
            
        })
       
    }
    func startLocation(){
        // 带逆地理（返回坐标和地址信息）。将下面代码中的 true 改成 false ，则不会返回地址信息。
        locationManager?.requestLocation(withReGeocode: true, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    self.failResponseStatusCodeCallBack!(error.code)
                
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    self.failResponseStatusCodeCallBack!(error.code)
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            
            var addressInfo: String = ""
            
            
            if let location = location {
                NSLog("location:%@", location)
                
                addressInfo.append("经纬度：\(location.coordinate) \n")
            }
            
            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
                
                addressInfo.append("国家：\(String(describing: reGeocode.country))\n")
                addressInfo.append("省份：\(String(describing: reGeocode.province))\n")
                addressInfo.append("城市：\(String(describing: reGeocode.city))\n")
                addressInfo.append("区：\(String.init(format: "%@", reGeocode.district))\n")
                addressInfo.append("街道：\(String.init(format: "%@", reGeocode.street))\n")
                addressInfo.append(contentsOf: "详细地址：\(String(describing: reGeocode.formattedAddress))\n")
                
                self.successCallBack!(addressInfo)
                
            }
            
        })
    }
}
