//
//  CurrencyFormatter.swift
//  SampoomManagement
//
//  Simple KRW formatter: 12,345원
//

import Foundation

func formatWon(_ value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "ko_KR")
    let number = NSNumber(value: value)
    return (formatter.string(from: number) ?? "\(value)") + "원"
}


