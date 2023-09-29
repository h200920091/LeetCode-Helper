//
//  ProblemList.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/5.
//

import SwiftUI

struct ProblemList: View {
    @State private var searchText = ""
    @AppStorage("isDarkMode") var isDarkMode = false
    @State var isShowingSuggestions = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List (questions.filter {
                searchText.isEmpty || $0.title.localizedStandardContains(searchText)
            }, id: \.frontendQuestionId){ question in
                NavigationLink(destination: ProblemHtmlView(question: question)) {
                    ProblemCardRow(question: question)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(colorScheme == .dark ? Color.black.opacity(0.25) : Color.white)
                        .background(.clear)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
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
            .searchable(text: $searchText)
            .toolbar {
                Button(action: {
                    isDarkMode.toggle()
//                    getAllQuestions { result in
//                        switch result {
//                        case .success:
//                            let _ = print("Update Successfully.")
//                        case .failure(let error):
//                            print("Error: \(error)")
//                        }
//                    }
                }) {
                    Image(systemName: "moon")
                }
            }
        }
            
    }
}

struct ProblemList_Previews: PreviewProvider {
    static var previews: some View {
        ProblemList()
    }
}


