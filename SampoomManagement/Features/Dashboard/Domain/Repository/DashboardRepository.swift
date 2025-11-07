import Foundation

protocol DashboardRepository {
    func getDashboard() async throws -> Dashboard
    func getWeeklySummary() async throws -> WeeklySummary
}
