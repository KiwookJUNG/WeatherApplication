//
//  CityListWeatherVC.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit

class CityListWeatherVC : UIViewController {
    
    var dataForCell : [WeatherData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.dataForCell = appDelegate.weatherDataList
    }
    
// 세 번째 페이지에서 새로운 도시를 추가하면 저장소(UserDelfalut) 및 AppDelegate(싱글톤 저장소)에 저장되고
// 이 후, 화면이 세 번째 뷰컨에서 두 번째 뷰컨으로 돌아오는 순간 talbeView를 reloadData()를 해줘야함
// 왜냐하면 viewDidLoad 에서 읽어온 dataForCell은 세 번쨰 화면에서 업데이트 된 도시 데이터를 가지고 있지않으므로
// 테이블 뷰에도 표시가 안돼있다. 하지만 세 번째 뷰 컨트롤러에서 AppDelegate에 저장하고 dataForCell 에도 데이터를 다시 바꿔주면
// reloadData()를 해줘야 테이블 뷰에 반영되기 때문이다.
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
//        self.tableview.reloadData()
//
//    }
    
}

//MARK: - 테이블뷰의 DataSource 델리게이트
extension CityListWeatherVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.backgroundColor = .black
        return cell
    }
}
