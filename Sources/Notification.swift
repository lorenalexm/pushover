//
//  Notification.swift
//  Pushover
//
//  Created by Kilian Költzsch on 01/02/2017.
//  Copyright © 2017 Kilian Koeltzsch. All rights reserved.
//

import Foundation

/// A notification to be sent to some devices
public struct Notification {

    /// Collection of custom parameters for this notification
    public var params = [String: String]()

    /// Create a new notification.
    ///
    /// - Parameters:
    ///   - message: message to be sent
    ///   - users: recipients (plural)
    public init(message: String, to users: [String]) {
        self.params["message"] = message
        self.params["user"] = users.joined(separator: ",")
    }

    /// Create a new notification.
    ///
    /// - Parameters:
    ///   - message: message to be sent
    ///   - user: recipient (singular)
    public init(message: String, to user: String) {
        self.init(message: message, to: [user])
    }

    /// Send a notification only to specified device names.
    ///
    /// - Parameter devices: devices
    public mutating func devices(_ devices: [String]) {
        self.params["device"] = devices.joined(separator: ",")
    }

    /// Set a custom title, otherwise the app name is used.
    ///
    /// - Parameter title: title
    public mutating func title(_ title: String) {
        self.params["title"] = title
    }

    /// Attach a URL. Note that URLs included in the message are already clickable in
    /// the Pushover applications.
    ///
    /// - Parameter url: url
    public mutating func url(_ url: String) {
        self.params["url"] = url
    }

    /// Set a custom title for an attached URL.
    ///
    /// - Parameter urlTitle: url title
    public mutating func urlTitle(_ urlTitle: String) {
        self.params["url_title"] = urlTitle
    }

    /// Set a time to be displayed as the sent time.
    ///
    /// - Parameter timestamp: timestamp
    public mutating func timestamp(_ timestamp: Date) {
        self.params["timestamp"] = "\(timestamp.timeIntervalSince1970)"
    }

    /// Set a custom priority. See `Priority` for more details.
    ///
    /// - Parameter priority: priortiy
    public mutating func priority(_ priority: Priority) {
        self.params["priority"] = "\(priority.rawValue)"
    }

    /// Set a custom sound for this notification. See `Sound` for more details.
    ///
    /// - Parameter sound: sound
    public mutating func sound(_ sound: Sound) {
        self.params["sound"] = sound.rawValue
    }

    /// Specify if the message contains HTML, which will be displayed correctly by
    /// the Pushover applications.
    ///
    /// - Parameter isHTML: is HTML?
    public mutating func isHTML(_ isHTML: Bool) {
        self.params["html"] = isHTML ? "1" : "0"
    }

    /// To be used with .emergency priority. How often to retry sending in seconds. Must be >=30.
    ///
    /// - Parameter seconds: seconds
    public mutating func retry(in seconds: UInt) {
        self.params["retry"] = "\(seconds)"
    }

    /// To be used with .emergency priority. When should retrying expire in seconds. Must be <=86400 (24 hours).
    ///
    /// - Parameter seconds: seconds
    public mutating func expires(in seconds: UInt) {
        self.params["expire"] = "\(seconds)"
    }

    var paramsString: String {
        return params
            .map { "\($0.key.urlEscaped)=\($0.value.urlEscaped)" }
            .joined(separator: "&")
    }
}

extension URLRequest {
    mutating func add(notification: Notification, withToken token: String) {
        let params = "token=\(token)&\(notification.paramsString)"
        self.httpBody = params.data(using: .utf8)
    }
}

extension String {
    var urlEscaped: String {
        // this is sooo verbose >.<
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
