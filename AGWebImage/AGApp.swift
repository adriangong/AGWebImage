//
//  AGApp.swift
//  AGWebImage
//
//  Created by adrian gong on 16/3/11.
//  Copyright © 2016年 adrian gong. All rights reserved.
//

import UIKit

class AGApp: NSObject {
    
    var name: String?
    var icon: String?
    var download: String?
    
    class func app(Dict dict:NSDictionary) -> AnyObject {
        let app = AGApp()
        app.name = dict["name"] as? String
        app.icon = dict["icon"] as? String
        app.download = dict["download"] as? String
        return app
    }
}
