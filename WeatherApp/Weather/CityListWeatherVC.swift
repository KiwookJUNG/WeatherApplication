//
//  CityListWeatherVC.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit
import MapKit

class CityListWeatherVC : UIViewController {
    
    
    @IBOutlet var cityTable: UITableView!
    var cityWeatherArray : [WeatherData] = []
    var cityPointArray : [SavedPoint] = []
    
    // 화면 전환 액션 메소드
    @IBAction func addCity(_ sender: UIButton) {
        let scVC = self.storyboard!.instantiateViewController(withIdentifier: "SearchCityVC")
        scVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(scVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityTable.separatorStyle = .none
    }
    
    // SearchCityVC에서 추가된 도시를 AppDelegate에서 불러와 테이블 뷰를 리로드해준다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 뷰가 다시 나타날때 마다 AppDelegate에 있는 좌표 리스트를 대입해준다. 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cityPointArray = appDelegate.savedPointRepo
        
        // 현재 위치
        guard let currentPoint = appDelegate.currentPoint else { return }
        cityPointArray.insert(currentPoint, at: 0)
        
        // 날씨 데이터
        for cityPoint in cityPointArray {
            let weatherData = coordinateToWeather(longi: cityPoint.longitude, lati: cityPoint.latitude)
            cityWeatherArray.append(weatherData)
            DispatchQueue.main.async {
                self.cityTable.reloadData()
            }
        }
    }
    
}


//MARK: - 테이블뷰의 DataSource 델리게이트
extension CityListWeatherVC : UITableViewDataSource {
    // 테이블 뷰의 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityPointArray.count
    }
    
    // 테이블 뷰 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // 테이블 뷰 셀의 UIUpdate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        cell.backgroundColor = UIColor(red:0.48, green:0.77, blue:0.98, alpha:1.0)
        
        let weatherData = coordinateToWeather(longi: cityPointArray[indexPath.row].longitude, lati: cityPointArray[indexPath.row].latitude)
        
        guard let temperature = weatherData.temperature else { return cell }
        guard let time = weatherData.time else { return cell }
        guard let timezone = weatherData.timezone else { return cell }
        
        cell.temperature.text = String(Int(temperature .celsius)) + "°"
        cell.time.text = (time + timezone) .AMPMHourMinute
        
        
        DispatchQueue.main.async {
            let location = CLLocation(latitude: self.cityPointArray[indexPath.row].latitude, longitude: self.cityPointArray[indexPath.row].longitude)
            
            let locale = Locale(identifier: "Ko-kr")
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) {(placemarks, error) in
                guard let place = placemarks?[0] else {
                    return
                }
                var searchedString : String = ""
                
                if place.administrativeArea != nil { searchedString = searchedString + " " + place.administrativeArea!}
                if place.locality != nil { searchedString = searchedString + " " + place.locality! }
                
                cell.city.text = searchedString
            }
        }
        
        
        return cell
    }
}

//MARK: - 테이블뷰의 Delegate
// 셀 선택시 이전 뷰 컨트롤러로 간다.
extension CityListWeatherVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isBackedSearchCityVC = true
        self.presentingViewController?.dismiss(animated: true)
    }
}


// 삭제 기능 버그로 인한 미구현
//extension CityListWeatherVC {
//        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//            let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { action, index in
//                if index.row != 0 {
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.savedPointRepo.remove(at: index.row-1)
//                appDelegate.pageViewControllerCounter -= 1
//
//                let plist = UserDefaults.standard
//                plist.setStructArray(appDelegate.savedPointRepo, forKey: "savedPoint")
//                plist.synchronize()
//
//                self.cityPointArray.remove(at: index.row)
//                tableView.reloadData()
//                }
//
//            }
//            return [deleteAction]
//        }
//}
