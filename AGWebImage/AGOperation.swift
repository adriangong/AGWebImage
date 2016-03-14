//
//  AGOperation.swift
//  AGWebImage
//
//  Created by adrian gong on 16/3/11.
//  Copyright © 2016年 adrian gong. All rights reserved.
//

import UIKit

class AGOperation: NSOperation {
    
    var downBlock: ((UIImage)->Void)?
    var urlString: String?
    
    init(fromUrlString urlString:String, downBlock:((UIImage)->Void)) {
        super.init()
        self.downBlock = downBlock
        self.urlString = urlString
    }
    
    override func main() {
        autoreleasepool { () -> () in
            assert(self.downBlock != nil, "回调不能为空！" )
            assert(self.urlString != nil, "图片地址不能为空")
            
            print("当前线程是：\(NSThread.currentThread())")
            
            if self.cancelled{
                return
            }
            
            var image: UIImage?
            //下载图片
            NSThread.sleepForTimeInterval(1)
            print("正在下载图片...")
            
            if self.cancelled{
                return
            }
            
            let url = NSURL(string: self.urlString!)
            let data = NSData(contentsOfURL: url!)
            
            //保存到沙盒中
            if let imageData = data {
                //存放路径
                let filePath = AGSandboxTool.cachesPath(urlString: self.urlString!)
                imageData.writeToFile(filePath, atomically: true)
                image = UIImage(data: imageData)
            
            }else{
                print("请检查url地址是否正确")
            }
            //主线程回调
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.downBlock != nil {
                    self.downBlock!(image!)
                }
            })
        }
    }
}
