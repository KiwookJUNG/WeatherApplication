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
