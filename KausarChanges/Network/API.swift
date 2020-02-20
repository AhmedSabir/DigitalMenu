//
//  API.swift
//  TMM-Ios
//
//  Created by Fida Hussain Arjun on 1/27/20.
//  Copyright © 2020 One World United. All rights reserved.
//

import Foundation
import UIKit


class API: NSObject
{
    class func callDictionaryAPI(webserviceFor : webserviceType, paramaters : [String : Any],completion:@escaping (_ error:Error?,_ task:Any?)->Void)
    {
        var url = ""
        var webMethod : HTTPMethod!
        var encoding : ParameterEncoding = CustomGetEncoding()
         if(webserviceFor == .brands){
            url = GetBrandsURL
            webMethod = .get
            encoding = CustomGetEncoding()
        }
        if(webserviceFor == .themes){
            url = GetBrandsURL
            webMethod = .get
            encoding = CustomGetEncoding()
        }
        if(webserviceFor == .categories ){
            url = GetCategoriesURL
            webMethod = .get
            encoding = CustomGetEncoding()
        }
        if(webserviceFor == .feedback){
            url = GetFeedbackURL
            webMethod = .get
            encoding = CustomGetEncoding()
        }
        if(webserviceFor == .items){
            url = GetItemsURL
            webMethod = .get
            encoding = CustomGetEncoding()
        }
         request(url, method: webMethod, parameters: paramaters , encoding: encoding)
            .responseJSON { (response) in
                
                if (response.response == nil) {
                  
                    if let jsonErr = response.error {
                        UserDefaults.standard.set("\(1009)", forKey: "AppStatusCode")
                         UserDefaults.standard.synchronize()
                        completion(jsonErr, nil)
                    }
                    
                }
                else {
                    print("response.result===\(response.result)")
                    switch response.result
                    {
                    case .failure(let error):
                        print("completion:block===002==\(webserviceFor)")
                        
                        if (error._code==NSURLErrorTimedOut) {
                            
            
                            print("request times out")
                            completion(error, nil)
                            
                        } else {
                            
                            completion(error, nil)

                        }
                        
                        
                        
                    case .success(let value):
                        print("webResponse=1==\(webserviceFor)====\(value)")
                        
                        let data = response.data
                        do {
                            
                            if (webserviceFor == .brands) {
                                let commentsData = try JSONDecoder().decode(BrandThemeModel.self, from: data!)
                                completion(nil, commentsData)
                            }
 
//                            if (webserviceFor == .items) {
//                                let commentsData = try JSONDecoder().decode(itemsModel.self, from: data!)
//                                completion(nil, commentsData)
//                            }
//                            if (webserviceFor == .themes) {
//                                let commentsData = try JSONDecoder().decode(themesModel.self, from: data!)
//                                completion(nil, commentsData)
//                            }
                            
                        } catch let jsonErr {
                            print("jsonErr=1==\(jsonErr)")
                            UserDefaults.standard.set("\((response.response?.statusCode)!)", forKey: "AppStatusCode")
                            UserDefaults.standard.synchronize()
                            
                            completion(jsonErr, nil)
                        }
                    }
                    
                }
        }
        
    }
}
struct CustomGetEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
        return request
    }
}

struct CustomPostEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        let httpBody = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!
        request.httpBody = httpBody.replacingOccurrences(of: "%5B%5D=", with: "=").data(using: .utf8)
        return request
    }
    
    
}

private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}


/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}




