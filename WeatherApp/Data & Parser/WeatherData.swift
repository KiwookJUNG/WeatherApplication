//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 정기욱 on 02/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit

//MARK: - 사용자가 추가한 위치정보를 저장하는 구조체
struct SavedPoint: Codable{
    var longitude : Double
    var latitude : Double
}

//MARK: - Data Model & Parser
class WeatherData {
    
    var longitude : Double? // 위도
    var latitude : Double? // 경도
    
    var weather : String? // 날씨 상태
    var description : String? // 날씨 설명
    var icon : String? // 날씨 아이콘
    
    var temperature : Double? // 기온 ( .celsius)
    var maxTemperature : Double?// 최고기온 ( .celsius)
    var minTemperature : Double? // 최저기온 ( .celsius)
    
    var pressure : Double? // 기압(hPa)
    var humidity : Double? // 습도(%)
    
    var visibility : Double? // 가시거리 ( .km )
    
    var windSpeed : Double? // 풍속
    var windDegree : Double? // 풍향
    
    var cloud : Int? // 구름양
    
    var timezone : Int? // UTC 기준 타임존
    var time : Int? // Unix
    var sunrise : Int? // 일출
    var sunset : Int? // 일몰
    
    var forecastArray : [ForecastWeatherData] = []
    
    // 초기화 및 파싱
    init(todayData : Data, forecastData : Data ) {
        do{
            let todayJSON = try JSONSerialization.jsonObject(with: todayData, options: []) as! NSDictionary
            let forecastJSON = try JSONSerialization.jsonObject(with: forecastData, options: []) as! NSDictionary
            
            let clouds = todayJSON["clouds"] as! NSDictionary
            self.cloud = clouds["all"] as? Int
            
            let coord = todayJSON["coord"] as! NSDictionary
            self.longitude = coord["lon"] as? Double
            self.latitude = coord["lat"] as? Double
            self.time = todayJSON["dt"] as? Int
            self.timezone = todayJSON["timezone"] as? Int
            
            let main = todayJSON["main"] as! NSDictionary
            self.humidity = main["humidity"] as? Double
            self.pressure = main["pressure"] as? Double
            self.temperature = main["temp"] as? Double
            self.maxTemperature = main["temp_max"] as? Double
            self.minTemperature = main["temp_min"] as? Double
            
            let sys = todayJSON["sys"] as! NSDictionary
            self.sunrise = sys["sunrise"] as? Int
            self.sunset = sys["sunset"] as? Int
            self.visibility = todayJSON["visibility"] as? Double
            
            
            let weatherArray = todayJSON["weather"] as! NSArray
            let weather = weatherArray[0] as! NSDictionary
            self.description = weather["description"] as? String
            self.icon = weather["icon"] as? String
            self.weather = weather["main"] as? String
            
            
            let wind = todayJSON["wind"] as! NSDictionary
            self.windSpeed = wind["speed"] as? Double
            self.windDegree = wind["deg"] as? Double
            
            let list = forecastJSON["list"] as! NSArray
            
            
            
            for hour in list {
                
                let hourData = hour as! NSDictionary
                let forecastHourly = ForecastWeatherData(jsonObject: hourData)
                
                self.forecastArray.append(forecastHourly)
            }
            
        } catch {}
    }
}

//MARK: - Data Model 내부에 들어가는 약 40개의 간단한 일기예보
struct ForecastWeatherData {
    var time : Int? // 시간
    var timeString : String?
    
    var temperature : Double? // 기온 ( .celsius)
    var maxTemperature : Double?// 최고기온 ( .celsius)
    var minTemperature : Double? // 최저기온 ( .celsius)
    
    var weather : String? // 날씨
    
    // 초기화 및 파싱
    init(jsonObject : NSDictionary) {
        let main = jsonObject["main"] as! NSDictionary
        
        let weatherArray = jsonObject["weather"] as! NSArray
        let weather = weatherArray[0] as! NSDictionary
        
        
        self.time = jsonObject["dt"] as? Int
        self.timeString = jsonObject["dt_txt"] as? String
        
        self.temperature = main["temp"] as? Double
        self.maxTemperature = main["temp_min"] as? Double
        self.minTemperature = main["temp_max"] as? Double
        
        self.weather = weather["main"] as? String
    }
    
}





