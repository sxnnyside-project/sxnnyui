//
//  UIImage.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

// MARK: - UIKit-backed implementations (iOS, iPadOS, visionOS, tvOS where UIKit exists)
#if canImport(UIKit)
import UIKit
import CoreImage

public extension UIImage {

    // MARK: Orientation

    /// Returns a new image with orientation corrected to `.up`.
    ///
    /// If the image is already `.up`, the receiver is returned. If the operation cannot
    /// be completed (e.g., missing CGImage or graphics context), the receiver is returned.
    ///
    /// - Returns: A new `UIImage` with `.up` orientation, or `self` if no correction is needed.
    @inlinable
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != .up else { return self }
        guard let cgImage = self.cgImage else { return self }

        let width = size.width
        let height = size.height

        var transform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0).rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height).rotated(by: -.pi / 2)
        default:
            break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0).scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0).scaledBy(x: -1, y: 1)
        default:
            break
        }

        guard
            let colorSpace = cgImage.colorSpace,
            let context = CGContext(
                data: nil,
                width: Int(width),
                height: Int(height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: cgImage.bitmapInfo.rawValue
            )
        else {
            return self
        }

        context.concatenate(transform)

        let drawRect: CGRect
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            drawRect = CGRect(x: 0, y: 0, width: height, height: width)
        default:
            drawRect = CGRect(x: 0, y: 0, width: width, height: height)
        }

        context.draw(cgImage, in: drawRect)

        guard let correctedImage = context.makeImage() else { return self }
        return UIImage(cgImage: correctedImage, scale: scale, orientation: .up)
    }

    // MARK: Resizing & Cropping

    /// Returns a new image resized to the specified size.
    ///
    /// - Parameter newSize: The target size in points.
    /// - Returns: A resized image, or `nil` if drawing fails.
    @inlinable
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// Returns a new image cropped to the specified size, centered within the original image.
    ///
    /// - Parameter size: The crop size in points.
    /// - Returns: A cropped image, or `nil` if cropping fails.
    @inlinable
    func cropped(to size: CGSize) -> UIImage? {
        let originX = max((self.size.width - size.width) / 2, 0)
        let originY = max((self.size.height - size.height) / 2, 0)
        let cropRectPoints = CGRect(origin: CGPoint(x: originX, y: originY), size: size)
        let cropRectPixels = cropRectPoints.applying(CGAffineTransform(scaleX: scale, y: scale))

        guard let cgImage = self.cgImage?.cropping(to: cropRectPixels) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }

    // MARK: Conversions

    /// Returns the image as a Base64-encoded PNG string.
    @inlinable
    func asBase64() -> String? {
        pngData()?.base64EncodedString()
    }

    /// Converts the image to a Core Image representation.
    @inlinable
    func asCIImage() -> CIImage? {
        CIImage(image: self)
    }

    // MARK: Alpha

    /// A Boolean value indicating whether the image contains an alpha channel.
    @inlinable
    var hasAlphaChannel: Bool {
        guard let alpha = cgImage?.alphaInfo else { return false }
        switch alpha {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
        }
    }
}

#else

// MARK: - Non-UIKit platforms (e.g., macOS without UIKit, watchOS)
// Provide stubs so the package builds cross‑platform. Users on these platforms
// should rely on platform-appropriate image types (e.g., NSImage) in separate utilities.

public enum UIImageUnavailableError: Error {}

public extension /* placeholder for unavailable UIImage */ Never {
    // No UIImage on this platform.
}

// You can alternatively choose to omit this file entirely for non‑UIKit platforms,
// or provide a parallel NSImage extension in a separate file guarded by `canImport(AppKit)`.

#endif
