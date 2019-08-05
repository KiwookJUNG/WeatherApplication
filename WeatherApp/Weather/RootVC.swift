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
        
        // 구현해야 할 코드 : UserDefault에서 좌표 정보를 읽어와 [weatherData]를 추가하는 메소드
        
        self.pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as? UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        super.viewDidAppear(false)
        let startVC = self.viewControllerAtIndex(index: choosedIndex) as PageWeatherVC
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        
    }
    
 
}

extension RootVC {
    func viewControllerAtIndex(index : Int) -> PageWeatherVC {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageWeatherVC") as? PageWeatherVC else { return PageWeatherVC() }
        
        vc.index = index
        
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





