//
//  CalendarModal.swift
//  Colora
//
//  Created by Raghad Alzemami on 15/04/1447 AH.
//

import Foundation
import UIKit

final class CalendarModel: ObservableObject {
    static let shared = CalendarModel()

    @Published var artworks: [Artwork] = []

    private init() {
        loadArtworks()
    }
    
    func addArtwork(name: String, image: UIImage) {
           if let data = image.pngData() {
               let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                   .appendingPathComponent(name)
               try? data.write(to: url)
           }

           // حفظ داخل المصفوفة عشان التقويم يعرفها
           let formatter = DateFormatter()
           formatter.dateFormat = "dd MMM" // التاريخ كسلسلة نصية
           let artwork = Artwork(
               imageName: name,
               title: "Untitled Artwork",
               description: "No reflection added.",
               date: formatter.string(from: Date()).uppercased(),
               timeSpent: "—"
           )

           artworks.append(artwork)
       }

    func addArtwork(name: String, title: String, description: String, image: UIImage) {
        let new = Artwork(
            imageName: name,
            title: title.isEmpty ? "Untitled Artwork" : title,
            description: description.isEmpty ? "No reflection added." : description,
            date: formatDate(Date()),
            timeSpent: "—"
        )
        artworks.append(new)
        saveImageLocally(image, name: name)
        saveArtworks()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date).uppercased()
    }

    private func saveImageLocally(_ image: UIImage, name: String) {
        if let data = image.pngData() {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(name)
            try? data.write(to: url)
        }
    }

    private func saveArtworks() {
        if let data = try? JSONEncoder().encode(artworks) {
            UserDefaults.standard.set(data, forKey: "savedArtworks")
        }
    }

    private func loadArtworks() {
        if let data = UserDefaults.standard.data(forKey: "savedArtworks"),
           let decoded = try? JSONDecoder().decode([Artwork].self, from: data) {
            self.artworks = decoded
        }
    }
}
