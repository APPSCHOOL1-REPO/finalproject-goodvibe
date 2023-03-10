//
//  CommentUnit.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//

import SwiftUI

struct CommentUnit: View {
    var nickname: String = "써니"
    var date: String = "2023.01.17"
    var starRate: Int = 3
    var comment: String = "여기 외 않와? 꼭 가세요"
    var images: [String] = ["Test"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(nickname)
                    .font(.headline)
                Spacer()
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            .padding(.bottom, 5)
            
            //깍두기점
            HStack(spacing: 1){
                ForEach(0..<5) { index in
                    Image(starRate >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.bottom, 15)
            
            
            Text(comment)
                .lineLimit(3)
                .font(.footnote)
                .padding(.bottom, 15)
            
            if images.count > 0 {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(Array(images.enumerated()), id: \.offset) { (index, image) in
                            Text("\(index)")
                                .frame(width: 100, height: 100)
                                .background(.yellow)
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                .frame(height:100)
            }
            
        }
        .padding()
        .background(.white)
    }
}

struct CommentUnit_Previews: PreviewProvider {
    static var previews: some View {
        CommentUnit()
    }
}
