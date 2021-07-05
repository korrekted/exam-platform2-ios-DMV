//
//  MediumRateWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct MediumRateWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MediumRateWidget", provider: Provider()) { entry in
            HStack(alignment: .center) {
                VerticalRateView(progress: entry.testTaken,
                                 title: "Stats.MainRate.TestsTake".localized,
                                 color: Color(red: 73 / 255, green: 132 / 255, blue: 241 / 255))
                Spacer()
                VerticalRateView(progress: entry.correctAnswers,
                                 title: "Stats.MainRate.CorrectAnswers".localized,
                                 color: Color(red: 254 / 255, green: 187 / 255, blue: 129 / 255))
                Spacer()
                VerticalRateView(progress: entry.questionsTaken,
                                 title: "Stats.MainRate.QuestionsTaken".localized,
                                 color: Color(red: 254 / 255, green: 238 / 255, blue: 103 / 255))
            }
            .padding(16)
        }
        .supportedFamilies([.systemMedium])
    }
}
