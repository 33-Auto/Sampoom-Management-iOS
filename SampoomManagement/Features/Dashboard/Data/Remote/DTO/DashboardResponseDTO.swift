import Foundation

struct DashboardResponseDTO: Codable {
    let totalParts: Int
    let outOfStockParts: Int
    let lowStockParts: Int
    let totalQuantity: Int
}
