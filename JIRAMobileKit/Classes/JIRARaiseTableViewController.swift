//
//  JIRARaiseTableViewController.swift
//  Pods
//
//  Created by Will Powell on 13/08/2017.
//
//

import UIKit
import MBProgressHUD

class JIRARaiseTableViewController: UITableViewController {

    var closeAction:Bool = false
    var project:JIRAProject?
    var issueType:JIRAIssueType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Feedback/Bug"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItems = [cancelButton]
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItems = [saveButton]
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if closeAction == true {
            self.dismiss(animated: true, completion: nil)
        }else{
            if UserDefaults.standard.string(forKey: "JIRA_USE") == nil || UserDefaults.standard.string(forKey: "JIRA_PWD") == nil {
                let loginVC = JIRALoginViewController(nibName: "JIRALoginViewController", bundle: JIRA.getBundle())
                loginVC.delegate = self
                self.present(loginVC, animated: true, completion: nil)
            }else{
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .indeterminate
                hud.label.text = "Loading ..."
                JIRA.shared.createMeta({ (error, project) in
                    self.project = project
                    self.issueType = project?.issueTypes?[0]
                    DispatchQueue.main.async {
                        hud.hide(animated: true)
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func save(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let fields = issueType?.fields {
            return fields.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()//tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let fields = issueType?.fields {
            let field = fields[indexPath.row]
            cell.textLabel?.text = field.name
            
        }
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JIRARaiseTableViewController:JIRALoginViewControllerDelegate{
    func loginDismissed(){
        self.closeAction = true
    }
    
    func loginOK() {
        
    }
}
