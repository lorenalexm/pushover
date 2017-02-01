//
//  Error.swift
//  Pushover
//
//  Created by Kilian Költzsch on 01/02/2017.
//  Copyright © 2017 Kilian Koeltzsch. All rights reserved.
//

import Foundation

enum Error: Swift.Error {
    case InvalidRequest(message: String)
    case ServerError
}
