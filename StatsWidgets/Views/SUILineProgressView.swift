//
//  SUILineProgressView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct LineProgressView: View {
    var progress: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    var progressColor: Color {
        colorScheme == .dark
            ? Color.white
            : Color(red: 19 / 255, green: 24 / 255, blue: 42 / 255)
    }
    
    var trackColor: Color {
        colorScheme == .dark
            ? Color(red: 68 / 255, green: 68 / 255, blue: 68 / 255)
            : Color(red: 232 / 255, green: 234 / 255, blue: 237 / 255)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(trackColor)
                    .cornerRadius(geometry.size.height / 2)
                
                Rectangle()
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(progressColor)
                    .cornerRadius(geometry.size.height / 2)
            }
        }
    }
}
