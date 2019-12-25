//
//  ArticleComponent+DetailDependency.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs


extension ArticleComponent:SearchDependency{
    var searchViewController: SearchViewControllable {
        return articleView
    }
    


}
