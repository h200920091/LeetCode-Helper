//
//  LeetCode_HelperApp.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/1.
//

import SwiftUI

@main
struct LeetCode_HelperApp: App {
    @AppStorage("isDarkMode") var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
