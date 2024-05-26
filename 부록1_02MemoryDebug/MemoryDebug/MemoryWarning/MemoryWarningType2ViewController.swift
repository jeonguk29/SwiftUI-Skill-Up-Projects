//
//  MemoryWarningType2ViewController.swift
//  MemoryDebug
//
//  Created by Lecture on 2023/12/04.
//

import UIKit

class MemoryWarningType2ViewController: UIViewController, ChildViewDataSource {
    
    private let dummy: Data = DummyGenerator.make()
    
//    deinit {
//        print("MemoryWarningType2ViewController deinit")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let childView = ChildView()
        childView.frame.size = .init(width: 200, height: 200)
        childView.backgroundColor = .blue
        childView.dataSource = self // 💁 이렇게 하면 childView는 self를 알고 있고 self는 View를 알고 있음
                                    // view는 또 childView를 알고 있어서 순환 참조임
        childView.center = self.view.center
        self.view.addSubview(childView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private class ChildView: UIView {
        
        var dataSource: ChildViewDataSource?
//        weak var dataSource: ChildViewDataSource?
    }
}

protocol ChildViewDataSource: AnyObject {
    
}
