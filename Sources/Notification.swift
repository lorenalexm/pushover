//
//  Notification.swift
//  Pushover
//
//  Created by Kilian Költzsch on 01/02/2017.
//  Copyright © 2017 Kilian Koeltzsch. All rights reserved.
//

import Foundation

public struct Notification {
    let message: String
    let user: String
    let devices: [String]? = nil
    let title: String? = nil
    let url: String? = nil
    let urlTitle: String? = nil
    let timestamp: Date? = nil
    let priority: Priority = .normal
    let sound: Sound? = nil

    public init(message: String, to user: String) {
        self.message = message
        self.user = user
    }

    var asParams: [String: String] {
        var params = [String: String]()

        params["message"] = message
        params["user"] = user
        if let devices = devices { params["device"] = devices.joined(separator: ",") }
        if let title = title { params["title"] = title }
        if let url = url { params["url"] = url }
        if let urlTitle = urlTitle { params["url_title"] = urlTitle }
        if let timestamp = timestamp { params["timestamp"] = "\(timestamp.timeIntervalSince1970)" }
        params["priority"] = "\(priority.rawValue)"
        if let sound = sound { params["sound"] = sound.rawValue }

        return params
    }

    var paramsString: String {
        return asParams
            .map { "\($0.key.urlEscaped)=\($0.value.urlEscaped)" }
            .joined(separator: "&")
    }
}

public enum Priority: Int {
    case noAlert = -2
    case quiet
    case normal
    case high
    case requireConfirmation
}

extension URLRequest {
    mutating func add(notification: Notification) {
        self.httpBody = notification.paramsString.data(using: .utf8)
    }
}

extension String {
    var urlEscaped: String {
        // this is sooo verbose >.<
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
