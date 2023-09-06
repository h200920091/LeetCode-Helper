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
                    ProblemCardRow(question: question)
                }
//                .listRowBackground(Color.white)
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                        .background(.clear)
                        .padding(
                            EdgeInsets(
                                top: 2,
                                leading: 10,
                                bottom: 2,
                                trailing: 10
                            )
                        )
                )
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
