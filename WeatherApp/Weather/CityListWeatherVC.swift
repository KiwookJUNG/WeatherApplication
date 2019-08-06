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
    

    @IBAction func addCity(_ sender: UIButton) {
        let scVC = self.storyboard!.instantiateViewController(withIdentifier: "SearchCityVC")
        
        scVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.present(scVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cityPointArray = appDelegate.savedPointRepo
        
        guard let currentPoint = appDelegate.currentPoint else { return }
        cityPointArray.insert(currentPoint, at: 0)
        
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityPointArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        
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
                
                cell.textLabel?.text = searchedString
            }
        }
        
        
        return cell
    }
}

//MARK: - 테이블뷰의 Delegate
// 셀 선택시 일단 뒤로 간다.
extension CityListWeatherVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
