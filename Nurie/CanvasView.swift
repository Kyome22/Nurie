//
//  CanvasView.swift
//  Nurie
//
//  Created by Takuto Nakamura on 2022/11/25.
//

import SwiftUI
import SVG2Path

struct NurieData: Identifiable {
    let id: Int
    let path: Path
    var color: Color = .white
}

struct CanvasView: View {
    @Binding var currentColor: Color
    @State var size: CGSize = .zero
    @State var paths = [NurieData]()
    @State var ratio: Double = 1.0
    private let svg2Path = SVG2Path()
    let parentSize: CGSize
    let character: NurieCharacters

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(0 ..< paths.count, id: \.self) { index in
                    if paths[index].path.isClose() {
                        paths[index].path
                            .fillAndStroke(fillColor: paths[index].color,
                                           strokeColor: Color.black)
                            .frame(width: size.width, height: size.height)
                            .onTapGesture(count: 1) {
                                var item = paths[index]
                                item.color = currentColor
                                paths[index] = item
                            }
                    } else {
                        paths[index].path
                            .stroke(Color.black)
                            .frame(width: size.width, height: size.height)
                    }
                }
            }
        }
        .scaleEffect(CGSize(width: ratio, height: ratio))
        .background(Color.white)
        .onAppear {
            if let asset = NSDataAsset(name: character.assetName),
               let text = String(data: asset.data, encoding: .utf8),
               let data = svg2Path.extractPath(text: text) {
                size = data.size
                paths = data.paths
                    .enumerated()
                    .map({ NurieData(id: $0.offset, path: $0.element) })
                let wRatio = parentSize.width / size.width
                let hRatio = parentSize.height / size.height
                ratio = min(wRatio, hRatio)
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(currentColor: .constant(.red), parentSize: .zero, character: .kuromi)
    }
}

extension Shape {
    func fillAndStroke(fillColor: Color, strokeColor: Color) -> some View {
        ZStack {
            self.fill(fillColor)
            self.stroke(strokeColor)
        }
    }
}

extension Path {
    func isClose() -> Bool {
        var flag: Bool = false
        self.cgPath.applyWithBlock { element in
            flag = flag || (element.pointee.type == CGPathElementType.closeSubpath)
        }
        return flag
    }
}
