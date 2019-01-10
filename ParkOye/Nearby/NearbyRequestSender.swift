//
//  NearbyRequestSender.swift
//  Travolution
//
//  Created by Navin on 3/5/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import Foundation
import Moya
import Alamofire

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}
let configurationNearby = { () -> URLSessionConfiguration in
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.timeoutIntervalForRequest = 200 // as seconds, you can set your request timeout
    config.timeoutIntervalForResource = 400 // as seconds, you can set your resource timeout
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()

let managerNearby = Manager(
    configuration: configurationNearby,
    serverTrustPolicyManager: NearbyCustomServerTrustPoliceManager()
)

let TVAPIProviderNearby = MoyaProvider<Nearby>(manager: managerNearby,plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum Nearby {
    case NEARBY([String: Any])
}

extension Nearby: TargetType {
    public var baseURL: URL{
        return URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")!
    }
    public var task: Task {
        switch self {
        case .NEARBY(let params):
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        }
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    public var method: Moya.Method {
        switch self {
        case .NEARBY:
            return .get
        }
    }
    public var path: String {
        return ""
    }
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
}
public func urlNearby(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers


class NearbyCustomServerTrustPoliceManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return 
.disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}
