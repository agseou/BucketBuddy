//
//  NetworkStatusManager.swift
//  BucketBuddy
//
//  Created by eunseou on 4/17/24.
//

import Foundation
import Network

final class NetworkStatusManager {
    
    static let shared = NetworkStatusManager()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi // Wi-Fi 연결
        case cellular // 셀룰러 연결
        case ethernet // 유선 이더넷 연결
        case unknown // 알수없음
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    // 네트워크 모니터링 시작
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied // 네트워크 연결 상태 업데이트
            self?.getConnectoinType(path) // 연결 유형 업데이트
            
            if self?.isConnected == true {
                print("네트워크 연결 성공!")
            } else {
                print("🔥네트워크 연결 오류🔥")
            }
        }
    }
    
    // 네트워크 모니터링 중지
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    // 네트워크 경로를 기반으로 연결 유형 결정
    private func getConnectoinType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
