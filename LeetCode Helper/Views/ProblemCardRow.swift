//
//  ProblemCardRow.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/6.
//

import SwiftUI

struct ProblemCardRow: View {
    var question: Question
    var body: some View {
        Text(question.title)

    }
}

struct ProblemCardRow_Previews: PreviewProvider {
    static var previews: some View {
        ProblemCardRow(question: questions[0])
    }
}
