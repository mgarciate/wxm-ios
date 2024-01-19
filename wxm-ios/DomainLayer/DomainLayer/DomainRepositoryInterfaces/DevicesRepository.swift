//
//  DevicesRepository.swift
//  DomainLayer
//
//  Created by Hristos Condrea on 17/5/22.
//

import Alamofire
import Combine

public protocol DevicesRepository {
    func devices() throws -> AnyPublisher<DataResponse<[NetworkDevicesResponse], NetworkErrorResponse>, Never>
    func deviceById(deviceId: String) throws -> AnyPublisher<DataResponse<NetworkDevicesResponse, NetworkErrorResponse>, Never>
    func deviceTokenTransactions(deviceId: String, page: Int, pageSize: Int?, timezone: String, fromDate: String, toDate: String?) throws -> AnyPublisher<DataResponse<NetworkDeviceIDTokensTransactionsResponse, NetworkErrorResponse>, Never>
    func deviceTokens(deviceId: String) async throws -> Result<NetworkDeviceIDTokensTransactionsResponse, NetworkErrorResponse>
	func deviceRewards(deviceId: String) throws -> AnyPublisher<DataResponse<NetworkDeviceTokensResponse, NetworkErrorResponse>, Never>
}
