//
//  GetWeatherInformationProtocol.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit


// GetWeatherInformation 프로토콜을 extension 정의 및 구현

protocol GetWeatherInformation {
    
    func coordinateToWeather(longi: Double, lati: Double) -> WeatherData
    
}


//MARK: - PageWeatherVC 좌표를 이용해 날씨 API를 통해 얻어온 정보로 변환하여 저장하는 프로토콜 구현
extension PageWeatherVC: GetWeatherInformation {
    func coordinateToWeather(longi: Double, lati: Double) -> WeatherData{
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
        
        return weatherInfo
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        appDelegate.weatherDataRepo.insert(weatherInfo, at: 0) // 0번째 자리에 추가.
    }
}


//MARK: - RootVC에서 좌표를 이용해 날씨 API를 통해 얻어온 정보로 변환하여 저장하는 프로토콜 구현
extension RootVC: GetWeatherInformation {
    func coordinateToWeather(longi: Double, lati: Double) -> WeatherData{
    
        let frontURL = "http://api.openweathermap.org/data/2.5/"
        let APPID = "&APPID=7557a2e7185bcdda5baa43838b942438"
        
        let todayURL = frontURL + "weather?lat=\(Int(lati))&lon=\(Int(longi))" + APPID
        let forecastURL = frontURL + "forecast?lat=\(Int(lati))&lon=\(Int(longi))" + APPID
        
        let todayAPI: URL! = URL(string: todayURL)
        let todayAPIData = try! Data(contentsOf: todayAPI)
        
        let forecastAPI: URL! = URL(string: forecastURL)
        let forecastAPIData = try! Data(contentsOf: forecastAPI)
        
        let weatherInfo = WeatherData(todayData : todayAPIData, forecastData : forecastAPIData)
        
        return weatherInfo
    }
}

//MARK: - CityListWeatherVC에서 좌표를 이용해 날씨 API를 통해 얻어온 정보로 변환하여 저장하는 프로토콜 구현
extension CityListWeatherVC: GetWeatherInformation {
    func coordinateToWeather(longi: Double, lati: Double) -> WeatherData{
        
        let frontURL = "http://api.openweathermap.org/data/2.5/"
        let APPID = "&APPID=7557a2e7185bcdda5baa43838b942438"
        
        let todayURL = frontURL + "weather?lat=\(Int(lati))&lon=\(Int(longi))" + APPID
        let forecastURL = frontURL + "forecast?lat=\(Int(lati))&lon=\(Int(longi))" + APPID
        
        let todayAPI: URL! = URL(string: todayURL)
        let todayAPIData = try! Data(contentsOf: todayAPI)
        
        let forecastAPI: URL! = URL(string: forecastURL)
        let forecastAPIData = try! Data(contentsOf: forecastAPI)
        
        let weatherInfo = WeatherData(todayData : todayAPIData, forecastData : forecastAPIData)
        
        return weatherInfo
    }
}
