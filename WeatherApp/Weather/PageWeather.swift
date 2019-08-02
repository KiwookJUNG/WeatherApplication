//
//  PageWeather.swift
//  WeatherApp
//
//  Created by 정기욱 on 02/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit
import MapKit

class PageWeather: UICollectionViewController {
    
    @IBOutlet var pageCollectionView: UICollectionView!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .green
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
    }
    
    
}



//MARK: - 콜렉션 뷰의 Extension 각 셀에 위치할 함수를 정해준다. 콜렉션 뷰는 총 2개이다.
extension PageWeather {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pageCollectionView {
            return 6
        } else {
            return 10
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
extension PageWeather : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == pageCollectionView{
            return CGSize(width: view.frame.width, height: view.frame.height)
        } else {
            return CGSize(width: 65, height: 78)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == pageCollectionView{
            return 0
        } else {
            return 10
        }
    }
}






//MARK: - Mapkit에 대한 Extension
extension PageWeather : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        print(String(format: "%.6f", lastLocation.coordinate.latitude))
        print(String(format: "%.6f", lastLocation.coordinate.longitude))
        
        //convertToAddressWith(coordinate: lastLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

//MARK: - 테이블 뷰 컨트롤러

extension PageWeather : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        
        cell.backgroundColor = .blue
        return cell
    }
}
