import Foundation

struct GetDashboardUseCase {
    private let repository: DashboardRepository
    
    init(repository: DashboardRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> Dashboard {
        return try await repository.getDashboard()
    }
}
