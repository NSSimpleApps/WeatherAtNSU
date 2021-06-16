//
//  WeatherLoader.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import Foundation


class WeatherLoader {
    func loadData(completion: @escaping (String) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "http://weather.nsu.ru/loadata.php")!,
                                   completionHandler: { data, response, error in
                                    if let data = data, let string = String(data: data, encoding: .utf8) {
                                        do {
                                            let nsString = string as NSString
                                            let pattern = #"innerHTML\s+=\s+'(-?\d+)\.?(\d+)?"#
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
