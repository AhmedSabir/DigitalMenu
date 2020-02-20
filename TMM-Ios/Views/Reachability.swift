//
//  Obrand
//  TMM-Ios
//
//  Created by Hightech on 29/08/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            print("data \(data )")
            print("response \(response )")
            print("error \(error )")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("httpResponse.statusCode \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }
            
        }).resume()
        
        
        return Status
    }
}

