//
//  GetWeatherInformationProtocol.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit


// GetWeatherInformation 프로토콜을 extension 정의 및 구현

@objc protocol GetWeatherInformation {
    
    func coordinateToWeather(longi: Double, lati: Double)
    
    @objc optional func updateWeatherData()
    // viewDidLoad에서 UserDefault 저장소에 저장된 (세 번째 뷰 컨트롤러에서 저장할 예정인 데이터) [SavedPoint]를
    // 불러와서 .count 가 > 0 이면 일단 AppDelegate의 savedPointList : [SavedPoint]에 저장하고
    // AppDelegate에 savedPointList를 for loop를 돌면서
    // -> coordinateToWeather 메소드를 호출하면됨.
    // (WeatherData(초기화)를 해준 뒤 AppDelegate의 weatherDataList에 append를 통해 저장)
}


//MARK: - 좌표를 이용해 날씨 API를 통해 얻어온 정보로 변환하여 저장하는 프로토콜 구현
extension PageWeatherVC: GetWeatherInformation {
    func coordinateToWeather(longi: Double, lati: Double) {
        // 이 좌표는 UserDefault에 저장될 필요가 없는 좌표이다.
        // 왜냐하면 매번 갱신되기 떄문
        
        let frontURL = "http://api.openweathermap.org/data/2.5/"
        let APPID = "&APPID=7557a2e7185bcdda5baa43838b942438"
        
        let todayURL = frontURL + "weather?lat=\(Int(lati))&lon=\(Int(longi))" + APPID
        let forecastURL = frontURL + "forecast?lat=\(Int(lati))&lon=\(Int(longi))" + APPID
        
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
