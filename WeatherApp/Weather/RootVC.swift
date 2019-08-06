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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("RootVC viewDidLoad 호출")
        // 스토리보드에서 추가한 Page View Controller를 읽어온다.
        self.pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as? UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        // 저장된 데이터를 불러와 초기화
        savedDataInitializing()
        
        settingPageVC()
    }
}

//MARK: - PageViewContoller 세팅 및 저장된 데이터 초기화
extension RootVC {
    func viewControllerAtIndex(index : Int) -> PageWeatherVC {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageWeatherVC") as? PageWeatherVC else { return PageWeatherVC() }
        
        vc.index = index
        
        return vc
    }
    
    func savedDataInitializing() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let plist = UserDefaults.standard
        
        // 1. 사용자가 도시로 검색해 추가한 좌표를 읽어온다.
        // 2. 앱을시작하면 appDelegate.savedPointRepo가 초기화돼있으므로 UserDefaults에 저장된 정보를 대입해준다.
        // 3. 저장된 아이템 갯수만큼 페이지수를 정해주기 위해 pageViewControllerCounter도 저장된 정보를 대입
        let savedPointArray : [SavedPoint] = plist.structArrayData(SavedPoint.self, forKey: "savedPoint")
        appDelegate.savedPointRepo = savedPointArray
        appDelegate.pageViewControllerCounter = savedPointArray.count
        
        // weatherDataRepo 초기화
        for savedPoint in appDelegate.savedPointRepo {
            let weatherDate = coordinateToWeather(longi: savedPoint.longitude, lati: savedPoint.latitude)
            appDelegate.weatherDataRepo.append(weatherDate)
        }
        // 모든 정보를 초기화 시켜준다.
    }
    
    
    func settingPageVC() {
        
        //self.view.delete(self.pageViewController)
        //self.view.addSubview(UIView())
        //pageViewController.removeFromParent()
        
       
        pageViewController.view.removeFromSuperview()
        pageViewController.removeFromParent()
            
        let startVC = self.viewControllerAtIndex(index: choosedIndex) as PageWeatherVC
        let viewControllers = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
            
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
       
    }
    
}


//MARK: - PageViewContoller가 생성해야하는 뷰컨트롤러 인스턴스 설정
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = viewController as! PageWeatherVC
        var index = vc.index as Int
            
        if(index == NSNotFound){
            return nil
        }
            
        index += 1
            
        if(index == appDelegate.pageViewControllerCounter + 1){
            return nil
        }
            
        return viewControllerAtIndex(index: index)
            
    }
        
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.pageViewControllerCounter
    }
        
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.choosedIndex
    }
   

}






