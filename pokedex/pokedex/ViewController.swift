//
//  ViewController.swift
//  pokedex
//
//  Created by Gabriel Fontes on 25/06/21.
//

import UIKit

class ViewController: UIViewController {

    lazy var viewTest = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(viewTest)
        viewTest.translatesAutoresizingMaskIntoConstraints = false
        viewTest.backgroundColor = .red
    }


}

