//
//  Int.swift
//  WeatherApp
//
//  Created by 정기욱 on 06/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import Foundation

extension Int {
    var day : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = .current
        
        let localDate = dateFormatter.string(from: time)
        return localDate
    }
    var dayAndTime : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "E a h시"
        dateFormatter.timeZone = .current
        
        let localDate = dateFormatter.string(from: time)
        return localDate
    }
    
    var today : String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = .current
        
        let localDate = dateFormatter.string(from: time)
        let today = dateFormatter.string(from: Date())
        if ( today == localDate){
            return "오늘"
        }
        
        return "오늘이아님"
        
    }
}
