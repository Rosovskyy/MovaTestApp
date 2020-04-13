//
//  ViewController.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import NSObject_Rx
import MBProgressHUD

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: HomeViewModel?
    var router: HomeRouterProtocol?
    private let api = MovaAPI.shared
    
    private var images = [ImageResponse]()
    
    // MARK: - IBOutlets
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var imagesLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        prepareBind()
    }
    
    // MARK: - Private
    private func setupUI() {
        
        // Setup VM, router
        viewModel = HomeViewModel(api: api)
        router = HomeRouter()
        
        // Delegates
        searchTextField.delegate = self
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: ImageTableViewCell.id, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.id)
        
        // Other
        imagesLabel.isHidden = true
    }
    
    private func prepareBind() {
        viewModel?.imagesList.bind { [weak self] images in
            self?.images = images
            if !images.isEmpty {
                self?.imagesLabel.isHidden = false
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.tableView.reloadData()
            }
        }.disposed(by: rx.disposeBag)
        
        viewModel?.requestFailure.bind { [weak self] _ in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
            }
        }.disposed(by: rx.disposeBag)
    }
}

// MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.id, for: indexPath) as! ImageTableViewCell
        
        cell.imageResponse = images[indexPath.row]
        
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}

// MARK: - TextField
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel?.getImageByTag(tag: text)
        
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
}
