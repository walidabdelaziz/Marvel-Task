//
//  ReachabilityManager.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import Reachability

enum NetworkStatus {
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

class ReachabilityManager {

    static let shared = ReachabilityManager()
    
    private var reachability: Reachability!

    private init() {
        reachability = try? Reachability()
        startMonitoringReachability()
    }
    deinit {
        stopMonitoringReachability()
    }

    // Function to start monitoring network reachability
    private func startMonitoringReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }

    // Function to stop monitoring network reachability
    private func stopMonitoringReachability() {
        reachability.stopNotifier()
    }

    // Function to check current network status
    func currentNetworkStatus() -> NetworkStatus {
        if reachability.connection == .wifi {
            return .reachableViaWiFi
        } else if reachability.connection == .cellular {
            return .reachableViaWWAN
        } else {
            return .notReachable
        }
    }
}
