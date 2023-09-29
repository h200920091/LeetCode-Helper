//
//  ProblemHtmlView.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/27.
//

import SwiftUI
import WebKit

struct HTMLView: View {
    let htmlContent: String
    var question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question.title)
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            
            Divider()
            
            HStack {
                Text(question.difficulty)
                    .foregroundColor(difficultyColor(for: question.difficulty))
                    .font(.system(size: 9))
                    .lineLimit(1) // Limit to one line
                    .truncationMode(.tail) // Truncate with ...
                    .padding(.horizontal, 6) // Add horizontal padding
                    .padding(.vertical, 2) // Add vertical padding
                    .background(Color.gray.opacity(0.2)) // Gray background
                    .cornerRadius(10) // Rounded corners
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(question.topicTags, id: \.id) { tag in
                            Text(tag.name)
//                                .foregroundStyle(.black)
                                .font(.system(size: 9))
                                .lineLimit(1) // Limit to one line
                                .truncationMode(.tail) // Truncate with ...
                                .padding(.horizontal, 6) // Add horizontal padding
                                .padding(.vertical, 2) // Add vertical padding
                                .background(Color.gray.opacity(0.2)) // Gray background
                                .cornerRadius(10) // Rounded corners
                        }
                    }
                }
            }
            
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Divider()
            WebView(htmlContent: htmlContent)
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
            
        }
    }
    
    func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "Easy":
            return .green
        case "Medium":
            return .orange
        case "Hard":
            return .red
        default:
            return .gray // Default color for unknown difficulty
        }
    }
}

struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "about:blank") {
            uiView.loadHTMLString(htmlContent, baseURL: url)
        }
    }
}

struct ProblemHtmlView: View {
    var question: Question
    @State private var htmlContent: String = ""
    
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        ScrollView {
            HTMLView(htmlContent: htmlContent,question: question)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .onAppear {
            sendGraphQLRequest(titleSlug: question.titleSlug) { content in
                            if let content = content {
                                print(content)
                                self.htmlContent = content // 更新 @State 中的 htmlContent
                            } else {
                                print("Failed to fetch HTML content")
                            }
                        }
        }
    }
}

#Preview {
    ProblemHtmlView(question: questions[0])
}
