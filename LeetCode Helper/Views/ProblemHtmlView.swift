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
        WebView(htmlContent: htmlContent)
                        .frame(maxWidth: .infinity)
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
