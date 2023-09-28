//
//  ProblemList.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/5.
//

import SwiftUI

struct ProblemList: View {
    @State private var searchText = ""
    @State var isShowingSuggestions = false
    
    var body: some View {
        NavigationView {
            List (questions.filter {
                searchText.isEmpty || $0.title.localizedStandardContains(searchText)
            }, id: \.frontendQuestionId){ question in
                NavigationLink {
//                    ProblemDetail(question: question)
                    ProblemHtmlView(question: question)
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
            .searchable(text: $searchText)
        }
    }
}

struct ProblemList_Previews: PreviewProvider {
    static var previews: some View {
        ProblemList()
    }
}

func sendGraphQLRequest(titleSlug: String ,completion: @escaping (String?) -> Void) {
    // Your GraphQL service URL
    let graphqlURL = URL(string: "https://leetcode.com/graphql")!

    // Your GraphQL query and variables
    let query = """
    query questionContent($titleSlug: String!) {
      question(titleSlug: $titleSlug) {
        content
        mysqlSchemas
      }
    }
    """
    
    // Explicitly specify the type of the 'variables' dictionary
    let variables: [String: Any] = ["titleSlug": titleSlug]
    let requestBody: [String: Any] = ["query": query, "variables": variables]

    // Create an HTTP request
    var request = URLRequest(url: graphqlURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        // Convert the request body to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData

        // Create a URLSession instance
        let session = URLSession.shared

        // Send the request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                // Parse JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataDict = json["data"] as? [String: Any],
                   let questionDict = dataDict["question"] as? [String: Any],
                   let content = questionDict["content"] as? String {
                    // Handle the JSON response from GraphQL here
                    print(content)
                    completion(content) // 调用闭包并传递 content 值
                } else {
                    print("Failed to parse JSON response")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON response: \(error)")
                completion(nil)
            }
        }

        // Start the request
        task.resume()
    } catch {
        print("Error creating JSON data: \(error)")
        completion(nil)
    }
}
