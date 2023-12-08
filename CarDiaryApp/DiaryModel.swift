//
//  DiaryEntry.swift
//  CarDiaryApp
//
//  Created by naoya on 2023/12/07.
//

import Foundation
import UIKit

struct DiaryEntry {
    var title: String
    var date: Date
    var content: String
    var photo: UIImage? // オプショナルで写真を含む
    var location: (latitude: Double, longitude: Double)? // オプショナルで位置情報を含む
}
