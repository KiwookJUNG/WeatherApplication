//
//  Int.swift
//  WeatherApp
//
//  Created by 정기욱 on 06/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import Foundation

//MARK: - Epoc 시간을 UTC 타임존으로 설정하여 원하는 형식으로 설정해기위해 String으로 변환하는 함수를 Extension
extension Int {
    var day : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let localDate = dateFormatter.string(from: time)
        return localDate
    }
    var AMPMHourMinute : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "a HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let localDate = dateFormatter.string(from: time)
        return localDate
    }
    
    
    var dayAndTime : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "E a h시"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let localDate = dateFormatter.string(from: time)
        return localDate
    }
    
    var today : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let localDate = dateFormatter.string(from: time)
        let today = dateFormatter.string(from: Date())
        if ( today == localDate){
            return "오늘"
        }
        
        return "오늘"
        
    }
}
