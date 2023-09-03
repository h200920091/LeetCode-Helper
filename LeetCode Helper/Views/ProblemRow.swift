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
        Text(question.title)
    }
}

struct ProblemRow_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRow(question: questions[0])
    }
}
