//
//  ViewController.swift
//  HitList
//
//  Created by Vidya Ramamurthy on 11/01/16.
//  Copyright © 2016 BridgeLabz. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var names = [String]()
    var people = [NSManagedObject]()
    var addr = [NSManagedObject]()
    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name", message: "Add New Name", preferredStyle: .Alert)
//        let saveAction = UIAlertAction(title: "Save",
//            style: .Default,
//            handler: { (action:UIAlertAction) -> Void in
//                
//                let textField = alert.textFields!.first
//                self.names.append(textField!.text!)
//                self.tableView.reloadData()
//        })
//
//        let cancelAction = UIAlertAction(title: "Cancel",
//            style: .Default) { (action: UIAlertAction) -> Void in
//        }
// 
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
    
     
        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert,
//            animated: true,
//            completion: nil)
        func saveName(name: String, add :String) {
            //1
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate // For singllton instance
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let entity =  NSEntityDescription.entityForName("Person",
                inManagedObjectContext:managedContext)
            let person = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            
            //FOr ADDRESS
            
            let entity1 =  NSEntityDescription.entityForName("Address",
                inManagedObjectContext:managedContext)
            
            let address = NSManagedObject(entity: entity1!,
                insertIntoManagedObjectContext: managedContext)

            
           
            
            
            
            //3
            person.setValue(name, forKey: "name")
            address.setValue(add, forKey: "city")
            //4
            do {
                try managedContext.save()
                //5
                people.append(person)
                addr.append(address)
                } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                }
            
            }
       
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                let a = alert.textFields?.last
                //print("A " ,textField)
                saveName(textField!.text!, add: a!.text!)
                self.tableView.reloadData()
        })
        
        alert.addAction(saveAction)
        presentViewController(alert,
                    animated: true,
                    completion: nil)
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        let fetchRequest1 = NSFetchRequest(entityName: "Address")
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest1)
            addr = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return names.count
        return people.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        //cell?.textLabel?.text = names[indexPath.row]
        
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: cellIdentifier)
        }
        
        
        
        let person = people[indexPath.row]
        let test1 = person.valueForKey("name") as? String
        cell!.textLabel!.text =
            person.valueForKey("name") as? String
        print("Name", test1)
        let address = addr[indexPath.row]
        let test2 = address.valueForKey("city") as? String
        print("Addres", test2)
       cell?.detailTextLabel?.text = test2
       
                return cell!
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
         if editingStyle == .Delete
         {
            people.removeAtIndex(indexPath.row)
            tableView.reloadData()

        }
        
        
    }
}

