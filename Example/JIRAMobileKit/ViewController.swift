//
//  ViewController.swift
//  JIRAMobileKit
//
//  Created by willpowell8 on 08/13/2017.
//  Copyright (c) 2017 willpowell8. All rights reserved.
//

import UIKit
import JIRAMobileKit

class ViewController: UIViewController {
    var tapGestureRecognizer : UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        JIRA.shared.setup(host: "https://holtrenfrew.atlassian.net", project: "OMNMOB")
        //JIRA.shared.setup(host: "https://tracking.keytree.net", project: "KC", defaultIssueType: "Keytree raised defect")
        //JIRA.shared.setup(host: "[[JIRA_URL]]", project: "[[PROJECT_KEY]]", defaultIssueType: "[[DEFAULT_ISSUE_TYPE]]")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func raiseBug(_ sender:Any?){
        JIRA.shared.raise()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.navBarTapped(_:)))
        self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.removeGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func navBarTapped(_ tapRecognizer: UITapGestureRecognizer){
        if tapRecognizer.state == .recognized {
            let point = tapRecognizer.location(in: self.navigationController?.navigationBar)
            if point.x > 100 && point.x < (self.navigationController?.navigationBar.frame.width)!-100 {
                JIRA.shared.raise()
            }
        }
        
    }
}

