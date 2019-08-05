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
    
   
    @IBOutlet var searchBarView: UIView!
    @IBOutlet var searchedItemTable: UITableView!
    var searchController: UISearchController!
    
    var matchingItems: [MKMapItem] = []
    
    
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        //UIColor(red:0.25, green:0.24, blue:0.24, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.25, green:0.24, blue:0.24, alpha:1.0)
        cell.textLabel?.textColor = .white
        
        
        let selectedItem = matchingItems[indexPath.row]
        
        let latitude = selectedItem.placemark.coordinate.latitude
        let longitude = selectedItem.placemark.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locale = Locale(identifier: "Ko-kr")
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) {(placemarks, error) in
            guard let place = placemarks?[0] else {
                return
            }
            var searchedString : String = ""
            if place.country != nil {
                searchedString = searchedString + place.country!
            }
            
            if place.administrativeArea != nil {
                searchedString = searchedString + " " + place.administrativeArea!
            }
            if place.locality != nil {
                searchedString = searchedString + " " + place.locality!
            }
            
            if place.thoroughfare != nil {
                searchedString = searchedString + " " + place.thoroughfare!
            }
            searchedString = searchedString + ", " + selectedItem.name! 
            
            cell.textLabel?.text = searchedString
        }
        return cell
    }
}


//MARK: - 테이블 뷰 컨트롤러 델리게이트
extension SearchCityVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        print("사용자가 선택함")
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
    
 
    
    // 사용자가 텍스트를 모두 지웠을때 테이블뷰를 리셋한다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            DispatchQueue.main.async {
                self.matchingItems = []
                self.searchedItemTable.reloadData()
            }
           
        }
    }
    
  
    
    
}
