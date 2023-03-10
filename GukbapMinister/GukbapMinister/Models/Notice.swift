//
//  Notice.swift
//  GukbapMinister
//
//  Created by κΉμν on 2023/03/03.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Notice: Codable, Hashable, Identifiable {
    var id: String
    var title: String
    var contents: String
}
