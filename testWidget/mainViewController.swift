//
//  mainViewController.swift
//  testWidget
//
//  Created by Admin on 2021/2/20.
//

import UIKit
import SwiftUI
class mainViewController: UIViewController {
    let demo = firstSwiftUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.blue;
//        let addWaterVC = WzLocationInfos.defaultManager()
//        
//        addWaterVC?.startLocation { (AnyObject) -> () in
//            print(AnyObject)
//        } withFailure: { (AnyObject) -> () in
//
//        }

        if #available(iOS 13, *) {


                    let testSwiftUIView = UIHostingController(rootView: firstSwiftUIView())

                    navigationController?.pushViewController(testSwiftUIView, animated: true)

                }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
