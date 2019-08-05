//
//  RootVC.swift
//  WeatherApp
//
//  Created by 정기욱 on 05/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit
import MapKit

class RootVC : UIViewController {
    
    var pageViewController : UIPageViewController!
    let locationManager : CLLocationManager = CLLocationManager()
    
    var currentIndex = 0
    var choosedIndex = 0
    var weatherDataArray : [WeatherData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 구현해야 할 코드 : UserDefault에서 좌표 정보를 읽어와 [weatherData]를 추가하는 메소드
        self.pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Root") as? UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let startVC = self.viewControllerAtIndex(index: choosedIndex) as PageWeatherVC
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
        locationManager.delegate = self
        
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        locationManager.startMonitoringSignificantLocationChanges()
        // 사용자의 위치가 500미터 이상 움직이면 locationManager(_:didUpdateLocations:) 메소드를 호출
        
    }
    
}

extension RootVC {
    func viewControllerAtIndex(index : Int) -> PageWeatherVC {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageWeatherVC") as? PageWeatherVC else { return PageWeatherVC() }
        
        vc.index = index
        vc.weatherData = self.weatherDataArray[index]
        //vc.previousStr = self.lblString[index]
        
        return vc
    }
}

extension RootVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed {
                if let currentViewController = pageViewController.viewControllers![0] as? PageWeatherVC {
                    currentIndex = currentViewController.index
                }
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
        let vc = viewController as! PageWeatherVC
        var index = vc.index as Int
            
        if (index == 0 || index == NSNotFound){
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
            
            
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
        let vc = viewController as! PageWeatherVC
        var index = vc.index as Int
            
        if(index == NSNotFound){
            return nil
        }
            
        index += 1
            
        if(index == self.weatherDataArray.count){
            return nil
        }
            
        return viewControllerAtIndex(index: index)
            
    }
        
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.weatherDataArray.count
    }
        
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.choosedIndex
    }
   

}




//MARK: - Mapkit에 대한 Extension
extension RootVC : CLLocationManagerDelegate {
    
    // 좌표가 업데이트되면 호출되는 델리게이트 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        let doubleLati = lastLocation.coordinate.latitude as Double
        let doubleLongi = lastLocation.coordinate.longitude as Double
        
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
