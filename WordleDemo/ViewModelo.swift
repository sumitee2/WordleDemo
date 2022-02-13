//
//  ViewModelo.swift
//  WordleDemo
//
//  Created by Sumit Chaudhary on 13/02/22.
//

import Foundation
import SwiftUI

class ViewModelo: ObservableObject {
    let solution = allWords.randomElement()?.uppercased() ?? "ADIEU"
    @Published var typedWords: [String]
    @Published var rowInUse:Int = 0
    @Published var evaluatedStates: [[ButtonResult]]
    @Published var currentString: String = ""
    
    init(rows: Int = 6, columns: Int = 5) {
        print(solution)
        typedWords = ["", "", "", "", "", ""]
        evaluatedStates = [[.Wrong, .Wrong, .Wrong, .Wrong, .Wrong],
                           [.Wrong, .Wrong, .Wrong, .Wrong, .Wrong],
                           [.Wrong, .Wrong, .Wrong, .Wrong, .Wrong],
                           [.Wrong, .Wrong, .Wrong, .Wrong, .Wrong],
                           [.Wrong, .Wrong, .Wrong, .Wrong, .Wrong],
                           [.Wrong, .Wrong, .Wrong, .Wrong, .Wrong]]
        
    }
}
