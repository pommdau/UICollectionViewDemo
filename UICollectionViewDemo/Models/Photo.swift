//
//  Photo.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/16.
//

import UIKit

struct Photo {
    var caption: String
    var comment: String
    var image: UIImage
    
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    init?(name: String) {
        guard let image = UIImage(named: name) else { return nil }
        
        self.init(caption: String(format: "%@.jpg", name),
                  comment: String(format: "This title is %@.", name),
                  image: image)
        
    }
    
    static func allPhotos() -> [Photo] {
        let photoList = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"]
        var photos: [Photo] = []
        
        for photoName in photoList {
            if let photo = Photo(name: photoName) {
                photos.append(photo)
            }
        }
    
        return photos
    }
}

