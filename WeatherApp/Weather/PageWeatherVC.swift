//
//  PageWeatherVC.swfit.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit
import MapKit


class PageWeatherVC: UIViewController {
    
    @IBOutlet var city: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var temperature: UILabel!
    
    @IBOutlet var day: UILabel!
    @IBOutlet var isToday: UILabel!
    
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var minTemperature: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    var index : Int = 0
    var weatherData : WeatherData!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if index == 0 {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
            locationManager.delegate = self
            
            //locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            // 사용자의 위치가 500미터 이상 움직이면 locationManager(_:didUpdateLocations:) 메소드를 호출
        }
        
        self.tableView.register(UITableViewCell.self,
                                  forCellReuseIdentifier: "cellForCollectionCell")
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hourCell")
        

    }

}


extension PageWeatherVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath)
            cell.backgroundColor = .yellow
            return cell
    }
}



extension PageWeatherVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.separatorStyle = .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForCollectionCell", for: indexPath)
        
        
        return cell
    }

}


//MARK: - Mapkit에 대한 Extension
extension PageWeatherVC : CLLocationManagerDelegate {
    
    // 좌표가 업데이트되면 호출되는 델리게이트 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        let doubleLati = lastLocation.coordinate.latitude as Double
        let doubleLongi = lastLocation.coordinate.longitude as Double
        
        DispatchQueue.main.async {
            
            let location = CLLocation(latitude: doubleLati, longitude: doubleLongi)
            let locale = Locale(identifier: "Ko-kr")
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) {(placemarks, error) in
                guard let place = placemarks?[0] else {
                    return
                }
                var searchedString : String = ""
                
                
                if place.administrativeArea != nil {
                    searchedString = searchedString + " " + place.administrativeArea!
                }
                if place.locality != nil {
                    searchedString = searchedString + " " + place.locality!
                }
                
                
                self.city.text = searchedString
                
                
            }
        }
        
        // 좌표가 업데이트 되면
        coordinateToWeather(longi: doubleLongi, lati: doubleLati)
        
        print(String(format: "%.6f", lastLocation.coordinate.latitude))
        print(String(format: "%.6f", lastLocation.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "에러", message: "사용자의 위치를 찾지못하였습니다.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestWhenInUseAuthorization()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            let alert = UIAlertController(title: "위치정보", message: "위치정보를 허용하지 않았으므로 현재 위치의 날씨는 나오지 않습니다. 설정에서 허용해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case .denied:
            let alert = UIAlertController(title: "위치정보", message: "위치정보를 허용하지 않았으므로 현재 위치의 날씨는 나오지 않습니다. 설정에서 허용해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        @unknown default:
            let alert = UIAlertController(title: "위치정보", message: "알 수 없는 에러가 발생했습니다. 관리자에게 문의해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
}
