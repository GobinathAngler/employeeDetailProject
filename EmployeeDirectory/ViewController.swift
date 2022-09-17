//
//  ViewController.swift
//  EmployeeDirectory
//
//  Created by Gobinath on 17/09/22.
//

import UIKit

import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var viewEmployeeListbtn: UIButton!
    var storedDataArray = [NSManagedObject]()

    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    
    //MARK: VC Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEmployeeListbtn.isEnabled = false
        viewEmployeeListbtn.alpha = 0.5
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       getNetworkResponseFromAPI()
    }
    
    //MARK: Helper Methods
    func getNetworkResponseFromAPI() {
        
        loadSpinner?.startAnimating()
        
        NetworkHandler.callWebService(urlString: "http://www.mocky.io/v2/5d565297300000680030a986") { success, ResponseDataValue  in
            if success {
                self.resetAllRecords(in: "EmployeeDB")
                do {
                    if let json = try JSONSerialization.jsonObject(with: ResponseDataValue!, options: []) as? [[String: Any]] {
                        print("The Response = \(json)")
                        
                        if json.isEmpty {
                            return
                        }else {
                            for employeeObj in json {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context = appDelegate.persistentContainer.viewContext
                                let employeeContext = EmployeeDB(context: context)
                                
                                if let username = employeeObj["username"] as? String  {
                                    employeeContext.username  = username
                                }
                                if let name = employeeObj["name"] as? String  {
                                    employeeContext.name = name
                                }
                                
                                if let profileImage = employeeObj["profile_image"] as? String  {
                                    employeeContext.profile_image = profileImage
                                }
                                if let email = employeeObj["email"] as? String  {
                                    employeeContext.email = email
                                    
                                }
                                if let company = employeeObj["company"] as? [String : Any]  {
                                    
                                    if let companyName = company["name"] as? String {
                                        
                                        employeeContext.cname = companyName
                                        
                                    }
                                }
                                
                                if let address = employeeObj["address"] as? [String : Any]  {
                                    
                                    if let street = address["street"] as? String {
                                        
                                        employeeContext.street = street
                                    }
                                    if let city = address["city"] as? String {
                                        
                                        employeeContext.city = city
                                        
                                    }
                                    if let zipcode = address["zipcode"] as? String {
                                        employeeContext.zipcode = zipcode
                                    }
                                    
                                    if let website = address["website"] as? String {
                                        employeeContext.website = website
                                    }
                                }
                                do {
                                    try context.save()
                                    DispatchQueue.main.async {
                                        self.loadSpinner?.stopAnimating()
                                        self.viewEmployeeListbtn?.isEnabled = true
                                        self.viewEmployeeListbtn?.alpha = 1.0
                                        self.loadSpinner?.isHidden = true
                                    }
                                }
                                catch {
                                    // Handle Error
                                }
                            }
                            
                        }
                        self.fetchData()
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }else {
                print("Something Went Wrong")
            }
        }
    }
    //MARK: Core Date Handler
    
    func fetchData() {
        storedDataArray.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeDB")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = true
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                storedDataArray.append(data)
            }
            print("The count = \(storedDataArray.count)")
        } catch {
            print("Failed")
        }
    }
    
    func resetAllRecords(in entity : String)
        {

            let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
    
    //MARK: Button Actions
    
    @IBAction func ViewEmployeeAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let employeeListVC = storyBoard.instantiateViewController(withIdentifier: "EVC") as! EmployeeListVC
        employeeListVC.employeeDetailArray = storedDataArray
        self.present(employeeListVC, animated:true, completion:nil)
    }
    
}

