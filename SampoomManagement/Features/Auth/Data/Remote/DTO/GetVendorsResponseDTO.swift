//
//  GetVendorsResponseDTO.swift
//  SampoomManagement
//
//  Created to mirror Android vendor list API.
//

import Foundation

struct GetVendorsResponseDTO: Codable {
    let id: Int
    let vendorCode: String
    let name: String
    let businessNumber: String
    let ceoName: String
    let address: String
    let status: String
}


