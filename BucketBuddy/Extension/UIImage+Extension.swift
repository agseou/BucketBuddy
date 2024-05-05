//
//  UIImage+Extension.swift
//  BucketBuddy
//
//  Created by eunseou on 5/5/24.
//

import UIKit

extension UIImage {
    func compressTo2MB() -> Data? {
            var compression: CGFloat = 1.0
            let maxCompression: CGFloat = 0.05
            let maxFileSize: Int = 2 * 1024 * 1024 // 2MB

            var imageData = self.jpegData(compressionQuality: compression)

            while (imageData?.count ?? 0) > maxFileSize && compression > maxCompression {
                compression -= 0.05
                imageData = self.jpegData(compressionQuality: compression)
            }

            return imageData
        }
}
