//
//  ProblemDetail.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/5.
//

import SwiftUI

struct ProblemDetail: View {
    var question: Question
    
    var body: some View {
        ScrollView {
//            Text(question.frontendQuestionId + ". " + question.title)
//                .font(.title)
            HStack {
                let titleSlug = "https://leetcode.com/problems/" + question.titleSlug + "/"
                Text(titleSlug)
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
            .padding()
        }
        .navigationTitle(question.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProblemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProblemDetail(question: questions[0])
    }
}
