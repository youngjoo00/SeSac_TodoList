//
//  FileManager+Extension.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/19/24.
//

import UIKit

extension UIViewController {
    
    func setFileURL(filename: String) -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let imagesDirectory = documentDirectory.appending(path: "images")
        
        if !FileManager.default.fileExists(atPath: imagesDirectory.path()) {
            do {
                try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
            } catch {
                print("Failed to create folder", error)
                return nil
            }
        }
        
        let fileURL = imagesDirectory.appendingPathComponent("\(filename).jpg")
        
        return fileURL
    }
    
    /**
        이미지를 저장합니다.
        매개변수로는 저장할 이미지와 파일명으로 사용할 DB 의 PrimaryKey 값인 id 사용
     */
    func saveImageToDocument(image: UIImage, filename: String) {
        guard let fileURL = setFileURL(filename: filename) else { return }
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error!", error)
        }
    }
    
    /// 이미지를 가져옵니다. 파일명으로 사용할 DB 의 PrimaryKey 값인 id 사용
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let fileURL = setFileURL(filename: filename) else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return nil
        }
    }
}
