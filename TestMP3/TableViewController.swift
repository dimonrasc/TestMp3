//
//  TableViewController.swift
//  TestMP3
//
//  TableViewController0
//  Created by hu_f on 2/1/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

struct HeadLine {
    var isFile  : Bool = true
    var image : String = ""
    var name : String = ""
}

class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}

class TableViewController: UITableViewController {
    
    var listFiles = [String]()
    var upDownDirListCars = [String]()
    var colorString = ""
    var dirPaths : [URL]!
    var lastPathFolder : String = ""
    
    @IBOutlet var tableViewList: UITableView!
    
    var cellHeadLines = [HeadLine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileManag(path: "")
    }
    
    func fileManag(path : String){
        let filemgr = FileManager.default
        dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        //let myDocumentsDirectory = dirPaths[0].appendingPathComponent("2018 - MARUV - Black Water")
        let myDocumentsDirectory = dirPaths[0].appendingPathComponent(path)
        globalCurrrentFolder = myDocumentsDirectory.path
        print(myDocumentsDirectory)
        
        do {
            //let directoryContents = try FileManager.default.contentsOfDirectory(at: myDocumentsDirectory, includingPropertiesForKeys: nil, options: [])
            let directoryContents = try FileManager.default.contentsOfDirectory(at: myDocumentsDirectory, includingPropertiesForKeys: nil, options: [])
            
            let onlyFileNames = directoryContents.filter{ !$0.hasDirectoryPath }
            let onlyFileNamesStr = onlyFileNames.map { $0.lastPathComponent }
            
            let subdirs = directoryContents.filter{ $0.hasDirectoryPath }
            let subdirNamesStr = subdirs.map{ $0.lastPathComponent }
            print(subdirNamesStr)
            
            cellHeadLines.removeAll()
            
            for i in 0 ..< subdirNamesStr.count {
                cellHeadLines.append(HeadLine(isFile: false, image: "imgFolder", name: subdirNamesStr[i]))
            }
            
            for i in 0 ..< onlyFileNamesStr.count {
                cellHeadLines.append(HeadLine(isFile: true, image: "imgMp3File", name: onlyFileNamesStr[i]))
            }
            
            
            //print(onlyFileNamesStr)
            globalListMusicFilesInThisFolder.append(contentsOf: onlyFileNamesStr.sorted())
            //listFiles.append(contentsOf: onlyFileNamesStr.sorted())
            //listFiles.append(contentsOf: subdirNamesStr.sorted())
            //listFiles.sorted()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return listFiles.count
        return cellHeadLines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyCustomCell

        //cell.textLabel?.text = listFiles[indexPath.row]
        
        let headLine = cellHeadLines[indexPath.row]
        cell.cellName?.text = headLine.name
        cell.cellImage?.image = UIImage(named: headLine.image)

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        if (tableView.indexPathForSelectedRow != nil){
            //print(cellHeadLines[indexPath.row].isFile)
            if !cellHeadLines[indexPath.row].isFile{
                //print("conteins#.mp3")
                //print("Go to Next Folder: \(globalCurrrentFolder)/\(listFiles[indexPath.row])")
                print(cellHeadLines[indexPath.row].name)
                let selectFolder = cellHeadLines[indexPath.row].name
                if selectFolder == ""{
                    lastPathFolder = selectFolder
                }
                if selectFolder != lastPathFolder{
                    lastPathFolder = "\(lastPathFolder)/\(selectFolder)"
                }
                
                cellHeadLines.removeAll()
                tableView.reloadData()
                fileManag(path: lastPathFolder)
                tableView.reloadData()
                
                return true
            }
            
            //print("Taped cell:  \(indexPath.row)")
            print("You selected cell # \(cellHeadLines[indexPath.row].name)")
            //globalCurrrentFolder = dirPaths[0].path
            print(globalCurrrentFolder)

            globalSelectedFileToPlay = cellHeadLines[indexPath.row].name
            /*
            guard let delegate = self.delegate else {
                print("Delegate Dont Send1")
                return true
            }

            delegate.didSelectColor(text: "Send Text")
            */
        }
                    return true
    }
    
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
