//
//  ArtworkModel.swift
//  Colora
//
//  Created by Raghad Alzemami on 14/04/1447 AH.
//


import SwiftUI

struct ArtworkModel: Identifiable, Hashable {
    let id: UUID
    var title: String
    var reflection: String
    var dateCreated: Date
    var timeSpent: TimeInterval
    var image: UIImage
    var imagePath: String? // Optional for now if not saving to disk

    init(title: String = "",
         reflection: String = "",
         dateCreated: Date = Date(),
         timeSpent: TimeInterval = 0,
         image: UIImage,
         imagePath: String? = nil) {
        self.id = UUID()
        self.title = title
        self.reflection = reflection
        self.dateCreated = dateCreated
        self.timeSpent = timeSpent
        self.image = image
        self.imagePath = imagePath
    }
}

