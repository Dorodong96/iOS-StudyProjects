//
//  AlertActionConvertible.swift
//  SeatchDaumBlog
//
//  Created by DongKyu Kim on 2022/11/01.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
