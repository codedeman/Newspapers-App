//
//  AppComponent.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

class AppComponent: Component<EmptyDependency>,RootDependency {
    
     init() {
        
        super.init(dependency: EmptyComponent())
        
    }
}
