//
//  DlfData.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 01/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
struct Dlf: Codable {
    let status: Int?
    let message: String?
    let data: [Datum]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}
struct Datum: Codable {
    let id: String?
    let siteID: String?
    let availability: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case siteID = "site_id"
        case availability = "availability"
}
}
