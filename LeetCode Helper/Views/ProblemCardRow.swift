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
        HStack(){
            Text(question.frontendQuestionId + "  ")
                .font(.system(size: 13))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(question.title)
                    .font(.system(size: 14))
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(question.topicTags, id: \.self) { tag in
                            Text(tag.name)
                                .font(.system(size: 9))
                                .lineLimit(1) // Limit to one line
                                .truncationMode(.tail) // Truncate with ...
                                .padding(.horizontal, 6) // Add horizontal padding
                                .padding(.vertical, 2) // Add vertical padding
                                .background(Color.gray.opacity(0.3)) // Gray background
                                .cornerRadius(10) // Rounded corners
                        }
                    }
                }
            }
            
            Spacer()
            
            var circleColor: Color {
                switch question.difficulty {
                case "Easy":
                    return .green
                case "Medium":
                    return .yellow
                case "Hard":
                    return .red
                default:
                    return .gray // Default color for unknown difficulty
                }
            }
            
            ZStack{
                Text(String(format: "%.1f%%", question.acRate))
                    .font(.system(size: 10))
                Circle()
                    .stroke(circleColor.opacity(0.10), lineWidth: 5)
                Circle()
                    .trim(from: 0, to: question.acRate/100)
                    .stroke(
                        circleColor,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 50)
        }
    }
}

struct ProblemCardRow_Previews: PreviewProvider {
    static var previews: some View {
        ProblemCardRow(question: questions[0])
    }
}
