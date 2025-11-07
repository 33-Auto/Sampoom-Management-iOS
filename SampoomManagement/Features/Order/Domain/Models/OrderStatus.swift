//
//  OrderStatus.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

enum OrderStatus: String, CaseIterable, Codable {
    case pending = "PENDING"
    case confirmed = "CONFIRMED"
    case shipping = "SHIPPING"
    case delayed = "DELAYED"
    case producing = "PRODUCING"
    case arrived = "ARRIVED"
    case completed = "COMPLETED"
    case canceled = "CANCELED"
    
    static func from(_ rawValue: String?) -> OrderStatus {
        guard let rawValue = rawValue?.uppercased() else { return .pending }
        
        switch rawValue {
        case "PENDING":
            return .pending
        case "CONFIRMED":
            return .confirmed
        case "SHIPPING":
            return .shipping
        case "DELAYED":
            return .delayed
        case "PRODUCING":
            return .producing
        case "ARRIVED":
            return .arrived
        case "COMPLETED":
            return .completed
        case "CANCELED":
            return .canceled
        default:
            return .pending
        }
    }
}
