//
//  Utility.swift
//  MovieCollection
//
//  Created by shiva ram on 26/09/22.
//
import Foundation
import UIKit


class Utility{
    //MARK : Get Image
    static func getImage(cache : NSCache<AnyObject, UIImage>? ,key: String, url: String, completion:(UIImage?) -> ()) {
        if let returnCacheImage = cache?.object(forKey: key as AnyObject) as? UIImage {
            completion(returnCacheImage)
        } else {
            var retImage: UIImage?
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    if let url = URL(string: url)
                    {
                        let data = try Data(contentsOf: url)
                        if let image = UIImage(data: data) {
                            retImage = image
                            cache?.setObject(image, forKey: key as AnyObject)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(retImage)
        }
    }
}
