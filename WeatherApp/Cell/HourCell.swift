//
//  HourCell.swift
//  WeatherApp
//
//  Created by 정기욱 on 06/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import UIKit

//MARK: - Collection View를 위한 커스텀 셀
class HourCell: UICollectionViewCell {
    
    @IBOutlet var time: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var temperature: UILabel!
    
}
