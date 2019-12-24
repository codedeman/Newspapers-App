//
//  Constants.swift
//  VinidNews
//
//  Created by Apple on 11/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
typealias CompletionHandler = (_ Success: Bool) -> ()

let BASE_URL = "https://api.nytimes.com/svc/archive/v1/"

let BASE_URL2 = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q="


let TOKEN2 = "&api-key=pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR"

let TOKEN = ".json?api-key=pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR"

let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]



typealias NewsResponseCompletion = (NewsModel?) -> Void


