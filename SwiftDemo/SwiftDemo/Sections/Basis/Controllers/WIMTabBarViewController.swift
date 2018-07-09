//
//  WIMTabBarViewController.swift
//  SwiftDemo
//
//  Created by LinJia on 2018/7/9.
//  Copyright © 2018年 chongxiaoge. All rights reserved.
//

import UIKit

class WIMTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Test
        let testVC = WIMTestViewController(nibName: nil, bundle: nil)
        let testNav = WIMNavigationViewController(rootViewController: testVC)
        let testTabBarItem = UITabBarItem(title: NSLocalizedString("Test", comment: ""), image: UIImage(named: "WarmIM_tabbar_home"), selectedImage: UIImage(named: "WarmIM_tabbar_home_selected"))
        testNav.tabBarItem = testTabBarItem
        
        // About
        let aboutVC = WIMAboutViewController(nibName: nil, bundle: nil)
        let aboutNav = WIMNavigationViewController(rootViewController: aboutVC)
        let aboutTabBarItem = UITabBarItem(title: NSLocalizedString("About", comment: ""), image: UIImage(named: "WarmIM_tabbar_about"), selectedImage: UIImage(named: "WarmIM_tabbar_about_selected"))
        aboutNav.tabBarItem = aboutTabBarItem
        
        self.viewControllers = [testNav, aboutNav]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
