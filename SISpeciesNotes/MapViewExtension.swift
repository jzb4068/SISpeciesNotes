//
//  MapViewExtension.swift
//  WENT-iOS
//
//  Created by Semper Idem on 15-4-6.
//  Copyright (c) 2015年 星夜暮晨. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    
    // MARK: - ZoomLevel 相关方法

    /// MKMapView 的缩放级别
    var zoomLevel: UInt {
        get {
            // 缩放比例
            let zoomScale = log2(self.visibleMapRect.size.width / Double(self.bounds.size.width))
            // 实际缩放级别
            let zoomLevel = 20 - zoomScale
            return UInt(ceil(zoomLevel))
        }
        set (newZoomLevel){
            self.setCenterCoordinate(self.userLocation.coordinate, zoomLevel: newZoomLevel, animated: true)
        }
    }
    
    /// 以缩放级别来设置当前地图中心点
    func setCenterCoordinate(currentCenter: CLLocationCoordinate2D, zoomLevel level: UInt, animated: Bool) {
        
        // 获取当前地图中心点坐标（使用坐标系）
        let currentCenterPoint = MKMapPointForCoordinate(currentCenter)
        // 获取缩放比例
        let zoomScale = exp2(Double(level))
        // 计算当前屏幕的大小和原点
        let mapSize = MKMapSizeMake(Double(self.bounds.size.width) * zoomScale, Double(self.bounds.size.height) * zoomScale)
        let mapOrigin = MKMapPointMake(currentCenterPoint.x - mapSize.width / 2, currentCenterPoint.y - mapSize.height / 2)
        
         self.visibleMapRect = self.mapRectThatFits(MKMapRect(origin: mapOrigin, size: mapSize))
    }
    
    /// 缩放级别放大一级
    func zoomIn() -> Bool {
        var zoomLevel = self.zoomLevel
        let center = self.userLocation.coordinate
        zoomLevel += 1
        if zoomLevel > 19 {
            return false
        }else {
            self.setCenterCoordinate(center, zoomLevel: zoomLevel, animated: true)
            return true
        }
    }
    
    /// 缩放级别缩小一级
    func zoomOut() -> Bool {
        var zoomLevel = self.zoomLevel
        let center = self.userLocation.coordinate
        zoomLevel -= 1
        if zoomLevel < 0 {
            return false
        }else {
            self.setCenterCoordinate(center, zoomLevel: zoomLevel, animated: true)
            return true
        }
    }
    
    // MARK: - MapView 视图图层显示相关方法
    
    /// 删除系统默认的指南针视图，注意指南针视图一经删除便无法恢复~这个方法返回一个布尔值说明删除是否成功
    func deleteCompass() -> Bool{
        var mapSubviews = self.subviews
        for view in mapSubviews {
            // 移除指南针
            if view.isKindOfClass(NSClassFromString("MKCompassView")) {
                view.removeFromSuperview()
                return true
            }
        }
        return false
    }

    /// 删除地图左下角的跳转标签，注意左下角的跳转标签一经删除便无法恢复~这个方法返回一个布尔值说明删除是否成功
    func deleteAttributionLabel() -> Bool{
        var mapSubviews = self.subviews
        for view in mapSubviews {
            // 移除标签
            if view.isKindOfClass(NSClassFromString("MKAttributionLabel")) {
                view.removeFromSuperview()
                return true
            }
        }
        return false
    }
    
    /// 删除地图右下角的地图提供者信息，注意右下角的地图提供者信息一经删除便无法恢复~这个方法返回一个布尔值说明删除是否成功
    func deleteMapInfo() -> Bool {
        var mapSubviews = self.subviews
        for view in mapSubviews {
            // 移除标签
            if view.isKindOfClass(UIImageView) {
                view.removeFromSuperview()
                return true
            }
        }
        return false
    }
}