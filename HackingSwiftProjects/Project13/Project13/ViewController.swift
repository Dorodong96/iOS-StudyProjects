//
//  ViewController.swift
//  Project13
//
//  Created by DongKyu Kim on 2022/08/15.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var changeFilterButton: UIButton!
    
    var currentImage: UIImage!
    
    // CoreImage Properties
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No Image", message: "There is no image to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .destructive))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        // Slider가 움직일 때 호출되는 함수
        applyProcessing()
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        // 사용자가 권한을 거부했을 때 에러가 발생할 수 있음
        if let error = error {
            // 에러를 받았을 때
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your alerted image has been saved to your PHOTOS", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func setFilter(action: UIAlertAction) {
        // Image가 있다는 것을 보장하도록 만들기
        guard currentImage != nil else { return }
        
        // title에서 alert action 안전하게 읽기
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        print(actionTitle)
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        // Intensity가 없는 Filter도 존재할 수 있기 때문에 케이스 나누기
        let inputKeys = currentFilter.inputKeys
        
        // IntensityKey를 사용할지, Radius, Scale ... 등의 지표를 사용할지 정하기
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue((intensity.value * 10), forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)}
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
        
        
        // Sepia 필터만 있을 때의 Filter 적용 과정
//        guard let image = currentFilter.outputImage else { return } // 현재 filter의 output image 결과 가져옴
//        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) // intensity slider의 값 활용
//
//        if let cgimg = context.createCGImage(image, from: image.extent) { // CGImage 타입으로 생성할 데이터 설정, 전체 이미지 -> image.extent
//            let processedImage = UIImage(cgImage: cgimg)
//            imageView.image = processedImage
//        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        
        // Apply Core Image Filter
        let beginImage = CIImage(image: currentImage) // CIImage 데이터 타입은 UIImage와 동일한 타입
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // CoreImageKey 상수
        
        applyProcessing()
    }
}

