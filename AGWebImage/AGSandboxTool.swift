//
//  AGSandboxTool.swift
//  AGWebImage
//
//  Created by adrian gong on 16/3/11.
//  Copyright © 2016年 adrian gong. All rights reserved.
//

import UIKit

class AGSandboxTool: NSObject {

    class func cachesPath(urlString urlString:(String)) ->String {
        let cache = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, .UserDomainMask, true).last
        let nsCache: NSString = cache!
        let nsUrlString: NSString = urlString
        return nsCache.stringByAppendingPathComponent(nsUrlString.lastPathComponent)
    }
    
    //从文件路径获取图片
    class func imageFromSandbox(urlString urlString:(String)) -> UIImage? {
        let imagePath = self.cachesPath(urlString: urlString)
        return UIImage(contentsOfFile: imagePath)
    }
}
