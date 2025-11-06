import Foundation

class DashboardRepositoryImpl: DashboardRepository {
    private let api: DashboardAPI
    private let authPreferences: AuthPreferences
    
    init(api: DashboardAPI, authPreferences: AuthPreferences) {
        self.api = api
        self.authPreferences = authPreferences
    }
    
    func getDashboard() async throws -> Dashboard {
        guard let user = try authPreferences.getStoredUser() else { throw NetworkError.unauthorized }
        let response = try await api.getDashboard(agencyId: user.agencyId)
        if !response.success { throw NetworkError.serverError(response.status, message: response.message) }
        guard let data = response.data else { throw NetworkError.noData }
        return data.toModel()
    }
    
    func getWeeklySummary() async throws -> WeeklySummary {
        guard let user = try authPreferences.getStoredUser() else { throw NetworkError.unauthorized }
        let response = try await api.getWeeklySummary(agencyId: user.agencyId)
        if !response.success { throw NetworkError.serverError(response.status, message: response.message) }
        guard let data = response.data else { throw NetworkError.noData }
        return data.toModel()
    }
}
