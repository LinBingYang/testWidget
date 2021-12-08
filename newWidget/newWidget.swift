//
//  newWidget.swift
//  newWidget
//
//  Created by Admin on 2020/10/16.
//

import WidgetKit
import SwiftUI
import Intents
import CoreLocation

var sstq=[String:AnyObject]()
var weekdic=[String:AnyObject]()
var newsList: [weekModel] = []

struct sstqModel {
    let ct: String //实况温度
    let hightct: String //高温
    let lowct: String //低温
    var image: UIImage? = UIImage(named: "news_logo_placeholder")
}
struct weekModel {
    var gdt = ""
    var higt = ""
    var lowt = ""
    var wd_day_ico = ""
    var wd_night_ico = ""
    var week = ""
    var wd_day = ""
}
struct Provider: IntentTimelineProvider {
    @AppStorage("currentCity", store: UserDefaults(suiteName: "group.pcs.testWidget"))
    var currentCity: String = String()
    var currentCityID=UserDefaults(suiteName: "group.pcs.testWidget")?.object(forKey: "currentCityID")
    

//    @ObservedObject var locationObserver = LocationObserver()
    let baselocation = BaseLocationViewModel()

    let addWaterVC = LocationTool.defaultManager()
    
            

    func placeholder(in context: Context) -> SimpleEntry {
        let model = sstqModel(ct: NSLocalizedString("sq_send_world_title", comment: ""), hightct: NSLocalizedString("sq_default_des", comment: ""), lowct: NSLocalizedString("sq_default_des", comment: ""),image: UIImage(named: "icon80"))
        let previewList : [weekModel] = [weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25")]
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(),sstqInfo: model,newsList: previewList,City: currentCity)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        addWaterVC.startLocation()
       
        let area = ["area":"72329" ]
        //一周
        let areaid=["area":"1069"]
        let pdic=["p_new_week":areaid,"sstq":area]
        let  b=["b":pdic]
        let param=dicValueString(b)
        let networkTool = NetworkTool()
        
        networkTool.request(requestUrl: "http://110.83.28.199:8096/ztq30_fj_jc/service.do", method: "POST", param: ["p" : param as AnyObject])
        networkTool.failResponseStatusCodeCallBack = { (result) -> Void in
            print(result)
        }
        networkTool.successCallBack = { (resultDic) -> Void in
            print(resultDic)
            
            let datajson=JSON(resultDic)["b"]["sstq"]["sstq"]["ct"].rawValue
            let hight=JSON(resultDic)["b"]["sstq"]["sstq"]["higt"].rawValue
            let low=JSON(resultDic)["b"]["sstq"]["sstq"]["lowt"].rawValue
            let url: URL = URL(string: "http://110.83.28.199:8099/ftp//ico/szyb_ico/ECxwg.png")!
            let weeklist=JSON(resultDic)["b"]["p_new_week"]["week"].arrayValue
            var dataArray = [weekModel]()
            for dataDic in  weeklist{
                var model =  weekModel()
                model.gdt = dataDic["gdt"].string ?? ""
                model.higt =  dataDic["higt"].string ?? ""
                model.lowt =  dataDic["lowt"].string ?? ""
                model.wd_day_ico =  dataDic["wd_day_ico"].string ?? ""
                model.wd_night_ico =  dataDic["wd_night_ico"].string ?? ""
                model.week =  dataDic["week"].string ?? ""
                model.wd_day =  dataDic["wd_day"].string ?? ""
                dataArray.append(model)
            }
            ImageHelper.downloadImage(url: url) { (result) in//图片下载
                if case .success(let response) = result {
//                    model.image = response
                    let  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: response)
                    let entry = SimpleEntry(date: Date(), configuration: configuration,sstqInfo: model,newsList: dataArray,City: currentCity)
                    completion(entry)
                }
            }
        }
//        let model = sstqModel(ct: NSLocalizedString("sq_send_world_title", comment: ""), hightct: NSLocalizedString("sq_default_des", comment: ""), lowct: NSLocalizedString("sq_default_des", comment: ""),image: UIImage(named: "icon80"))
//        let previewList : [weekModel] = [weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25")]
//        let entry = SimpleEntry(date: Date(), configuration: configuration,sstqInfo: model,newsList: previewList,City: currentCity)
//        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
//        WidgetCenter.shared.reloadTimelines(ofKind: "group.abc.WidgetDemo")
//        var info =; @AppStorag0e(store: UserDefaults(suiteName: "group.pcs.testWidget"))
//        let returnValue:Any? = UserDefaults.standard.dictionary(forKey: "group.pcs.testWidget")
//        let city=returnValue["currentCity"]
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let updateDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)
        
        addWaterVC.startLocation { (AnyObject) in
            print(AnyObject)
            let city=JSON(AnyObject)["city"].rawValue as! String
            let distist=JSON(AnyObject)["district"].rawValue as! String
            let thoroughfare=JSON(AnyObject)["township"].rawValue as! String
            let currentCityId=JSON(AnyObject)["ID"].rawValue as! String
            if !thoroughfare.isEmpty{
                currentCity=distist+"."+thoroughfare
            }else if !distist.isEmpty  {
                    currentCity=city+"."+distist
                }else{
                    currentCity=city
                }

            print(currentCity)
                    let area = ["area":currentCityId]
                    //一周
                    let areaid=["area":"1069"]
                    let pdic=["p_new_week":areaid,"sstq":area]
                    let  b=["b":pdic]

                    let param=dicValueString(b)

                    let networkTool = NetworkTool()
                    networkTool.request(requestUrl: "http://110.83.28.199:8096/ztq30_fj_jc/service.do", method: "POST", param: ["p" : param as AnyObject])
                    networkTool.failResponseStatusCodeCallBack = { (result) -> Void in
                        print(result)

                    }
                    networkTool.successCallBack = { (resultDic) -> Void in
                        print(resultDic)

                        let datajson=JSON(resultDic)["b"]["sstq"]["sstq"]["ct"].rawValue
                        let hight=JSON(resultDic)["b"]["sstq"]["sstq"]["higt"].rawValue
                        let low=JSON(resultDic)["b"]["sstq"]["sstq"]["lowt"].rawValue
                        let url: URL = URL(string: "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4056942570,1295154116&fm=26&gp=0.jpg")!


                        print("当前温度",datajson)
                        let weeklist=JSON(resultDic)["b"]["p_new_week"]["week"].arrayValue
                        var dataArray = [weekModel]()
                        for dataDic in  weeklist{
                            var model =  weekModel()
                            model.gdt = dataDic["gdt"].string ?? ""
                            model.higt =  dataDic["higt"].string ?? ""
                            model.lowt =  dataDic["lowt"].string ?? ""
                            model.wd_day_ico =  dataDic["wd_day_ico"].string ?? ""
                            model.wd_night_ico =  dataDic["wd_night_ico"].string ?? ""
                            model.week =  dataDic["week"].string ?? ""
                            model.wd_day =  dataDic["wd_day"].string ?? ""
                            dataArray.append(model)

                        }
                        ImageHelper.downloadImage(url: url) { (result) in//图片下载
                            if case .success(let response) = result {
            //                    model.image = response
                                let  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: response)
                                let entry = SimpleEntry(date: updateDate!, configuration: configuration,sstqInfo: model,newsList: dataArray,City: currentCity)
                                let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
                                completion(timeline)
                            }
                        }
                    }

        } withFailure: { (AnyObject) in
            let area = ["area":currentCityID]
            //一周
            let areaid=["area":"1069"]
            let pdic=["p_new_week":areaid,"sstq":area]
            let  b=["b":pdic]

            let param=dicValueString(b)

            let networkTool = NetworkTool()
            networkTool.request(requestUrl: "http://110.83.28.199:8096/ztq30_fj_jc/service.do", method: "POST", param: ["p" : param as AnyObject])
            networkTool.failResponseStatusCodeCallBack = { (result) -> Void in
                print(result)

            }
            networkTool.successCallBack = { (resultDic) -> Void in
                print(resultDic)

                let datajson=JSON(resultDic)["b"]["sstq"]["sstq"]["ct"].rawValue
                let hight=JSON(resultDic)["b"]["sstq"]["sstq"]["higt"].rawValue
                let low=JSON(resultDic)["b"]["sstq"]["sstq"]["lowt"].rawValue
                let url: URL = URL(string: "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4056942570,1295154116&fm=26&gp=0.jpg")!


                print("当前温度",datajson)
                let weeklist=JSON(resultDic)["b"]["p_new_week"]["week"].arrayValue
                var dataArray = [weekModel]()
                for dataDic in  weeklist{
                    var model =  weekModel()
                    model.gdt = dataDic["gdt"].string ?? ""
                    model.higt =  dataDic["higt"].string ?? ""
                    model.lowt =  dataDic["lowt"].string ?? ""
                    model.wd_day_ico =  dataDic["wd_day_ico"].string ?? ""
                    model.wd_night_ico =  dataDic["wd_night_ico"].string ?? ""
                    model.week =  dataDic["week"].string ?? ""
                    model.wd_day =  dataDic["wd_day"].string ?? ""
                    dataArray.append(model)

                }
                ImageHelper.downloadImage(url: url) { (result) in//图片下载
                    if case .success(let response) = result {
    //                    model.image = response
                        let  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: response)
                        let entry = SimpleEntry(date: updateDate!, configuration: configuration,sstqInfo: model,newsList: dataArray,City: currentCity)
                        let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
                        completion(timeline)
                    }
                }
            }
        }

        
        

//        baselocation.userLocationInfo { (AnyObject) in
//            print(AnyObject)
//            let city=JSON(AnyObject)["city"].rawValue as! String
//            let distist=JSON(AnyObject)["distist"].rawValue as! String
//            let thoroughfare=JSON(AnyObject)["thoroughfare"].rawValue as! String
//            if !thoroughfare.isEmpty{
//                currentCity=distist+thoroughfare
//            }else if !distist.isEmpty  {
//                    currentCity=city+distist
//                }else{
//                    currentCity=city
//                }
//
//            print(currentCity)
//
//            //        let area=["area":"71921"]
//                    let area = ["area":"72329" as! String]
//
//            //        let sstq=["sstq":area]
//            //        var b=["b":sstq]
//
//                    //一周
//                    let areaid=["area":"1069"]
//                    let pdic=["p_new_week":areaid,"sstq":area]
//                    let  b=["b":pdic]
//
//                    let param=dicValueString(b)
//
//                    let networkTool = NetworkTool()
//                    networkTool.request(requestUrl: "http://110.83.28.199:8096/ztq30_fj_jc/service.do", method: "POST", param: ["p" : param as AnyObject])
//                    networkTool.failResponseStatusCodeCallBack = { (result) -> Void in
//                        print(result)
//
//                    }
//                    networkTool.successCallBack = { (resultDic) -> Void in
//                        print(resultDic)
//
//                        let datajson=JSON(resultDic)["b"]["sstq"]["sstq"]["ct"].rawValue
//                        let hight=JSON(resultDic)["b"]["sstq"]["sstq"]["higt"].rawValue
//                        let low=JSON(resultDic)["b"]["sstq"]["sstq"]["lowt"].rawValue
//            //            let datajson=JSON(resultDic)["b"]["sstq"]["sstq"].rawValue
//            //            var  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: UIImage(named: "news_logo_placeholder"))
//
//
//                        let url: URL = URL(string: "http://110.83.28.199:8099/ftp//ico/szyb_ico/ECxwg.png")!
//
//
//                        print("当前温度",datajson)
//                        let weeklist=JSON(resultDic)["b"]["p_new_week"]["week"].arrayValue
//                        var dataArray = [weekModel]()
//                        for dataDic in  weeklist{
//                            var model =  weekModel()
//                            model.gdt = dataDic["gdt"].string ?? ""
//                            model.higt =  dataDic["higt"].string ?? ""
//                            model.lowt =  dataDic["lowt"].string ?? ""
//                            model.wd_day_ico =  dataDic["wd_day_ico"].string ?? ""
//                            model.wd_night_ico =  dataDic["wd_night_ico"].string ?? ""
//                            model.week =  dataDic["week"].string ?? ""
//                            model.wd_day =  dataDic["wd_day"].string ?? ""
//                            dataArray.append(model)
//
//                        }
//            //            newsList=dataArray
//            //            let previewList : [weekModel] = [weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25")]
//                        ImageHelper.downloadImage(url: url) { (result) in//图片下载
//                            if case .success(let response) = result {
//            //                    model.image = response
//                                let  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: response)
//                                let entry = SimpleEntry(date: updateDate!, configuration: configuration,sstqInfo: model,newsList: dataArray,City: currentCity)
//                                let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
//                                completion(timeline)
//                            }
//                        }
//                    }
//
//        } locationFail: { (errorMsg) in
//
//        }
        
//                let area = ["area":"72329" as! String]
//                //一周
//                let areaid=["area":"1069"]
//                let pdic=["p_new_week":areaid,"sstq":area]
//                let  b=["b":pdic]
//
//                let param=dicValueString(b)
//
//                let networkTool = NetworkTool()
//                networkTool.request(requestUrl: "http://110.83.28.199:8096/ztq30_fj_jc/service.do", method: "POST", param: ["p" : param as AnyObject])
//                networkTool.failResponseStatusCodeCallBack = { (result) -> Void in
//                    print(result)
//
//                }
//                networkTool.successCallBack = { (resultDic) -> Void in
//                    print(resultDic)
//
//                    let datajson=JSON(resultDic)["b"]["sstq"]["sstq"]["ct"].rawValue
//                    let hight=JSON(resultDic)["b"]["sstq"]["sstq"]["higt"].rawValue
//                    let low=JSON(resultDic)["b"]["sstq"]["sstq"]["lowt"].rawValue
//        //            let datajson=JSON(resultDic)["b"]["sstq"]["sstq"].rawValue
//        //            var  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: UIImage(named: "news_logo_placeholder"))
//
//
//                    let url: URL = URL(string: "http://110.83.28.199:8099/ftp//ico/szyb_ico/ECxwg.png")!
//
//
//                    print("当前温度",datajson)
//                    let weeklist=JSON(resultDic)["b"]["p_new_week"]["week"].arrayValue
//                    var dataArray = [weekModel]()
//                    for dataDic in  weeklist{
//                        var model =  weekModel()
//                        model.gdt = dataDic["gdt"].string ?? ""
//                        model.higt =  dataDic["higt"].string ?? ""
//                        model.lowt =  dataDic["lowt"].string ?? ""
//                        model.wd_day_ico =  dataDic["wd_day_ico"].string ?? ""
//                        model.wd_night_ico =  dataDic["wd_night_ico"].string ?? ""
//                        model.week =  dataDic["week"].string ?? ""
//                        model.wd_day =  dataDic["wd_day"].string ?? ""
//                        dataArray.append(model)
//
//                    }
//        //            newsList=dataArray
//        //            let previewList : [weekModel] = [weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25")]
//                    ImageHelper.downloadImage(url: url) { (result) in//图片下载
//                        if case .success(let response) = result {
//        //                    model.image = response
//                            let  model=sstqModel(ct: datajson as! String, hightct: hight as! String,lowct: low as! String,image: response)
//                            let entry = SimpleEntry(date: updateDate!, configuration: configuration,sstqInfo: model,newsList: dataArray,City: currentCity)
//                            let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
//                            completion(timeline)
//                        }
//                    }
//        //            let entry = SimpleEntry(date: updateDate!, configuration: configuration,sstqInfo: model,newsList: dataArray)
//        //            let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
//        //            completion(timeline)
//                }
        
        


    }
}
func dicValueString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let sstqInfo: sstqModel
    let newsList: [weekModel]
    let City: String
}
//小尺寸下的Widget布局
struct NewsViewSmall : View {
    var entry: Provider.Entry
    var body : some View {
        let ct=entry.sstqInfo.ct
        let weeklist=entry.newsList
        let ssmodel = weeklist[1]
//        let city:String?=returnValue["currentCity"]
        VStack(alignment: .leading, spacing: 0) {//垂直
            Text(entry.City)
                .font(.system(size: 12))
                .foregroundColor(.white)
            
                    HStack(){
                        Image(ssmodel.wd_day_ico)
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .leading)
                        Text(ct+"°")
                            .font(.title2)
                            .bold()
                            .frame(width: 100, height: 60, alignment: .leading)
                            .foregroundColor(.white)

                    }
                    Text(ssmodel.wd_day)
                    .font(.system(size: 13))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .foregroundColor(.white)

            
            Text(ssmodel.higt+"/"+ssmodel.lowt+"℃")
            .font(.system(size: 13))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                //widget背景图片
                .background(
                    Image(uiImage: entry.sstqInfo.image!)
                        .resizable()
                        .scaledToFill()
                )
                .widgetURL(URL(string: "url://123"))//获取点击标记 需要在SceneDelegate里面实现跳转处理，因为iOS13后，APP的UI生命周期交由SceneDelegate管理
                /* http://110.83.28.199:8099/ftp//ico/szyb_ico/ECxwg.png
                 func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
                 for context in URLContexts {
                 print(context.url) //获取widget点击标记 url://123
                 }
                 }
                 */
    }
}
//中/大尺寸下的Widget布局
struct NewsViewMedium : View {
    var entry: Provider.Entry
//    @ObservedObject var locationObserver = LocationObserver()
    
//    let locationObserver = LocationObserver()
    static let gradientStart = Color(red: 234 / 255, green: 67 / 255, blue: 29 / 255)
    static let gradientEnd = Color(red: 25 / 255, green: 77 / 255, blue: 143 / 255)

    var body : some View {
//        Text(entry.date, style: .time)
        let ct=entry.sstqInfo.ct
        let weeklist=entry.newsList
        let ssmodel = weeklist[1]
        VStack(alignment: .leading, spacing: 0) {//垂直
            Text(entry.City)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: -10, leading: 10, bottom: 0, trailing: 0))
                    HStack(){
                        Image(ssmodel.wd_day_ico)
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .leading)
                        Text(ct+"°")
                            .font(.title2)
                            .bold()
                            .frame(width: 100, height: 60, alignment: .leading)
                            .foregroundColor(.white)
                        VStack(){
                            Text(ssmodel.wd_day)
                            .font(.system(size: 13))
                                .foregroundColor(.white)
                            Text(ssmodel.higt+"/"+ssmodel.lowt+"℃")
                            .font(.system(size: 13))
                                .foregroundColor(.white)

                        }
                        Path{path in
                                path.addArc(center: .init(x: 25, y: 40), radius: 15, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
                        }.stroke(AngularGradient(gradient: Gradient(colors: [.orange, .red, .purple]), center: UnitPoint(x: 0.5, y: 0.5), startAngle: Angle.init(degrees: 0), endAngle: Angle.init(degrees: 360)),lineWidth:3)

                    }
            
            HStack(){
                
                ForEach(0 ..< 3) {number in
                    if weeklist.count>4{
                        let model = weeklist[number+2]
                        
                        Image(model.wd_day_ico)
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.size.width>=1242 ? 40 : 35), height: (UIScreen.main.bounds.size.width>=1242 ? 40 : 35), alignment: .leading)
                        VStack(){
                            if number==0{
                                Text("明日")
                                .font(.system(size: 12))
                                    .foregroundColor(.white)
                                Text(model.higt+"/"+model.lowt+"℃")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            if number==1{
                                Text(model.gdt)
                                .font(.system(size: 12))
                                    .foregroundColor(.white)
                                Text(model.higt+"/"+model.lowt+"℃")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            if number==2{
                                Text(model.gdt)
                                .font(.system(size: 12))
                                    .foregroundColor(.white)
                                Text(model.higt+"/"+model.lowt+"℃")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }

                        }
                    }
                    
                }
            }.padding(.leading, 0)//距离左边间距20
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
//        .background(
//            Color(.blue)
//                .opacity(0.3)
//        )
        .background(
            Image(uiImage: entry.sstqInfo.image!)
                .resizable()
                .scaledToFill()
        )
                //widget背景图片
//                .background(
//                    Image("icon80")
//                        .resizable()
//                        .scaledToFill()
//                )
                .widgetURL(URL(string: "url://321"))//获取点击标记 需要在SceneDelegate里面实现跳转处理，因为iOS13后，APP的UI生命周期交由SceneDelegate管理
                /*
                 func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
                 for context in URLContexts {
                 print(context.url) //获取widget点击标记 url://123
                 }
                 }
                 */
    }
}
//大尺寸下的Widget布局
struct NewsViewlargy : View {
    var entry: Provider.Entry
    var body : some View {
//        Text(entry.date, style: .time)
        let ct=entry.sstqInfo.ct
        let weeklist=entry.newsList
        let ssmodel = weeklist[1]
        ZStack {//Z轴上把它们整合
        BadgeBackground()
            

        VStack(alignment: .leading, spacing: 0) {//垂直
            Text(entry.City)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: -10, leading: 20, bottom: 0, trailing: 0))
                    HStack(){
                        Image(ssmodel.wd_day_ico)
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .leading)
                        Text(ct+"°")
                            .font(.title2)
                            .bold()
                            .frame(width: 100, height: 60, alignment: .leading)
                            .foregroundColor(.white)
                        VStack(){
                            Text(ssmodel.wd_day)
                            .font(.system(size: 13))
                                .foregroundColor(.white)
                            Text(ssmodel.higt+"/"+ssmodel.lowt+"℃")
                            .font(.system(size: 13))
                                .foregroundColor(.white)

                        }

                    }.padding(.leading, 20)//距离左边间距20
            
            VStack(spacing: 0){
                ForEach(0 ..< 3) {number in
                    let model = weeklist[number+1]
                    
                    HStack(){
                   
                        if number==0{
                            Text("今天")
                            .font(.system(size: 12))
                                .foregroundColor(.white)
                                .frame(width: 80, height: 25, alignment: .leading)
                                .padding(10)
                        }else{
                            Text(model.gdt)
                            .font(.system(size: 12))
                                .foregroundColor(.white)
                                .frame(width: 80, height: 25, alignment: .leading)
                                .padding(10)
                        }
                        
                        
                        
                        Image(model.wd_day_ico)
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .leading)
                        Text(model.wd_day)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 25, alignment: .leading)
                        Text(model.higt+"/"+model.lowt+"℃")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 25, alignment: .trailing)
                       

                    }
                    Divider()
                        .background(Color(.white))
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                }
            }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding(0)
        .background(
            Color(.blue)
                .opacity(0.5)
        )
        .widgetURL(URL(string: "url://321"))//获取点击标记
        }
    }
}

struct newWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
//        Text(entry.date, style: .time)
        switch family {
        case .systemSmall:
            NewsViewSmall(entry: entry)
        case .systemMedium:
            NewsViewMedium(entry: entry)
        default:
            NewsViewlargy(entry: entry)
        }
    }
}

@main
struct newWidget: Widget {
    let kind: String = "newWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            newWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct newWidget_Previews: PreviewProvider {
    static var previews: some View {
        let model = sstqModel(ct: NSLocalizedString("sq_send_world_title", comment: ""), hightct: NSLocalizedString("sq_default_des", comment: ""), lowct: NSLocalizedString("sq_default_des", comment: ""),image: UIImage(named: "icon80"))
        let previewList : [weekModel] = [weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25"), weekModel(gdt: "", higt: "25", lowt: "25", wd_day_ico: "25", wd_night_ico: "25", week: "25", wd_day: "25")]
        newWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),sstqInfo: model,newsList: previewList,City: "福州市"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}
struct HexagonParameters {
     
    struct Segment {
         
        let useWidth:  (CGFloat, CGFloat, CGFloat)
        let xFactors:  (CGFloat, CGFloat, CGFloat)
        let useHeight: (CGFloat, CGFloat, CGFloat)
        let yFactors:  (CGFloat, CGFloat, CGFloat)
    }
     
    static let adjustment: CGFloat = 0.085
     
    static let points = [
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.60, 0.40, 0.50),
            useHeight: (1.00, 1.00, 0.00),
            yFactors:  (0.05, 0.05, 0.00)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 0.00),
            xFactors:  (0.05, 0.00, 0.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.20 + adjustment, 0.30 + adjustment, 0.25 + adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 0.00),
            xFactors:  (0.00, 0.05, 0.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.70 - adjustment, 0.80 - adjustment, 0.75 - adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.40, 0.60, 0.50),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.95, 0.95, 1.00)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.95, 1.00, 1.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.80 - adjustment, 0.70 - adjustment, 0.75 - adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (1.00, 0.95, 1.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.30 + adjustment, 0.20 + adjustment, 0.25 + adjustment)
        )
    ]
}
struct BadgeBackground: View {
     
    /// 渐变色的开始和结束的颜色
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd   = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
     
    ///
    var body: some View {
         
        /// geometry [dʒiˈɒmətri] 几何学
        /// 14之后改了它的对齐方式，向上对齐
        GeometryReader { geometry in
             
            Path{path in
                
               /// 保证是个正方形
               var width: CGFloat = min(geometry.size.width, geometry.size.height)
                             
               let height = width
               /// 这个值越大 x的边距越小 值越小 边距越大 缩放系数
               let xScale: CGFloat = 0.85
               /// 定义的是x的边距
               let xOffset = (width * (1.0 - xScale)) / 2.0
               width *= xScale
               /// 这个点事图中 1 的位置
               path.move(to: CGPoint(
                    x: xOffset + width * 0.95 ,
                    y: height * (0.20 + HexagonParameters.adjustment))
               )
                 
               /// 循环这个数组
               HexagonParameters.points.forEach {
                 
                   /// 从path开始的点到to指定的点添加一段直线
                   path.addLine(
                       to:.init(
                           /// useWidth:  (1.00, 1.00, 1.00),
                           /// xFactors:  (0.60, 0.40, 0.50),
                           x: xOffset + width * $0.useWidth.0 * $0.xFactors.0 ,
                           y: height * $0.useHeight.0 * $0.yFactors.0
                       )
                   )
                 
                   /// 从开始的点到指定的点添加一个贝塞尔曲线
                   /// 这里开始的点就是上面添加直线结束的点
                   path.addQuadCurve(
                       to: .init(
                           x: xOffset + width * $0.useWidth.1 * $0.xFactors.1,
                           y: height * $0.useHeight.1 * $0.yFactors.1
                       ),
                       control: .init(
                           x: xOffset + width * $0.useWidth.2 * $0.xFactors.2,
                           y: height * $0.useHeight.2 * $0.yFactors.2
                       )
                   )
              }
            }
            /// 添加一个线性颜色渐变
            .fill(LinearGradient(
                gradient:.init(colors: [Self.gradientStart, Self.gradientEnd]),
                /// 其实从 0.5 ，0 到 0.5  0.6 的渐变就是竖直方向的渐变
                startPoint:.init(x: 0.5, y: 0),
                endPoint:  .init(x: 0.5, y: 0.6)
            /// aspect 方向  Ratio 比率，比例
            ))
            .aspectRatio(contentMode: .fit)
        }
    }
}
