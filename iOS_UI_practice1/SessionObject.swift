//
//  SessionObject.swift
//  iOS_UI_practice1
//
//  Created by Alex on 13/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

// Класс веб-сессии
class Session {
    public static let shared = Session()
    
    private init() {}
    
    var token: String = ""
    var userId: String = ""
}