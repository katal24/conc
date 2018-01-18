//
//  ViewController.swift
//  concurrency
//
//  Created by Użytkownik Gość on 12.01.2018.
//  Copyright © 2018 dawid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, URLSessionDownloadDelegate {
//    @available(iOS 7.0, *)
//    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        <#code#>
//    }

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imagesTableView: UITableView!
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
//    let urls : [String] = [
//        "http://www.mindsandvines.com/wp-content/uploads/2016/06/coloring_pictures_cats.jpg",
//        "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg",
//        "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg",
//        "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg"
//    ]
    
    let urls : [String] = [
        "http://www.mindsandvines.com/wp-content/uploads/2016/06/coloring_pictures_cats.jpg",
        "http://www.mindsandvines.com/wp-content/uploads/2016/06/coloring_pictures_cats.jpg",
        "http://www.mindsandvines.com/wp-content/uploads/2016/06/coloring_pictures_cats.jpg",
        "http://www.mindsandvines.com/wp-content/uploads/2016/06/coloring_pictures_cats.jpg"
    ]
    
    let names : [String] = ["Kot", "Family",  "Woman", "Battle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData();
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession");
        
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main);
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = imagesTableView.dequeueReusableCell(withIdentifier: "imageCell") as UITableViewCell!;
        
        cell.textLabel?.text = names[indexPath.row];
        cell.detailTextLabel?.text = "Progress";
        return cell
    }
    
    func readData() {
    }
    @IBAction func downloadClicked(_ sender: Any) {
        startDownload();
    }
    
    func startDownload() {
        print("start");
        var url1:URL;
        for url in urls {
            url1 = URL(string: url)!
            downloadTask = backgroundSession.downloadTask(with: url1)
            downloadTask.resume()
        }

    }
    
     //1
    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        print("urlsession");
//        print(location);
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let documentPath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let fileManager = FileManager()
       
        
        let names = String(describing: downloadTask.originalRequest?.url!).components(separatedBy: "/");
        let name = names[names.count - 1];
        
        let paths = documentPath.appendingFormat(name);
        print(paths);
        let destinationURLForFile = URL(fileURLWithPath: paths)
        
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            print("ok - plik juz istnieje");
            // showFileWithPath(path: destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                print("ok - download finished");
//                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
        let imagePath: UIImage = UIImage(named: paths)!
        let imageView = UIImageView(image: imagePath);
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        image.addSubview(imageView)
     }
    // 2

    public func urlSession(_ session: URLSession,
                task: URLSessionTask,
                didCompleteWithError error: Error?){
//        progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        print("urlsession");
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
     //   print(session);
        
        print(Float(totalBytesWritten)*100/Float(totalBytesExpectedToWrite));
//        if(Float(totalBytesWritten)*100/Float(totalBytesExpectedToWrite) > Float(procent) ) {
//            procent = procent + 1;
//            print("Progress: ");
//            print(procent);
        
//        }
//        print(totalBytesWritten/);
//        progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    

    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
//    func showFileWithPath(path: String){
//        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
//        if isFileFound == true{
//            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
//            viewer.delegate = self
//            viewer.presentPreview(animated: true)
//        }
//    }


    
}

