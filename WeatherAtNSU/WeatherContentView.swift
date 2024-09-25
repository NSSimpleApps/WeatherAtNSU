//
//  WeatherContentView.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import SwiftUI

@available(iOS 13.0, *)
struct WeatherContentView: View {
    init(weatherLoader: AsyncWeatherLoader, location: String, image: String) {
        self.weatherLoader = weatherLoader
        self.location = location
        self.image = image
    }
    
    let weatherLoader: AsyncWeatherLoader
    let location: String
    let image: String
    
    @State var weather = ""
    @State var linkButtonDisabled = false
    @State var degrees: Double = 0
    
    var body: some View {
        ZStack {
            Image(self.image)
            .resizable()
            .scaledToFill()
            .frame(height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                Spacer(minLength: Constants.weatherAtLabelInset)
                
                let bigFont = Font.system(size: 60, weight: .semibold)
                let textColor = Color.white
                
                Text(Constants.weatherAtLabel).foregroundColor(textColor).font(.system(size: 14, weight: .semibold))
                Text(self.location).foregroundColor(textColor).font(bigFont)
                
                Spacer()
                
                Text(self.weather).foregroundColor(textColor).font(bigFont)
                
                Spacer()
                
                let updateWeatherButtonSize = Constants.updateWeatherButtonSize
                Button(action: {
                    self.degrees += 360
                    Task {
                        do {
                            self.weather = try await self.weatherLoader.loadWeather()
                        } catch {
                            print(error)
                            self.weather = "?"
                        }
                    }
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
                
                Spacer().frame(height: Constants.linksViewBottomInset + 50)
            }
        }
        .onAppear(perform: {
            Task {
                do {
                    self.weather = try await self.weatherLoader.loadWeather()
                } catch {
                    print(error)
                    self.weather = "?"
                }
            }
        })
    }
}
