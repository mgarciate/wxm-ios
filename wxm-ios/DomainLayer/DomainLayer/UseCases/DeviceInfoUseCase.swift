//
//  DeviceInfoUseCase.swift
//  DomainLayer
//
//  Created by Pantelis Giazitsis on 8/3/23.
//

import Foundation
import Alamofire
import Combine

public struct DeviceInfoUseCase {

    private let repository: DeviceInfoRepository
    public init(repository: DeviceInfoRepository) {
        self.repository = repository
    }

    public func getDeviceInfo(deviceId: String) throws -> AnyPublisher<DataResponse<NetworkDevicesInfoResponse, NetworkErrorResponse>, Never> {
        try repository.getDeviceInfo(deviceId: deviceId)
    }

    public func setFriendlyName(deviceId: String, name: String) throws -> AnyPublisher<DataResponse<EmptyEntity, NetworkErrorResponse>, Never> {
        try repository.setFriendlyName(deviceId: deviceId, name: name)
    }

    public func deleteFriendlyName(deviceId: String) throws -> AnyPublisher<DataResponse<EmptyEntity, NetworkErrorResponse>, Never> {
        try repository.deleteFriendlyName(deviceId: deviceId)
    }

    public func disclaimDevice(serialNumber: String) throws -> AnyPublisher<DataResponse<EmptyEntity, NetworkErrorResponse>, Never> {
        try repository.disclaimDevice(serialNumber: serialNumber)
    }

    public func rebootStation(device: DeviceDetails) -> AnyPublisher<RebootStationState, Never> {
        repository.rebootStation(device: device)
    }

    public func changeFrequency(device: DeviceDetails, frequency: Frequency) -> AnyPublisher<ChangeFrequencyState, Never> {
        repository.changeFrequency(device: device, frequency: frequency)
    }
}
