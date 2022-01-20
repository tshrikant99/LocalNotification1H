//
//  Helpers.swift
//  LocalNotification1H
//
//  Created by Amin Siddiqui on 20/01/22.
//

import UIKit

typealias DownloadImageCompletion = (URL?)->Void

func downloadImage(from url: URL, directory: FileManager.SearchPathDirectory = .documentDirectory, completion: @escaping DownloadImageCompletion) {
    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data else {
            completion(nil)
            return
        }
        
        let imageName = UUID().uuidString
        if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.9),
           let saveToURL = FileManager.default.urls(for: directory, in: .userDomainMask).first?.appendingPathComponent("\(imageName).jpg") {
            do {
                try imageData.write(to: saveToURL)
                completion(saveToURL)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    .resume()
}
