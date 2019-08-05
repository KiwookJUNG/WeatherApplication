//
//  PageWeatherVC.swfit.swift
//  WeatherApp
//
//  Created by 정기욱 on 03/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit


class PageWeatherVC: UIViewController {
    
    @IBOutlet var city: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var temperature: UILabel!
    
    @IBOutlet var day: UILabel!
    @IBOutlet var isToday: UILabel!
    
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var minTemperature: UILabel!
    
    var index : Int = 0
    var weatherData : WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
}





