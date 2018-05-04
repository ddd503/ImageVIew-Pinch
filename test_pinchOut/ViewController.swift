//
//  ViewController.swift
//  test_pinchOut
//
//  Created by kawaharadai on 2018/02/14.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Private
    private func setup() {
        // ScrollViewの生成
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.delegate = self
        // 最大最小の拡大率を決定
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        self.view.addSubview(scrollView)
        
        // subViewの生成
        imageView = UIImageView()
        imageView.image = UIImage(named: "sunset")
        imageView.frame = scrollView.frame
        scrollView.addSubview(imageView)
        
        // ジェスチャーの作成
        let doubleTapGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(ViewController.doubleTap(gesture:)))
        // 指の数
        doubleTapGesture.numberOfTapsRequired = 2
        // imageViewのタッチ判定有効にする
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTapGesture)
    }
    
    // MARK: - Action
    /// ダブルタップで拡大、標準サイズへの戻りを繰り返す
    @objc func doubleTap(gesture: UITapGestureRecognizer) -> Void {
        
        if ( self.scrollView.zoomScale < self.scrollView.maximumZoomScale ) {
            let newScale:CGFloat = self.scrollView.zoomScale * 3
            let zoomRect:CGRect = self.zoomRectForScale(scale: newScale,
                                                        center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // 拡大率を戻す
            self.scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    /// 拡大領域の計算
    private func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width = self.scrollView.frame.size.width / scale
        
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }
}

// MARK: - ScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    /// ピンチインの許可
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
