//
//  WIMBottomButtonView.swift
//  SwiftDemo
//
//  Created by LinJia on 2018/7/10.
//  Copyright © 2018年 chongxiaoge. All rights reserved.
//

import UIKit

class WIMBottomButtonView: UIView {

    var button: UIButton!
    var topLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.button = UIButton(type: .custom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
