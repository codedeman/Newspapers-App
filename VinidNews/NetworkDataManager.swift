//
//  NetworkDataManager.swift
//  VinidNews
//
//  Created by Apple on 11/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Alamofire

public enum NetworkConnectionStatus: String {
    case online
    case offline
}

public protocol NetworkConnectionStatusListener: class {
    func networkStatusDidChange(status: NetworkConnectionStatus)
}

class ConnectivityMananger: NSObject {
    private override init() {
           super.init()
           configureReachability()
    }
    
    private static let _shared = ConnectivityMananger()
    
    class func shared() -> ConnectivityMananger {
        
        return _shared
    }

    private let networkReachability: NetworkReachabilityManager? = NetworkReachabilityManager()
     
     var isNetworkAvailable: Bool {
         return networkReachability?.isReachable ?? false
     }
    var listeners = [NetworkConnectionStatusListener]()

    
    private func configureReachability() {
        networkReachability?.startListening(onQueue: DispatchQueue.global(), onUpdatePerforming: { (status) in
           
            switch status{
            case .unknown:
                self.notifyAllListenersWith(status: .offline)
                break
            
            
            case .notReachable:
                self.notifyAllListenersWith(status: .offline)
            case .reachable(_):
                print("what the hell")
            }
            
           
        })
            

       }
    
    private func notifyAllListenersWith(status: NetworkConnectionStatus) {
        print("Network Connection status is \(status.rawValue)")
        for listener in listeners {
            listener.networkStatusDidChange(status: status )
        }
    }
    
    func addListener(listener: NetworkConnectionStatusListener) {
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkConnectionStatusListener) {
        listeners = listeners.filter { $0 !== listener}
    }
//
    
    func stopListening() {
        networkReachability?.stopListening()
    }
    
    
    
}

