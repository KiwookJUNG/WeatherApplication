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
    
    @IBOutlet var pageCollectionView: UICollectionView!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 구현해야 할 코드 : UserDefault에서 좌표 정보를 읽어와 [weatherData]를 추가하는 메소드
        
        pageCollectionView.backgroundColor = .green
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
        locationManager.delegate = self
        
        //locationManager.requestWhenInUseAuthorization()
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
        
        let doubleLati = lastLocation.coordinate.latitude as Double
        let doubleLongi = lastLocation.coordinate.longitude as Double
        
        // 좌표가 업데이트 되면
        coordinateToWeather(longi: doubleLongi, lati: doubleLati, current : true)
        
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
