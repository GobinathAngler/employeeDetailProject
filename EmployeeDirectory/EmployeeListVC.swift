//
//  EmployeeListVC.swift
//  EmployeeDirectory
//
//  Created by Gobinath on 17/09/22.
//

import Foundation
import CoreData
import UIKit

class EmployeeListVC : ViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    var employeeDetailArray = [NSManagedObject]()
    @IBOutlet weak var employeeListTbl: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var filteredArray = [NSManagedObject]()
    
    override func viewDidLoad() {
         
        filteredArray = employeeDetailArray
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }
    
    
    //MARK: Table View Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EDTVC", for: indexPath) as! EmployeeListCell
        let employeeAsset =  filteredArray[indexPath.row]
        cell.employeeName.text = employeeAsset.value(forKey: "name") as? String ?? ""
        cell.companyName.text = employeeAsset.value(forKey: "cname") as? String ?? ""
        
        cell.profileImage?.imageFromServerURL(urlString: employeeAsset.value(forKey: "profile_image") as? String ?? "", PlaceHolderImage: UIImage.init(named: "placeholder")!)
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let employeeDetailVCObj = storyBoard.instantiateViewController(withIdentifier: "EDC") as! employeeDetailVC
        employeeDetailVCObj.selectedEmployeeObject = filteredArray[indexPath.row]
        self.present(employeeDetailVCObj, animated:true, completion:nil)
    }
    
    //MARK: Search Bar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeDB")
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = true
        do {
            let result = try context.fetch(request)
            
            if result.count != 0 {
                filteredArray.removeAll()
            }
            for data in result as! [NSManagedObject]
            {
                filteredArray.append(data)
            }
            employeeListTbl.reloadData()
            print("The count = \(storedDataArray.count)")
        } catch {
            print("Failed")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredArray = employeeDetailArray
        employeeListTbl.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension UIImageView {
 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        if self.image == nil{
              self.image = PlaceHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }}

