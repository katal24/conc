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

    
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagesTableView: UITableView!
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    @IBAction func stopDownload(_ sender: Any) {
//        downloadTask.cancel();
        downloadTask.cancel();
   }
    
    let urls : [String] = [
    "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg"
    ];
    
//    let urls : [String] = [
//        "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg"
//    ];
//    
//    let urls = [
//        "https://images.which-50.com/wp-content/uploads/2017/02/Mark-Grether-Sizmek.jpg",
//        "https://assets1.cdn-mw.com/mw/images/article/art-global-footer-recirc/personage-2338-0c870fcce7dc9a616a70597b63276f4f@1x.jpg",
//        "http://www.therecord.com.au/wp-content/uploads/2012/08/family-photo-2005-10-1024x682.jpg",
//        "https://images.which-50.com/wp-content/uploads/2017/02/Mark-Grether-Sizmek.jpg"
//    ]
//    
    let names : [String] = [
        "Family_Portrait",
        "Google_Art_Project",
        "A_Grotesque_old_woman",
        "Valmy_Battle_painting"
    ]
    
        var progress : [Int] = [
            0,0,0,0
        ]
    
    var halfFlag = [true, true, true, true];
    
//    let names : [String] = [
//        "Family_Portrait"
//    ]
    
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
        cell.detailTextLabel?.text = "Progress \(progress[indexPath.row]) %";
        return cell
    }
    
    func readData() {
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
    
     //1
    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let nazwese = (downloadTask.originalRequest?.url?.absoluteString)!
        
        let numberOfFile = urls.index(of: nazwese)!
        
        print("Finished downloading of file: \(numberOfFile+1)")
        
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
            print("Finished moving of file: \(numberOfFile+1)");
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
       // let imagePath: UIImage = UIImage(named: paths)!
       // let imageView1 = UIImageView(image: imagePath);
        imageView.image = UIImage(contentsOfFile: paths)!
        

        
        detectFaces(numberOfFile: numberOfFile);
        
       // imageView.frame = CGRect(x: 300, y: 600, width: 80, height: 100)
       // imageView.addSubview(imageView1)
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
    
    var counter = 0;
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
     //   print(session);
        counter += 1;
        
        let nazwese = (downloadTask.originalRequest?.url?.absoluteString)!
        let numberOfFile = urls.index(of: nazwese)!
        
        if(counter % 10 == 0 ){
//            print(Float(totalBytesWritten)*100/Float(totalBytesExpectedToWrite));
            progress[numberOfFile] = Int(Float(totalBytesWritten)*100/Float(totalBytesExpectedToWrite))
        }
        
        if(progress[numberOfFile] >= 50 && halfFlag[numberOfFile] ){
            halfFlag[numberOfFile] = false;
            print("50% downloading of file \(numberOfFile+1)")
        }
        
        imagesTableView.reloadData()
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

    @IBAction func detectFaceClicked(_ sender: Any) {
        detectFaces(numberOfFile: 1);
    }

    func detectFaces(numberOfFile: Int) {
        print("started face detection of file \(numberOfFile+1)")
       // print(imageView.image?.accessibilityIdentifier)
        let faceImage = CIImage(image: imageView.image!)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let faces = faceDetector?.features(in: faceImage!) as! [CIFaceFeature]
        print("Finished face detection of file \(numberOfFile+1). Number of faces: \(faces.count) ")
//        print("Number of faces: \(faces.count)")
    }
    
    
    
}

