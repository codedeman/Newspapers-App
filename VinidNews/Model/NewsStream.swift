//
//  NewsStream.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift



struct News:Codable {
    
    public let thumnail:String!
      public let subtitle:String!
      public let pubdate:String
      public let title:String
      public let url:String
    
}

struct Multimedia:Codable {
    
    let url:String
}



struct SearchNews:Codable {
    
    let status:String
    let copyright:String
    let docs:[News]

}
