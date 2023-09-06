//
//  ProblemList.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/5.
//

import SwiftUI

struct ProblemList: View {
    var body: some View {
        NavigationView {
            List (questions, id: \.frontendQuestionId){ question in
                NavigationLink {
                    ProblemDetail(question: question)
                } label: {
                    QuestionRow(question: question)
                }
            }
            .navigationTitle("Problems")
        }
    }
}

struct ProblemList_Previews: PreviewProvider {
    static var previews: some View {
        ProblemList()
    }
}
