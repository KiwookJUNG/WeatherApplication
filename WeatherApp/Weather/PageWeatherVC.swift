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
    
    // 화면 전환 액션 메소드
    @IBAction func goToCityList(_ sender: UIButton) {
        let clVC = self.storyboard!.instantiateViewController(withIdentifier: "CityListWeatherVC")
        clVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(clVC, animated: true)
    }
    
    var index : Int = 0
    var weatherData : WeatherData?
    
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        // CLLocationManager 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
        locationManager.delegate = self
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // 첫 번째 페이지 뷰이면 현재 위치 업데이트
        if (self.index == 0) {
            locationManager.requestLocation()
        } else {
        // 첫 번째 페이지가 아니고, 인덱스 범위에 있는 페이지의 UI를 업데이트 해준다.
            if ( self.index-1 >= 0 && self.index-1 < appDelegate.savedPointRepo.count) {
            let point = appDelegate.savedPointRepo[self.index-1]
            self.weatherData = coordinateToWeather(longi: point.longitude, lati: point.latitude)
            
            // UI 업데이트 ( 도시이름, 기온 등 )
            getCityName(longi: point.longitude, lati: point.latitude)
            updateUI(data: self.weatherData)

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        // 뷰가 다시 나타날 때, 좌표 정보가 있으면 좌표정보를 이용해 빠르게 UI를 업데이트 해준다.
        // 왜냐하면, locationManager.requestLocation()에서 좌표정보를 받아오는게 느리기 때문..
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if ( index == 0 && appDelegate.isBackedSearchCityVC == true ) {
            guard let currentPoint = appDelegate.currentPoint else { return }
        
            getCityName(longi: currentPoint.longitude, lati: currentPoint.latitude)
            self.weatherData = coordinateToWeather(longi: currentPoint.longitude, lati: currentPoint.latitude)
            updateUI(data: self.weatherData)
            appDelegate.isBackedSearchCityVC = false
        }
    }
}



//MARK: - 입력받은 좌표로 UI업데이트 하는 메소드
extension PageWeatherVC {
    // 입력받은 좌표로 도시 이름 출력
    func getCityName(longi : Double, lati : Double ) {
        DispatchQueue.main.async {
            let location = CLLocation(latitude: lati, longitude: longi)
            let locale = Locale(identifier: "Ko-kr")
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) {(placemarks, error) in
                guard let place = placemarks?[0] else {
                    return
                }
                var searchedString : String = ""
                
                if place.administrativeArea != nil { searchedString = searchedString + " " + place.administrativeArea!}
                if place.locality != nil { searchedString = searchedString + " " + place.locality! }
                
                self.city.text = searchedString
            }
        }
    }
    
    // 날씨 정보 출력
    func updateUI(data : WeatherData?){
        DispatchQueue.main.async {
            guard let description = data?.description else { return }
            guard let time = data?.time else { return }
            guard let temperature = data?.temperature else { return }
            guard let maxTemperature = data?.maxTemperature else { return }
            guard let minTemperature = data?.minTemperature else { return }
            
            self.weather.text = description
            self.temperature.text = String(Int(temperature .celsius))
            self.maxTemperature.text = String(Int(maxTemperature .celsius))
            self.minTemperature.text = String(Int(minTemperature .celsius))
            self.day.text = time .day
            self.isToday.text = time .today
        }
    }
}


//MARK: - 컬렉션뷰 컨트롤러 데이터소스
extension PageWeatherVC : UICollectionViewDataSource {
    
    // 컬렉쎤뷰 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // 컬렉션뷰 셀 UI 업데이트
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as! HourCell
        
        guard let time = weatherData?.forecastArray[indexPath.row].time else { return cell }
        guard let timezone = weatherData?.timezone else { return cell }
        guard let weather = weatherData?.forecastArray[indexPath.row].weather else { return cell }
        guard let temperature = weatherData?.forecastArray[indexPath.row].temperature else { return cell }
        
        cell.time.text = (time + timezone) .dayAndTime
        cell.weather.text = weather
        cell.temperature.text = String(Int(temperature .celsius))
        
        return cell
    }
}


//MARK: - 테이블뷰 컨트롤러 데이터소스
extension PageWeatherVC : UITableViewDataSource {
    // 테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 5 {
            return 37
        } else {
            return 75
        }
    }
    // 테이블뷰 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    // 테이블뷰 셀 UI 업데이트(날씨 정보)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayCell
            guard let time = weatherData?.forecastArray[indexPath.row * 8].time else { return cell }
            guard let timezone = weatherData?.timezone else { return cell }
            guard let min = weatherData?.forecastArray[indexPath.row * 8].minTemperature else { return cell }
            guard let max = weatherData?.forecastArray[indexPath.row * 8].maxTemperature else { return cell }
            guard let weather = weatherData?.forecastArray[indexPath.row * 8].weather else { return cell }
            cell.day.text = (time+timezone) .day
            cell.weather.text = weather
            cell.minTemperature.text = String(Int(min .celsius))
            cell.maxTemperature.text = String(Int(max .celsius))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
            guard let sunset = weatherData?.sunset else { return cell }
            guard let sunrise = weatherData?.sunrise else { return cell }
            guard let timezone = weatherData?.timezone else { return cell }
            guard let windSpeed = weatherData?.windSpeed else { return cell }
            guard let windDegree = weatherData?.windDegree else { return cell }
            guard let cloud = weatherData?.cloud else { return cell }
            guard let pressure = weatherData?.pressure else { return cell }
            guard let humidity = weatherData?.humidity else { return cell }
            
            
            if(indexPath.row == 5) {
                cell.firstCell.text = "일출 : " + String((sunrise + timezone) .AMPMHourMinute)
                cell.secondCell.text = "일몰 : " + String((sunset + timezone) .AMPMHourMinute)
            }
            if(indexPath.row == 6) {
                cell.firstCell.text = "풍향 : " + String(Int(windDegree))
                cell.secondCell.text = "풍속 : " + String(windSpeed) + "m/s"
            }
            if(indexPath.row == 7) {
                cell.firstCell.text = "구름 : " + String(cloud) + "%"
                cell.secondCell.text = "습도 : " + String(Int(humidity)) + "%"
            }
            if(indexPath.row == 8) {
                cell.firstCell.text = "기압 : " + String(Int(pressure)) + "hPa"
                cell.secondCell.text = "기압 : " + String(Int(pressure)) + "hPa"
            }
           return cell
        }
    }
}


//MARK: - Mapkit에 대한 Extension
extension PageWeatherVC : CLLocationManagerDelegate {
    
    // 좌표가 업데이트되면 호출되는 델리게이트 메소드
    // 좌표가 업데이트되면 현재위치의 날씨 정보를 모두 업데이트해줘야한다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let lastLocation: CLLocation = locations[locations.count - 1]
        let doubleLati = lastLocation.coordinate.latitude as Double
        let doubleLongi = lastLocation.coordinate.longitude as Double
        
        // AppDelegate의 현재 위치를 업데이트한다.
        appDelegate.currentPoint = SavedPoint(longitude: doubleLongi, latitude: doubleLati)
        
        // 도시 이름 업데이트
        getCityName(longi: doubleLongi, lati: doubleLati)
        
        // 좌표가 업데이트 되면 weatherData를 리턴한다.
        self.weatherData = coordinateToWeather(longi: doubleLongi, lati: doubleLati)
        
        // 현재위치 뷰컨트롤러 UI 업데이트
        updateUI(data: self.weatherData)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
    }
}




//MARK: - 위치정보에 대한 에러처
extension PageWeatherVC {
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

