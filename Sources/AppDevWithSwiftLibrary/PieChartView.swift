//
//  SwiftUIView.swift
//  
//
//  Created by Kevin McQuown on 4/27/21.
//

import SwiftUI

public struct PieChartView: View {
    @State var slices: [Double]
    @State var colors: [Color]
    @State private var total = 0.0
    @State private var angles = [(Double, Double)]()

    public init(slices: [Double], colors: [Color]) {
        self.slices = slices
        self.colors = colors
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ForEach (slices.indices, id: \.self) { index in
                if index < angles.count {
                    Path { path in
                        path.move(to: CGPoint(x: geometry.size.width/2, y: geometry.size.width/2))
                        path.addArc(center: .init(x: geometry.size.width/2, y: geometry.size.width / 2), radius: geometry.size.width/2, startAngle: Angle(degrees: angles[index].0), endAngle: Angle(degrees: angles[index].1), clockwise: true)
                    }.fill(colors[index])
                }
            }
        }.onAppear {
            total = slices.reduce(0, +)
            var startAngle = 0.0
            for slice in slices {
                let endAngle = -((slice / total) * 360.0) + startAngle
                angles.append((startAngle, endAngle))
                startAngle = endAngle
            }
        }
    }
}
