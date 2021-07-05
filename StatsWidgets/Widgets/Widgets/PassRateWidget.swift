//
//  PassRateWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct PassRateWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PassRateWidget", provider: Provider()) { entry in
            VStack {
                PassRateView(title: "Stats.PassRate.Title".localized,
                             progress: entry.passRate)
                Spacer()
                HorizontalRateView(progress: entry.testTaken,
                                   title: "Stats.MainRate.TestsTake".localized,
                                   color: Color(red: 73 / 255, green: 132 / 255, blue: 241 / 255))
                Spacer()
                HorizontalRateView(progress: entry.correctAnswers,
                                   title: "Stats.MainRate.CorrectAnswers".localized,
                                   color: Color(red: 254 / 255, green: 187 / 255, blue: 129 / 255))
                Spacer()
                HorizontalRateView(progress: entry.questionsTaken,
                                   title: "Stats.MainRate.QuestionsTaken".localized,
                                   color: Color(red: 254 / 255, green: 238 / 255, blue: 103 / 255))
            }
            .padding(16)
        }
        .supportedFamilies([.systemLarge])
    }
}

