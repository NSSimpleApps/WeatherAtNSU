//
//  WeatherLoader.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import Foundation


final class WeatherLoader {
    let url: URL
    let pattern: String
    init(url: URL, pattern: String) {
        self.url = url
        self.pattern = pattern
    }
    
    static var nsu: Self {
        return Self(url: URL(string: "http://weather.nsu.ru/loadata.php")!, pattern: #"innerHTML\s+=\s+'(-?\d+)\.?(\d+)?"#)
    }
    static var inp: Self {
        return Self(url: URL(string: "http://thermo.inp.nsk.su")!, pattern: #"(-?\d+)\.?(\d+)? °C"#)
    }
    
    func loadData(completion: @escaping (String) -> Void) {
        let pattern = self.pattern
        URLSession.shared.dataTask(with: self.url,
                                   completionHandler: { data, response, error in
                                    if let data = data, let string = String(data: data, encoding: .utf8) {
                                        do {
                                            let nsString = string as NSString
                                            let reg = try NSRegularExpression(pattern: pattern, options: [])
                                            if let match = reg.firstMatch(in: string, options: [], range: NSRange(location: 0, length: nsString.length)) {
                                                let numberOfRanges = match.numberOfRanges
                                                
                                                if numberOfRanges >= 2, case let range1 = match.range(at: 1), range1.length > 0 {
                                                    var result = nsString.substring(with: range1)
                                                    
                                                    if numberOfRanges >= 3, case let range2 = match.range(at: 2), range2.length > 0 {
                                                        result += "." + nsString.substring(with: range2)
                                                    }
                                                    
                                                    let targetText: String
                                                    if let first = result.first, first.isHexDigit {
                                                        targetText = "+" + result
                                                    } else {
                                                        targetText = result
                                                    }
                                                    
                                                    completion(targetText + "°C")
                                                    return
                                                }
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    } else if let error = error {
                                        print(error)
                                    }
                                    completion("?")
                                   }).resume()
    }
}
