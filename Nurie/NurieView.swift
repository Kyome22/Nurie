//
//  NurieView.swift
//  Nurie
//
//  Created by Takuto Nakamura on 2022/11/25.
//

import SwiftUI

struct NurieView: View {
    @State private var magnifyBy = 1.0
    @State private var lastMagnificationValue = 1.0
    @State private var currentColor: Color = .white

    let character: NurieCharacters
    let colors: [Color] = [.white, .red, .orange, .yellow, .green, .mint, .blue, .purple]

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geometry in
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    CanvasView(currentColor: $currentColor,
                               parentSize: geometry.size,
                               character: character)
                        .scaleEffect(magnifyBy)
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(magnification)
            .padding(.horizontal, 8)
            HStack(spacing: 4) {
                ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                    Button {
                        currentColor = color
                    } label: {
                        Image(systemName: brushName(color))
                            .font(.title)
                            .foregroundColor(color)
                    }
                }
            }
            .padding(8)
            .background(Color(white: 0.3))
            .cornerRadius(12)
        }
        .padding(8)
    }

    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let changeRate = value / lastMagnificationValue
                magnifyBy *= changeRate
                lastMagnificationValue = value
            }
            .onEnded { value in
                lastMagnificationValue = 1.0
            }
    }

    func brushName(_ color: Color) -> String {
        return "paintbrush.pointed" + (currentColor == color ? ".fill" : "")
    }
}

struct NurieView_Previews: PreviewProvider {
    static var previews: some View {
        NurieView(character: .kuromi)
    }
}
