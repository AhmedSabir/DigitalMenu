//
//  ImageLoader-SDWebImage.swift
//  TMM-Ios
//
//  Created by Aakash Srivastav on 21/12/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import SDWebImage

final class ImageLoader_SDWebImage {
    
    typealias CompletionHandler = (() -> Void)
    typealias ImageCompletionHandler = ((UIImage?, Error?) -> Void)
    typealias CacheCompletionHandler = ((Bool) -> Void)
    
    static let placeholder = UIImage(named: "NoImage.png")!
    
    static var shouldQueryMemoryDataSync = true
    static var shouldQueryDiskDataSync = true
    static var shouldDelayPlaceholder = true
    
    static func setupImageLoader() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.path
        
        let config = SDImageCacheConfig()
        config.shouldUseWeakMemoryCache = false
        config.maxDiskAge = -1
        
        let cache = SDImageCache(namespace: "PermanentCache", diskCacheDirectory: filePath, config: config)
        SDWebImageManager.defaultImageCache = cache
        SDWebImageDownloaderConfig.default.downloadTimeout = 30
    }
    
    static func deleteCachedImages(cacheType: SDImageCacheType, completion: CompletionHandler? = nil) {
        SDWebImageManager.shared.imageCache.clear(with: cacheType) {
            completion?()
        }
    }
    
    static func cacheExist(for imageName: String?, completion: @escaping CacheCompletionHandler) {
        
        if let imgString = imageName,
            let imgURL = URL(string: settingString.Setting+"/images/"+imgString),
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imgURL) {
            
            SDWebImageManager.shared.imageCache.containsImage(forKey: cacheKey, cacheType: .all) { cache in
                switch cache {
                case .none:
                    completion(false)
                case .disk, .memory, .all:
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    static func downloadImage(_ imageName: String?, completion: @escaping ImageCompletionHandler) {
        
        guard let imgString = imageName, !imgString.isEmpty,
            let imgURL = URL(string: settingString.Setting+"/images/"+imgString),
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imgURL) else {
                let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])
                completion(nil, error as Error)
                return
        }
        
        cacheExist(for: imageName) { exists in
            if exists {
                
                SDWebImageManager.shared.imageCache.queryImage(forKey: cacheKey, options: [.avoidDecodeImage], context: nil) { (image, data, cacheType) in
                    completion(image, nil)
                }
                
            } else {
                
                SDWebImageManager.shared.imageLoader.requestImage(with: imgURL, options: [.avoidDecodeImage], context: nil, progress: nil, completed: { (image, data, error, finished) in
                    if let error = error {
                        completion(nil, error)
                    } else if let img = image {
                        
                        SDWebImageManager.shared.imageCache.store(img, imageData: data, forKey: cacheKey, cacheType: .disk, completion: {
                            completion(img, nil)
                        })
                    } else {
                        completion(nil, nil)
                    }
                })
            }
        }
    }
    
    static func setImage(_ imageName: String?, into imageView: UIImageView, completion: ImageCompletionHandler? = nil) {
        
        guard let imgString = imageName,
            let imgURL = URL(string: settingString.Setting+"/images/"+imgString) else {
                imageView.image = placeholder
                let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])
                completion?(nil, error as Error)
                return
        }
        
        let options: SDWebImageOptions
        
        if shouldQueryMemoryDataSync && shouldQueryDiskDataSync {
            options = [.queryMemoryDataSync, .queryDiskDataSync, .delayPlaceholder]
        } else if !shouldQueryMemoryDataSync && shouldQueryDiskDataSync {
            options = [.queryDiskDataSync, .delayPlaceholder]
        } else if shouldQueryMemoryDataSync && !shouldQueryDiskDataSync {
            options = [.queryMemoryDataSync, .delayPlaceholder]
        } else {
            options = SDWebImageOptions()
        }
        
        imageView.sd_setImage(with: imgURL, placeholderImage: placeholder, options: options) { (image, error, _, _) in
            if let error = error,
                (error as NSError).code == 2002 {
                return
            }
            if image == nil {
                imageView.image = placeholder
            }
            completion?(image, error)
        }
    }
    
    static func getImage(_ imageName: String?, completion: @escaping ImageCompletionHandler) {
        
        guard let imgString = imageName,
            let imgURL = URL(string: settingString.Setting+"/images/"+imgString),
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imgURL) else {
                let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])
                completion(nil, error as Error)
                return
        }
        
        let options: SDWebImageOptions
        
        if shouldQueryMemoryDataSync && shouldQueryDiskDataSync {
            options = [.queryMemoryDataSync, .queryDiskDataSync, .delayPlaceholder]
        } else if !shouldQueryMemoryDataSync && shouldQueryDiskDataSync {
            options = [.queryDiskDataSync, .delayPlaceholder]
        } else if shouldQueryMemoryDataSync && !shouldQueryDiskDataSync {
            options = [.queryMemoryDataSync, .delayPlaceholder]
        } else {
            options = SDWebImageOptions()
        }
        
        SDWebImageManager.shared.imageCache.queryImage(forKey: cacheKey, options: options, context: nil) { (image, data, cacheType) in
            if let img = image {
                completion(img, nil)
            } else {
                downloadImage(imageName, completion: completion)
            }
        }
    }
}
