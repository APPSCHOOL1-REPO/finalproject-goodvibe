//
//  NoticeView.swift
//  GukbapMinister
//
//  Created by 김요한 on 2023/02/13.
//

import SwiftUI

struct NoticeView: View {
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Text("국밥부 장관을 다운받아 주셔서 감사합니다.")
                    }
                    
                }
              
                Button {
                    dismiss()
                } label: {
                    Text("뒤로")
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("공지")
        }
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
