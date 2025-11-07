import Foundation

struct WeeklySummaryResponseDTO: Codable {
    let inStockParts: Int
    let outStockParts: Int
    let weekPeriod: String
}
