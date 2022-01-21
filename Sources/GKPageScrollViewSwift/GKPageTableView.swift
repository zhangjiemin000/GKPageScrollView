//
//  GKPageTableView.swift
//  GKPageScrollViewSwift
//
//  Created by QuintGao on 2019/2/20.
//  Copyright © 2019 QuintGao. All rights reserved.
//

import UIKit

@objc public protocol GKPageTableViewGestureDelegate: NSObjectProtocol {
    
    @objc optional func pageTableView(_ tableView: GKPageTableView, gestureRecognizerShouldBegin gestureRecognizer: UIGestureRecognizer) -> Bool
    
    @objc optional func pageTableView(_ tableView: GKPageTableView, gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

open class GKPageTableView: UITableView, UIGestureRecognizerDelegate {
    open weak var gestureDelegate: GKPageTableViewGestureDelegate?
    
    open var horizontalScrollViewList: [UIScrollView]?

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let result = self.gestureDelegate?.pageTableView?(self, gestureRecognizerShouldBegin: gestureRecognizer) {
            return result
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let result = self.gestureDelegate?.pageTableView?(self, gestureRecognizer: gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) {
            return result
        }
        //如果外部没有拦截手势，则这里使用他默认的行为，根据横向滚动的ScrollView
        if let list = self.horizontalScrollViewList {
            var exist = false
            for scrollView in list {
                if gestureRecognizer.view?.isEqual(scrollView) == true {
                    exist = true
                }
                if otherGestureRecognizer.view?.isEqual(scrollView) == true {
                    exist = true
                }
                //如果有任何一个手势作用于横向滚动的View中，则返回false
            }
            if exist { return false }
        }
        //否则判断是否为ScrollView，如果两个都是UIScrollView，则返回TRUE
        return gestureRecognizer.view?.isKind(of: UIScrollView.classForCoder()) ?? false && otherGestureRecognizer.view?.isKind(of: UIScrollView.classForCoder()) ?? false
    }
}
