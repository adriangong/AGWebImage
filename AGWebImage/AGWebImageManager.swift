//
//  AGWebImageManager.swift
//  AGWebImage
//
//  Created by adrian gong on 16/3/11.
//  Copyright © 2016年 adrian gong. All rights reserved.
//

import UIKit

class AGWebImageManager: NSObject {

    lazy var images = NSMutableDictionary()
    lazy var operations = NSMutableDictionary()
    
    //创建队列，在多线程中（非主）中 并行
    lazy var queue: NSOperationQueue = {
        let q = NSOperationQueue()
        q.maxConcurrentOperationCount = 6
        return q
    }()
    
    static let sharedManager = AGWebImageManager()

    //下载图片接口+回调
    func downloadWebImage(urlString urlString: String, complition:((UIImage) -> Void)) {
        //如果操作存在
        if self.operations[urlString] != nil {
            print("操作已经存在")
            return
        }

        //创建操作，并赋值
        //定义一个类AGOperation 的实例 op
        let op = AGOperation(fromUrlString: urlString) { (image) -> Void in
            //调用分类的回调，显示图片
            complition(image)
            //缓存
            self.images.setObject(image, forKey: urlString)
            self.operations.removeObjectForKey(urlString)
        }
        
        self.operations.setObject(op, forKey: urlString)
        self.queue.addOperation(op)
    }
    
    //取消操作的接口
    func cancelOperation(urlString urlString: String) {
        if let op = self.operations[urlString] {
            op.cancel()
        }
        
        self.operations.removeObjectForKey(urlString)
    }
    
    //添加内存警告通知
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveMemWarning", name:UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    func receiveMemWarning() {
        self.queue.cancelAllOperations()
        self.images.removeAllObjects()
        self.operations.removeAllObjects()
    }
    
}
