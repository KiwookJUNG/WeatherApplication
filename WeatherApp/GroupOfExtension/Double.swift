//
//  Double.swift
//  WeatherApp
//
//  Created by 정기욱 on 06/08/2019.
//  Copyright © 2019 kiwook. All rights reserved.
//

import Foundation

//MARK: - 화씨 온도 변환을 위한 extension과 초속을을 변환하기 위한 extension
extension Double {
    var celsius : Double { return self - 273.15}
    var km : Double { return self / 1000 }
}
