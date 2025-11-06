//
//  Vendor.swift
//  SampoomManagement
//
//  Created to mirror Android vendor domain model.
//

import Foundation

struct Vendor: Equatable, Identifiable {
    let id: Int
    let vendorCode: String
    let name: String
    let businessNumber: String
    let ceoName: String
    let address: String
    let status: String
}


