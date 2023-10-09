//
//  UIDeviceAddress.swift
//  facilito
//
//  Created by iMac Mario on 31/05/23.
//

import Network
import Alamofire
import SystemConfiguration
import Foundation

extension UIDevice {
    
    //obtener IPv4
    func getLocalIPv4Address() -> String? {
        var address: String?

        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // Iterate over the network interfaces
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) { // IPv4 interface
                let name = String(cString: interface.ifa_name)
                if name == "en0" { // Use "en0" for WiFi, you may need to adjust for your specific interface name
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                   &hostname, socklen_t(hostname.count),
                                   nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                        address = String(cString: hostname)
                    }
                }
            }
        }

        freeifaddrs(ifaddr)
        return address
    }
    
    //obtener dispositivo
    func getDeviceInfo() -> String {
        let device = UIDevice.current
        let deviceName = device.name
        
        let deviceInfo = String("\(deviceName)")
        //let deviceInfo = String("Device Name: \(deviceName), Device Model: \(deviceModel)")
        return deviceInfo
    }
    
}
