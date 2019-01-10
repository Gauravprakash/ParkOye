//
//  APIService.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 15/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    }
    catch{
        return data // fallback to original data if it can't be serialized.
    }
}

let configuration = { () -> URLSessionConfiguration in
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.timeoutIntervalForRequest = 200 // as seconds, you can set your request timeout
    config.timeoutIntervalForResource = 400 // as seconds, you can set your resource timeout
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()

let manager = Manager(
    configuration: configuration,
    serverTrustPolicyManager: CustomServerTrustPoliceManager()
)

let ParkingAPIProvider = MoyaProvider<Parking>(manager: manager,plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              )

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum Parking {
    case REGISTER([String: Any])
    case LOGIN([String:Any])
    case FORGOTPASSWORD([String:Any])
    case CONTACTADMIN([String:Any])
    case DLFDATA
    case WEATHER([String:Any])
    
}

extension Parking: TargetType {
    public var task: Task {
        switch self {
        case .REGISTER(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .LOGIN(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .FORGOTPASSWORD(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .CONTACTADMIN(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .DLFDATA:
            return .requestPlain
        case .WEATHER(let params):
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        }
        
        
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    public var baseURL: URL {
        switch self {
        case .WEATHER:
                return URL(string:"http://api.openweathermap.org/data/2.5/weather/2.5/weather?appid=e821399338e43f53a672ba4e11298e4f&lat=19.0176147&lon=72.8561644")!
        default:
            return URL(string: parkingApi)! }
        }
        
    
    public var path: String {
        switch self {
        case .REGISTER:
            return "signup.php"
        case .LOGIN:
            return "login.php"
        case .FORGOTPASSWORD:
            return "forgot.php"
        case .CONTACTADMIN:
            return "apicontact.php"
        case .DLFDATA:
            return "dlfdata.php"
        case .WEATHER:
            return "2.5/weather"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .DLFDATA, .WEATHER:
            return .get
        default:
            return .post
        }

    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .WEATHER:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}
