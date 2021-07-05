//
//  TestTakenWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct TestTakenWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TestTakenWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.testTaken,
                                 title: "Stats.MainRate.TestsTake".localized,
                                 color: Color(red: 73 / 255, green: 132 / 255, blue: 241 / 255),
                                 alignment: .leading)
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
