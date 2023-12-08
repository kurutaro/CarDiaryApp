//
//  DiaryEntry.swift
//  CarDiaryApp
//
//  Created by naoya on 2023/12/07.
//

import Foundation
import RealmSwift

class DiaryModel:Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var date = Date()
    @objc dynamic var content = ""
    @objc dynamic var photoData: Data?
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    var photo: UIImage? {
        if let data = photoData {
            return UIImage(data: data)
        }
        return nil
    }
}

