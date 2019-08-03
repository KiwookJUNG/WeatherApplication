//
//  PageWeatherVC.swfit.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit
import MapKit

protocol GetWeatherInformation {
    func coordinateToWeather(longi : Double, lati : Double)
}

class PageWeatherVC: UIViewController {
    
    @IBOutlet var pageCollectionView: UICollectionView!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pageCollectionView.backgroundColor = .green
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    
//    // 뷰가 나타나기 직전 Location을 업데이트해준다.
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
//        locationManager.startUpdatingLocation()
//    }
//    // 뷰가 나타나고 난후 Location 업데이트를 중단한다.
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        locationManager.stopUpdatingLocation()
//    }
    
}

//MARK: - 좌표를 이용해 날씨 API를 통해 얻어온 정보로 변환하여 저장하는 프로토콜 구현
extension PageWeatherVC: GetWeatherInformation {
    func coordinateToWeather(longi: Double, lati: Double) {
        // 이 좌표는 UserDefault에 저장될 필요가 없는 좌표이다.
        // 왜냐하면 매번 갱신되기 떄문
        
        let frontURL = "http://api.openweathermap.org/data/2.5/"
        let APPID = "&APPID=7557a2e7185bcdda5baa43838b942438"
        
        let todayURL = frontURL + "weather?lat=\(Int(lati))&lon=\(longi)" + APPID
        let forecastURL = frontURL + "forecast?lat=\(Int(lati))&lon=\(longi)" + APPID
        
        let todayAPI: URL! = URL(string: todayURL)
        let todayAPIData = try! Data(contentsOf: todayAPI)
        
        let forecastAPI: URL! = URL(string: forecastURL)
        let forecastAPIData = try! Data(contentsOf: forecastAPI)
        
        let weatherInfo = WeatherData(todayData : todayAPIData, forecastData : forecastAPIData)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.weatherDataList.insert(weatherInfo, at: 0) // 0번째 자리에 추가.
        // 왜냐하면 Collection View Cell의 첫번째 자리에 위치해야 하기 때문이다.
    }
}



//MARK: - 콜렉션 뷰의 Extension 각 셀에 위치할 함수를 정해준다. 콜렉션 뷰는 총 2개이다.
extension PageWeatherVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pageCollectionView {
            return 6
        } else {
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
            cell.backgroundColor = .red
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath)
            cell.backgroundColor = .yellow
            
            return cell
        }
        
    }
}



//MARK: - 셀 사이즈와 셀과 셀사이의 사이즈를 정해주는 델리게이트 메소드
extension PageWeatherVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == pageCollectionView{
            return CGSize(width: view.frame.width, height: view.frame.height)
        } else {
            return CGSize(width: 46, height: 71)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == pageCollectionView {
            return 0
        } else {
            return 10
        }
    }
}


//MARK: - 테이블 뷰 컨트롤러
extension PageWeatherVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        
        cell.backgroundColor = .blue
        return cell
    }
}




//MARK: - Mapkit에 대한 Extension
extension PageWeatherVC : CLLocationManagerDelegate {
    
    // 좌표가 업데이트되면 호출되는 델리게이트 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        // 좌표가 업데이트 되면
        coordinateToWeather(longi: lastLocation.coordinate.longitude, lati: lastLocation.coordinate.latitude)
        
        print(String(format: "%.6f", lastLocation.coordinate.latitude))
        print(String(format: "%.6f", lastLocation.coordinate.longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
