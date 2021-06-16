//
//  Constants.swift
//  WeatherAtNSU
//
//  Created by user on 16.06.2021.
//

import UIKit


struct Constants {
    private init() {}
    
    static var weatherAtLabelInset: CGFloat { return 44 }
    
    static var nsuImageName: String { return "nsu" }
    
    static var weatherAtLabel: String { return "ТЕМПЕРАТУРА ОКОЛО" }
    static var nsuLabel: String { return "НГУ" }
    
    static var linksViewBottomInset: CGFloat { return 16 }
    
    static var poweredByLabel: String { return "Powered by " }
    static var linkButtonLabel: String { return "NSSimpleApps" }
    
    static var updateWeatherImageName: String { return "update_weather" }
    
    static var githubURL: URL { return URL(string: "https://github.com/NSSimpleApps")! }
    
    static var updateWeatherButtonSize: CGFloat { return 70 }
    static var updateWeatherButtonBottomSpace: CGFloat { return 60 }
}
