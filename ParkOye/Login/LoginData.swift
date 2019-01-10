//
//  LoginData.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 31/10/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    let status: Int?
    let message: String?
    let data: [UserData]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

struct UserData: Codable {
    let id: String?
    let name: String?
    let email: String?
    let mobile: String?
    let pin: String?
    let createdDate: String?
    let updatedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case pin = "pin"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }
}
