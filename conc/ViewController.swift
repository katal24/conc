//
//  ViewController.swift
//  concurrency
//
//  Created by Użytkownik Gość on 12.01.2018.
//  Copyright © 2018 dawid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, URLSessionDownloadDelegate {

//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagesTableView: UITableView!
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    
    let urls : [String] = [
    "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg"
    ];
    

//    let urls = [
//        "https://images.which-50.com/wp-content/uploads/2017/02/Mark-Grether-Sizmek.jpg",
//        "https://assets1.cdn-mw.com/mw/images/article/art-global-footer-recirc/personage-2338-0c870fcce7dc9a616a70597b63276f4f@1x.jpg",
//        "http://www.therecord.com.au/wp-content/uploads/2012/08/family-photo-2005-10-1024x682.jpg",
//        "https://naukarysowania.com/resources/SrednioTrudne/Kot/jak-narysowac-kota19.jpg"
//    ]
//    
    let names : [String] = [
        "Family Portrait",
        "Google Art Project",
        "A Grotesque old woman",
        "Valmy Battle painting"
    ]
    
    var progress : [Int] = [0,0,0,0]
    var halfFlag = [true, true, true, true];
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // imageView.isHidden = true;
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession");
        
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = imagesTableView.dequeueReusableCell(withIdentifier: "imageCell") as UITableViewCell!;
        
        cell.textLabel?.text = names[indexPath.row];
        cell.detailTextLabel?.text = "Progress \(progress[indexPath.row]) %";
        return cell
    }
    
    @IBAction func downloadClicked(_ sender: Any) {
        startDownload();
    }
    
    func startDownload() {
        var url1:URL;
        for (index, url) in urls.enumerated() {
            url1 = URL(string: url)!
            
            print("start downloading file \(index)");
            
            downloadTask = backgroundSession.downloadTask(with: url1)
            downloadTask.resume()
        }
    }
    
    
    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let urlString = (downloadTask.originalRequest?.url?.absoluteString)!
        let numberOfFile = urls.index(of: urlString)!
        print("Finished downloading of file: \(numberOfFile+1)")

        let fileManager = FileManager()

        let documentPath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
       
        let fileNames = String(describing: downloadTask.originalRequest?.url!).components(separatedBy: "/");
        let fileName = fileNames[fileNames.count - 1];
        
        let path = documentPath.appendingFormat(fileName);
        let destinationURLForFile = URL(fileURLWithPath: path)
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            print("File \(numberOfFile+1) exists in destination url");
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // file moved
                print("Finished moving of file: \(numberOfFile+1)");
                progress[numberOfFile] = 100;
                imagesTableView.reloadData()
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
        
        detectFaces(numberOfFile: numberOfFile, uImage: UIImage(contentsOfFile: path)!);
     }

    public func urlSession(_ session: URLSession,
                task: URLSessionTask,
                didCompleteWithError error: Error?){
        if (error != nil) {
            print(error!.localizedDescription)
        }
    }
    
    var counter = 0;
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
        counter += 1;
        
        let path = (downloadTask.originalRequest?.url?.absoluteString)!
        let numberOfFile = urls.index(of: path)!
        
        
            progress[numberOfFile] = Int(Float(totalBytesWritten)*100/Float(totalBytesExpectedToWrite))
        
        
        if(halfFlag[numberOfFile] && progress[numberOfFile] >= 50){
            halfFlag[numberOfFile] = false;
            print("50% downloading of file \(numberOfFile+1)")
        }

        imagesTableView.reloadData()
    }
    

    func detectFaces(numberOfFile: Int, uImage: UIImage) {
        print("started face detection of file \(numberOfFile+1)")
       
        let faceImage = CIImage(image: uImage)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let faces = faceDetector?.features(in: faceImage!) as! [CIFaceFeature]
        
        print("Finished face detection of file \(numberOfFile+1). Number of faces: \(faces.count) ")
    }
    
}

