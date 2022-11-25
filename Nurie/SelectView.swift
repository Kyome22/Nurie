//
//  SelectView.swift
//  Nurie
//
//  Created by Takuto Nakamura on 2022/11/25.
//

import SwiftUI

enum NurieCharacters: String, CaseIterable {
    case kuromi = "クロミちゃん"
    case maimero = "マイメロディ"

    var assetName: String {
        switch self {
        case .kuromi:  return "Kuromi"
        case .maimero: return "MyMelody"
        }
    }
}

struct SelectView: View {
    var body: some View {
        NavigationStack {
            List(NurieCharacters.allCases, id: \.self) { character in
                NavigationLink(character.rawValue, value: character)
            }
            .navigationDestination(for: NurieCharacters.self) { character in
                NurieView(character: character)
                    .navigationTitle(character.rawValue)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationTitle("キャラクターの一覧")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
