import Foundation

extension DashboardResponseDTO {
    func toModel() -> Dashboard {
        return Dashboard(
            totalParts: totalParts,
            outOfStockParts: outOfStockParts,
            lowStockParts: lowStockParts,
            totalQuantity: totalQuantity
        )
    }
}

extension WeeklySummaryResponseDTO {
    func toModel() -> WeeklySummary {
        return WeeklySummary(
            inStockParts: inStockParts,
            outStockParts: outStockParts,
            weekPeriod: weekPeriod
        )
    }
}
