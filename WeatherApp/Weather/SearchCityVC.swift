//
//  SearchCityVC.swift
//  WeatherApp
//
//  Created by 정기욱 on 04/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit
import MapKit


class SearchCityVC: UIViewController {
    
    let locationManager : CLLocationManager = CLLocationManager()
    @IBOutlet var searchBarView: UIView!
    @IBOutlet var searchedItemTable: UITableView!
    var searchController: UISearchController!
    
    var matchingItems: [MKMapItem] = []
    
    var selectedCity : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchedItemTable.separatorStyle = .none
        searchedItemTable.backgroundColor = UIColor(red:0.25, green:0.24, blue:0.24, alpha:1.0)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchBarView.addSubview(searchController.searchBar)
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "도시를 입력해주세요"
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.barStyle = .blackTranslucent
        
        definesPresentationContext = true
    }
    
    // 서치바를 FirstResponder로 지정해줘서 뷰 컨트롤러에 진입하는 순간 키보드가 활성화된다.
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}


    
//MARK: - 테이블 뷰 컨트롤러 DataSource 델리게이트
extension SearchCityVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    // 테이블 뷰 컨트롤러의 셀에 들어갈 정보를 표시해주기 위한 델리게이트 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        // 기본 셀로 한다.

        cell.backgroundColor = UIColor(red:0.25, green:0.24, blue:0.24, alpha:1.0)
        cell.textLabel?.textColor = .white
        // 셀의 배경색은 검은색으로 셀의 글 색은 하얀색으로 설정한다.
        
        let selectedItem = matchingItems[indexPath.row]
        // matchingItems 배열은 사용자가 입력한 검색어와 매칭되는 MKMapItem의 배열
        
        // 좌표 정보를 얻어온다.
        let latitude = selectedItem.placemark.coordinate.latitude
        let longitude = selectedItem.placemark.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        let locale = Locale(identifier: "Ko-kr") // 한글로 변환하기 위해 (MKMapItem의 주소가 영어일 경우가 있기때문에)
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) {(placemarks, error) in
            guard let place = placemarks?[0] else { return }
            
            var searchedString : String = ""
            
            // nil값을 해제한 뒤 셀에 표시해준다.
            if place.country != nil { searchedString = searchedString + place.country! }
            if place.administrativeArea != nil { searchedString = searchedString + " " + place.administrativeArea!}
            if place.locality != nil { searchedString = searchedString + " " + place.locality! }
            if place.thoroughfare != nil { searchedString = searchedString + " " + place.thoroughfare! }
            
            cell.textLabel?.text = searchedString
        }
        return cell
    }
}


//MARK: - 테이블 뷰 컨트롤러 델리게이트 : 사용자가 검색된 셀을 선택하였을 때
extension SearchCityVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
       
        
        let selectedCityInfo = self.matchingItems[indexPath.row]
        
        let latitude = selectedCityInfo.placemark.coordinate.latitude as Double
        let longitude = selectedCityInfo.placemark.coordinate.longitude as Double

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let aPoint = SavedPoint(longitude: longitude, latitude: latitude)
        
        appDelegate.savedPointRepo.append(aPoint)
        appDelegate.isBackedSearchCityVC = true
        appDelegate.pageViewControllerCounter += 1
        
        // 추가한 정보를 UserDefault에 저장
        let plist = UserDefaults.standard
        plist.setStructArray(appDelegate.savedPointRepo, forKey: "savedPoint")
        plist.synchronize()
        
        self.presentingViewController?.dismiss(animated: true)
    }
}



//MARK: - 서치 바 결과 업데이트 관리
extension SearchCityVC : UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    // 서치바에 업데이트가 되면 텍스트를 기반으로 MKLocalSearch request를 보낸다.
    func updateSearchResults(for searchController: UISearchController) {
    
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self]response, _ in
            guard let response = response else {
                return
            }
            
            print(response.mapItems)
            
            DispatchQueue.main.async {
                self?.matchingItems = response.mapItems
                self?.searchedItemTable.reloadData()
            }
        }
    }
    
    // 사용자가 텍스트를 모두 지웠을때 빈 테이블뷰를 리셋한다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            DispatchQueue.main.async {
                self.matchingItems = []
                self.searchedItemTable.reloadData()
            }
           
        }
    }
    
    // 사용자가 취소버튼을 클릭하면 이전 뷰 컨트롤러로 돌아간다.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presentingViewController?.dismiss(animated: true)
    }
}





