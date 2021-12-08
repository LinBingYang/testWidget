//
//  WidgetManager.swift
//  testWidget
//
//  Created by Admin on 2021/2/24.
//

import UIKit
import WidgetKit
class WidgetManager: NSObject {
    @objc
    static let shareManager=WidgetManager()
    @objc
    func reloadAlltimelines()  {
        WidgetCenter.shared.reloadAllTimelines()
    }
    @objc
    func reloadTimelines(kind:String)  {
        WidgetCenter.shared.reloadTimelines(ofKind: kind)
    }
}
