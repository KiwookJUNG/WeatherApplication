//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 정기욱 on 02/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit

//MARK : - Model & Parser

class WeatherData {
    
    var longitude : Int? // 위도
    var latitude : Int? // 경도
    
    var weather : String? // 날씨 상태 (맑음, 흐림, 비
    var description : String? // 날씨 설명
    var icon : String? // 날씨 아이콘
    
    var temperture : Double? // 기온 ( .celsius)
    var maxTemperture : Double?// 최고기온 ( .celsius)
    var minTemperture : Double? // 최저기온 ( .celsius)
    
    var pressure : Int? // 기압(hPa)
    var humidity : Int? // 습도(%)
    
    var visibility : Double? // 가시거리 ( .km )
    
    var windSpeed : Double? // 풍속
    var windDegree : Int? // 풍향
    
    var cloud : Int? // 구름 %
    
    var time : Int? // 시간 Unix
    var sunrise : Int? // 일출 UNIX
    var sunset : Int? // 일몰 UNIX
    
    var forecastArray : [ForecastWeatherData] = [] // ForecastWeatherData 구조체의 배열 (예보가 구조체 배열로 들어온다.)
    
    init(todayData : Data, forecastData : Data ) {
        do{
            let todayJSON = try JSONSerialization.jsonObject(with: todayData, options: []) as! NSDictionary
            let forecastJSON = try JSONSerialization.jsonObject(with: forecastData, options: []) as! NSDictionary
            
            let clouds = todayJSON["clouds"] as! NSDictionary
            self.cloud = clouds["all"] as? Int
            
            let coord = todayJSON["coord"] as! NSDictionary
            self.longitude = coord["lon"] as? Int
            self.latitude = coord["lat"] as? Int
            self.time = todayJSON["dt"] as? Int
            
            let main = todayJSON["main"] as! NSDictionary
            self.humidity = main["humidity"] as? Int
            self.pressure = main["pressure"] as? Int
            self.temperture = main["temp"] as? Double
            self.maxTemperture = main["temp_max"] as? Double
            self.minTemperture = main["temp_min"] as? Double
            
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
            self.windDegree = wind["deg"] as? Int
            
            let list = forecastJSON["list"] as! NSArray
            
            
            
            for hour in list {
                
                let hourData = hour as! NSDictionary
                let forecastThreeHour = ForecastWeatherData(jsonObject: hourData)
                
                self.forecastArray.append(forecastThreeHour)
            }
            
        } catch {}
    }
}

struct ForecastWeatherData {
    var time : Int? // 시간
    var timeString : String? // 시간(텍스트)
    
    var temperture : Double? // 기온 ( .celsius)
    var maxTemperture : Double?// 최고기온 ( .celsius)
    var minTemperture : Double? // 최저기온 ( .celsius)
    
    var weather : String?
    
    init(jsonObject : NSDictionary) {
        let main = jsonObject["main"] as! NSDictionary
        
        let weatherArray = jsonObject["weather"] as! NSArray
        let weather = weatherArray[0] as! NSDictionary
        
        
        self.time = jsonObject["dt"] as? Int
        self.timeString = jsonObject["dt_txt"] as? String
        
        self.temperture = main["temp"] as? Double
        self.maxTemperture = main["temp_min"] as? Double
        self.minTemperture = main["temp_max"] as? Double
        
        self.weather = weather["main"] as? String
    }
    
}


extension Double {
    var celsius : Double { return self - 273.15}
    var km : Double { return self / 1000 }
}


