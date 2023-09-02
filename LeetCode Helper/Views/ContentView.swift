//
//  ContentView.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("1. Two Sum")
                .font(.title)
            HStack {
                Text("https://leetcode.com/problems/two-sum/")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Divider()
           
            HStack {
                Text("Tags")
                Text("Difficulty")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Divider()
            
            HStack {
                Text("Problem Description")
            }
            
        }
        .padding()
        
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
