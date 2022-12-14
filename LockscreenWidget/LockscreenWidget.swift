//
//  LockscreenWidget.swift
//  LockscreenWidget
//
//  Created by 민채호 on 2022/12/29.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private let coreDataManager = CoreDataManager.shared
    
    private func getTodayChallenge() -> String {
        let todayChallenge = coreDataManager.getChallengeOf(Date())
        if todayChallenge.count > 0 {
            return todayChallenge[0].content
        } else {
            return "오늘의 챌린지를 등록하세요"
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), challenge: getTodayChallenge())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), challenge: getTodayChallenge())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentTimeZoneDate = Date().currentTimeZoneDate()
        let midnight = Calendar.current.startOfDay(for: currentTimeZoneDate)
        let nextMidnight = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: midnight
        )!
        
        let entry = SimpleEntry(
            date: currentTimeZoneDate,
            challenge: getTodayChallenge()
        )
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let challenge: String
}

struct LockscreenWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .accessoryRectangular:
            Text(entry.challenge)
        default:
            Text("Not Implemented")
        }
    }
}

@main
struct LockscreenWidget: Widget {
    let kind: String = "LockscreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockscreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("오늘의 챌린지")
        .description("오늘의 챌린지를 확인합니다.")
        .supportedFamilies([
            .accessoryRectangular
        ])
    }
}

struct LockscreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockscreenWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: "오늘의 챌린지를 등록하세요")
        )
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        .previewDisplayName("Rectangular")
    }
}
