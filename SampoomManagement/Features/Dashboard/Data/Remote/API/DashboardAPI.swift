import Foundation
import Alamofire

class DashboardAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getDashboard(agencyId: Int) async throws -> APIResponse<DashboardResponseDTO> {
        let endpoint = "agency/\(agencyId)/dashboard"
        return try await networkManager.request(
            endpoint: endpoint,
            method: .get,
            responseType: DashboardResponseDTO.self
        )
    }
    
    func getWeeklySummary(agencyId: Int) async throws -> APIResponse<WeeklySummaryResponseDTO> {
        let endpoint = "agency/\(agencyId)/weekly-summary"
        return try await networkManager.request(
            endpoint: endpoint,
            method: .get,
            responseType: WeeklySummaryResponseDTO.self
        )
    }
}
