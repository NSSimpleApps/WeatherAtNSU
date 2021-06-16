//
//  WeatherContentView.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import SwiftUI

@available(iOS 13.0, *)
struct WeatherContentView: View {
    let weatherLoader = WeatherLoader()
    
    @State var weather = ""
    @State var linkButtonDisabled = false
    @State var degrees: Double = 0
    
    var body: some View {
        ZStack {
            Image(Constants.nsuImageName).resizable().aspectRatio(contentMode: .fill)//.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: Constants.weatherAtLabelInset)
                
                let bigFont = Font.system(size: 60, weight: .semibold)
                let textColor = Color.white
                
                Text(Constants.weatherAtLabel).foregroundColor(textColor).font(.system(size: 14, weight: .semibold))
                Text(Constants.nsuLabel).foregroundColor(textColor).font(bigFont)
                
                Spacer()
                
                Text(self.weather).foregroundColor(textColor).font(bigFont)
                
                Spacer()
                
                let updateWeatherButtonSize = Constants.updateWeatherButtonSize
                Button(action: {
                    self.degrees += 360
                    self.updateWeather()
                }, label: {
                    Image(Constants.updateWeatherImageName)
                        .rotationEffect(.degrees(self.degrees))
                        .animation(.easeInOut(duration: 0.35))
                })
                .frame(width: updateWeatherButtonSize, height: updateWeatherButtonSize)
                .background(Color.black.opacity(0.5)).cornerRadius(updateWeatherButtonSize / 2)
                
                Spacer().frame(height: Constants.updateWeatherButtonBottomSpace)
                
                HStack(spacing: 0, content: {
                    let smallFont = Font.system(size: 14, weight: .semibold)
                    Text(Constants.poweredByLabel).foregroundColor(textColor).font(smallFont)
                    Button(Constants.linkButtonLabel, action: {
                        self.linkButtonDisabled = true
                        UIApplication.shared.open(Constants.githubURL, options: [:], completionHandler: { _ in
                            self.linkButtonDisabled = false
                        })
                    }).font(smallFont).disabled(self.linkButtonDisabled)
                })
                
                Spacer().frame(height: Constants.linksViewBottomInset)
            }
        }.edgesIgnoringSafeArea(.all).onAppear(perform: {
            self.updateWeather()
        })
    }
    
    private func updateWeather() {
        self.weatherLoader.loadData(completion: { weather in
            DispatchQueue.main.async {
                self.weather = weather
            }
        })
    }
}
