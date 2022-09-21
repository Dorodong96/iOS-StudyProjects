//
//  ActionViewController.swift
//  Extension
//
//  Created by DongKyu Kim on 2022/09/04.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selection))
        
        // Keyboard with notificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    // loadItem()의 실행으로 호출되는 클로저 내부에 존재
                    // -> 해당 클로저는 어떤 스레드에서든 실행될 수 있음
                    // -> UI변경이 필요한 부분만 main thread에 할당
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }

    
    // textView에 입력한 단어를 다시 되돌려줌
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        // Safari로 데이터 다시 보내기
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        
        defaults.set(customJavaScript, forKey: pageURL)
        extensionContext?.completeRequest(returningItems: [item])

    }
    
    // textView에 선택한 prewritten example을 주는 alert
    @objc func selection() {
        let ac = UIAlertController(title: "Examples", message: "Select prewritten examples", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Title Alert", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(document.title)"
        }))
        ac.addAction(UIAlertAction(title: "URL Alert", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(document.URL)"
        }))
        present(ac, animated: true)
    }
    
    // 키보드 레이아웃을 위한 함수
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
