//
//  DayCell.swift
//  WeatherApp
//
//  Created by 정기욱 on 07/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit

//MARK: - Table View를 위한 커스텀 셀
class DayCell: UITableViewCell {
    
    
    @IBOutlet var day: UILabel!
    
    @IBOutlet var weather: UILabel!
    
    @IBOutlet var maxTemperature: UILabel!
    
    @IBOutlet var minTemperature: UILabel!
    
    
}
