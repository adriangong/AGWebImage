//
//  UIImageView+WebImage.swift
//  AGWebImage
//
//  Created by adrian gong on 16/3/11.
//  Copyright © 2016年 adrian gong. All rights reserved.
//

import Foundation
import UIKit

private var urlStringKey = "urlStringKey"
extension UIImageView {
    
    var urlString: String? {

        set{
            //这里一定要是newValue,相当于set传过来的值
            objc_setAssociatedObject(self, &urlStringKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            return objc_getAssociatedObject(self, &urlStringKey) as? String
        }
    }
    
    func setWebImage(urlString urlString: String, placeholderImage:UIImage) {
        //用管理类下载图片，实例化管理类对象
        let manager = AGWebImageManager.sharedManager
        
        //1.内存缓存
        if let image = manager.images.objectForKey(urlString) {
            print("从内存缓存中取图片")
            self.image = (image as! UIImage)
            return
        }
        
        //2.沙盒
        if let image = AGSandboxTool.imageFromSandbox(urlString: urlString) {
            print("从沙盒中取图片")
            self.image = image
            manager.images.setObject(image, forKey: urlString)
            return
        }
        
        //3.下载，需要判断下载操作是否匹配
        self.image = placeholderImage
        
        if self.urlString != nil && self.urlString != urlString {
            print("取消了原来的下载")
            manager.cancelOperation(urlString: self.urlString!)
            self.downloadImage(urlString)
            return
        }
        
        if self.urlString == nil {
            self.downloadImage(urlString)
            return
        }

    }
    
    //下载图片的方法
    func downloadImage(urlString: String) {
        //
        AGWebImageManager.sharedManager.downloadWebImage(urlString: urlString) { (image) -> Void in
            self.image = image
            print("图片下载完毕")
        }
        
        
        //一开始下载就给imageView绑定一个urlString，用于滚动之后判断是不是与当前传入的urlString相匹配，如果不匹配，就取消以前的下载操作，开始新的下载操作
        self.urlString = urlString
    }
    


}