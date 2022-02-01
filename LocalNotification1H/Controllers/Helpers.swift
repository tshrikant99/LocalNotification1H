//
//  Helpers.swift
//  LocalNotification1H
//
//  Created by Amin Siddiqui on 20/01/22.
//

import UIKit

typealias DownloadImageCompletion = (URL?)->Void

enum DownloadType {
    case image
    case gif
    case video
}

func downloadImage(type: DownloadType , from url: URL, directory: FileManager.SearchPathDirectory = .documentDirectory, completion: @escaping DownloadImageCompletion) {
    URLSession.shared.dataTask(with: url) { data, _, _ in
        
        guard let data = data else {
            completion(nil)
            return
        }
        
        let file = UUID().uuidString
        
        var extensionToSave = ""
        
        switch type {
        case .image:
            extensionToSave = ".jpg"
        case .gif:
            extensionToSave = ".gif"
        case .video:
            extensionToSave = ".mp4"
        }
        
        if let saveToURL = FileManager.default.urls(for: directory, in: .userDomainMask).first?.appendingPathComponent("\(file)\(extensionToSave)") {
            do {
                print(saveToURL)
                try data.write(to: saveToURL)
                completion(saveToURL)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    .resume()
}
