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
    static func getImage(cache : NSCache<AnyObject, UIImage>? ,key: String, url: String, completion:(UIImage?,Bool) -> ()) {
        if let returnCacheImage = cache?.object(forKey: key as AnyObject){
            completion(returnCacheImage,true)
        } else {
            var retImage: UIImage?
            do {
                if let url = URL(string: url)
                {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        retImage = image
                        cache?.setObject(image, forKey: key as AnyObject)
                        completion(retImage,true)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            completion(retImage,false)
        }
    }
}
