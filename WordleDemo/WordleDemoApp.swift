//
//  WordleDemoApp.swift
//  WordleDemo
//
//  Created by Sumit Chaudhary on 10/02/22.
//

import SwiftUI

@main
struct WordleDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("appear")
                }
        }
    }
}
