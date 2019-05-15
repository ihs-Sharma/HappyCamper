//
//  TTMultipleTabVC.swift
//  TrufTrade
//
//  Created by Hitesh on 18/01/18.
//  Copyright © 2018 Wegile_Hitesh. All rights reserved.
//

import UIKit

class TTMultipleTabVC: TabPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HotNewsVC")
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewUpdatedNewsVC")
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeaturedNewsVC")
        
        tabItems = [(vc1, "Hot"), (vc2, "New"), (vc3, "Featured")]
        isInfinity = false
        option.currentColor = UIColor.white
        option.tabBackgroundColor = UIColor(red:0/255, green:161/255, blue:231/255, alpha:1.0)
        option.defaultColor = .white

        option.tabHeight = 40
        option.tabMargin = 30.0
        option.fontSize = 17
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
