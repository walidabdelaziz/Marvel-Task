//
//  NetworkManager.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import Alamofire
import SwiftyJSON
import CommonCrypto

enum Result<T> {
    case success(T)
    case failure(Error)
}
class NetworkManager {

    static let shared = NetworkManager()
    private init() {}
    
    func setRequestURL(url: String) -> String{
        let timestamp = APISettings.getCurrentUnixTimestamp()
        let privateKey = Consts.PRIVATE_KEY
        let publicKey = Consts.PUBLIC_KEY
        let hash = APISettings.generateMarvelAPIHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)
        return url + "&apikey=\(Consts.PUBLIC_KEY)&ts=\(timestamp)&hash=\(hash)"
    }
    func request<T: Decodable>(_ url: String,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               encoding: ParameterEncoding = JSONEncoding.prettyPrinted,
                               completionHandler: @escaping (Result<T>, Int?) -> Void) {
        
        if parameters != nil{
            print("params: \(parameters ?? Parameters())")
        }
        print("URL: \(setRequestURL(url: url))")
        Alamofire.request(setRequestURL(url: url), method: method, parameters: parameters, encoding: encoding).responseData { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let data):
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    print("response: \(decodedObject)")
                    completionHandler(Result.success(decodedObject), statusCode)
                } catch {
                    print(error)
                    completionHandler(Result.failure(error), statusCode)
                }
            case .failure(let error):
                print(error)
                completionHandler(Result.failure(error), statusCode)
            }
        }
    }
}
