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
    
    static var nsuURL: URL {
        return URL(string: "http://weather.nsu.ru/loadata.php")!
    }
    static var nsuPattern: String {
        return #"innerHTML\s+=\s+'(-?\d+)\.?(\d+)?"#
    }
    static var inpURL: URL {
        return URL(string: "http://thermo.inp.nsk.su")!
    }
    static var inpPattern: String {
        return #"(-?\d+)\.?(\d+)? °C"#
    }
    
    func loadWeather(completion: @escaping @Sendable (String) -> Void) {
        let pattern = self.pattern
        URLSession.shared.dataTask(with: self.url,
                                   completionHandler: { data, response, error in
            if let data, let string = String(data: data, encoding: .utf8) {
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

@available(iOS 13.0, *)
actor AsyncWeatherLoader {
    let url: URL
    let pattern: String
    init(url: URL, pattern: String) {
        self.url = url
        self.pattern = pattern
    }
    
    func loadWeather() async throws -> String {
        let pattern = self.pattern
        let data = try await URLSession.shared.data(from: self.url).0
        
        if let string = String(data: data, encoding: .utf8) {
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
                    return targetText
                } else {
                    throw NSError(domain: "DOMAIN", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot parse temperature."])
                }
            } else {
                throw NSError(domain: "DOMAIN", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot parse temperature."])
            }
        } else {
            throw NSError(domain: "DOMAIN", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot form a string."])
        }
    }
}
