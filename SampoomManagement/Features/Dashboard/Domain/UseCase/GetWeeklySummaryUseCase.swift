import Foundation

struct GetWeeklySummaryUseCase {
    private let repository: DashboardRepository
    
    init(repository: DashboardRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> WeeklySummary {
        return try await repository.getWeeklySummary()
    }
}
