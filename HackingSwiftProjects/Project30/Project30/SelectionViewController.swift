//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	// var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
	var dirty = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none

		// load all the JPEGs into our array
		let fm = FileManager.default

		if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
			for item in tempItems {
				if item.range(of: "Large") != nil {
					items.append(item)
				}
			}
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
		// find the image for this cell, and load its thumbnail
		let currentImage = items[indexPath.row % items.count]
		let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
		let path = Bundle.main.path(forResource: imageRootName, ofType: nil)!
        let original = UIImage(contentsOfFile: path)
        
		// let renderer = UIGraphicsImageRenderer(size: original.size)
        
        // 3. 원본 사이즈보다 줄이기 위해 Rect를 선언 후 해당 크기만큼 그래픽 렌더링을 진행
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)

		let rounded = renderer.image { ctx in
            // 2. Core Graphics에서 shadow 렌더링을 함께 진행할 수 있기 때문에 더 빠르게 가능
            // 하지만 그림자가 renderer의 사이즈를 기반으로 생성됨 (원본과 renderer 사이즈가 다를 수 있기 때문에 리소스 낭비 가능성)
            // 이 shadowing의 결과가 원래와 같지 않을 수 있음
//            ctx.cgContext.setShadow(offset: CGSize.zero, blur: 200, color: UIColor.black.cgColor)
//            ctx.cgContext.fillEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
//            ctx.cgContext.setShadow(offset: CGSize.zero, blur: 0)
            
			// ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            ctx.cgContext.addEllipse(in: renderRect)
			ctx.cgContext.clip()

			// original.draw(at: CGPoint.zero)
            original?.draw(in: renderRect)
		}

		cell.imageView?.image = rounded

//		// give the images a nice shadow to make them look a bit more dramatic -> 1. 이미지의 모든 비트를 읽어야하기때문에 오래걸림
//		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
//		cell.imageView?.layer.shadowOpacity = 1
//		cell.imageView?.layer.shadowRadius = 10
//		cell.imageView?.layer.shadowOffset = CGSize.zero
        
        // 4. 새롭게 업데이트 된 shadow -> 이미 renderRect라는 명확한 사이즈가 제시되기때문에 그거 따라서 그림자 그리면 됨
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
		// viewControllers.append(vc)
		navigationController!.pushViewController(vc, animated: true)
	}
}
