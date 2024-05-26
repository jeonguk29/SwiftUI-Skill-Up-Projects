//
//  ViewController.swift
//  MemoryDebug
//
//  Created by Lecture on 2023/12/04.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Row: Int, CaseIterable {
        case crash
        case memoryType1
        case memoryType2
        case memoryType3
        case cacheTest
        case weak
        case unowned
        case unownedOptional
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ListCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50
        
        TaskSample().doSomething()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = self.cellTitle(indexPath: indexPath)
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else {
            return
        }
        
        switch row {
        case .crash:
            _ = [Int]()[1]
        case .memoryType1:
            // 1-1. A,B 서로 참조하는 경우
            
            let aModule = AModule()
            _ = BModule(aModule: aModule)
            
            // 1-2. A=>B=>C=>A 서로 참조하는 경우
            // 버튼 누를때마다 메모리 증가함
            let circularA = CircularA()
            let circularB = CircularB()
            let circularC = CircularC()
            circularA.b = circularB
            circularB.c = circularC
            circularC.a = circularA
        case .memoryType2:
            let vc = MemoryWarningType2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .memoryType3:
            let vc = MemoryWarningType3ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .cacheTest:
            SampleCache.shared.add(data: DummyGenerator.make())
        case .weak:
            // weak은 없으면 nil로 나옴
            // 요즘은 디바이스 성능을 생각했을때 이 Unowned를 사용하여 오버헤드를 신경 쓰는 것 보단 weak을 사용하여 앱 안정성을 올려 사용자들에게 더 좋은 경험을 주는 것이 좋음
            let main = WeakMain()
            let sub = WeakSub()
            main.sub = sub
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                print(String(describing: main.sub?.value))
            }
        case .unowned:
            let sub = UnownedSub()
            let main = UnownedMain(sub: sub)
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                print(String(describing: main.sub.value)) // 크래시
            }
        case .unownedOptional:
            let main = UnownedOptionalMain()
            let sub = UnownedOptionalSub()
            main.sub = sub
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                print(String(describing: main.sub?.value)) // 크래시
            }
        }
    }
    
    private func cellTitle(indexPath: IndexPath) -> String? {
        guard let row = Row(rawValue: indexPath.row) else {
            return nil
        }
        
        switch row {
        case .crash:
            return "크래시 발생"
        case .memoryType1:
            return "메모리 문제 발생 유형 1"
        case .memoryType2:
            return "메모리 문제 발생 유형 2"
        case .memoryType3:
            return "메모리 문제 발생 유형 3"
        case .cacheTest:
            return "MemoryWarning을 활용한 데이터정리"
        case .weak:
            return "Weak Reference 접근 테스트"
        case .unowned:
            return "Unowned Reference 접근 테스트"
        case .unownedOptional:
            return "Unowned Optional Reference 접근 테스트"
        }
    }
    
    private func printCancel() {
        print("canceled")
    }
    
    // ViewController에서 메모리 체크하는 방법
    /*
     ViewController는 class즉 참조 타입이라서 참조 사이클이 생겨서 해제되지 않는다면 아래 didReceiveMemoryWarning 호출시 예를 들면 똑같은 뷰컨 5개가 로드되지 않았다면 동시에 5개의 로그가 들어올 것임
     스유는 벨류 타입이라 그런 상황이 발생하지는 않겠지만 필요에 따라 유킷에서는 해당 코드 잘 넣어두면 대응할 때 굉장히 유용할 것임
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        print("home vc memory warning")
    }

}

