//
//  ProblemRow.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/3.
//

import SwiftUI

struct QuestionRow: View {
    var question: Question
    var body: some View {
        HStack {
            Text(question.frontendQuestionId + ".")
            Text(question.title)
            Spacer()
        }
    }
}

struct ProblemRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuestionRow(question: questions[0])
                .previewLayout(.fixed(width: 300, height: 70))
            QuestionRow(question: questions[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
