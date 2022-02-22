//
//  WeatherAtNSUExtension.swift
//  WeatherAtNSUExtension
//
//  Created by user on 16.06.2021.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: TimelineProvider {
    private let weatherLoader = WeatherLoader.nsu
    
    typealias Entry = WeatherEntry
    
    func placeholder(in context: Context) -> WeatherEntry {
        return WeatherEntry(date: Date(), weather: Weather(id: 0, weather: "?"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        self.weatherLoader.loadData { weather in
            completion(WeatherEntry(date: Date(), weather: Weather(id: 0, weather: weather)))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        self.weatherLoader.loadData { weather in
            let timeline = Timeline(entries: [WeatherEntry(date: Date(), weather: Weather(id: 0, weather: weather))], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct Weather: Identifiable {
    let id: Int
    let weather: String
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let weather: Weather
}

struct WeatherAtNSUExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(self.entry.weather.weather)
    }
}

@main
struct WeatherAtNSUExtension: Widget {
    let kind = "WeatherAtNSUExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: self.kind, provider: Provider()) { timelineEntry in
            WeatherAtNSUExtensionEntryView(entry: timelineEntry)
        }
        .configurationDisplayName("Weather at NSU.")
        .description("Weather at NSU.")
    }
}

