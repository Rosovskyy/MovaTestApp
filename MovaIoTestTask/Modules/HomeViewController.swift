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
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: HomeViewModel?
    var router: HomeRouterProtocol?
    private let api = MovaAPI.shared
    
    private var images = [ImageResponse]()
    
    // MARK: - Views
    let searchTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Type tag here"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()

    let tableView: UITableView = {
        return UITableView()
    }()

    let imagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Images:"
        return label
    }()
    
    let enterTagLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the tag:"
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupUI()
        prepareBind()
    }
    
    // MARK: - Private
    private func setupUI() {
        
        // Setup VM, router
        viewModel = HomeViewModel(api: api)
        router = HomeRouter()
        
        // Delegates
        searchTextField.addCloseButtonOnKeyboard()
        searchTextField.delegate = self
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.id)
        
        // Data
        if let lastImage = DBManager.shared.getDataFromDB(with: ImageSearchRealm.self).first {
            viewModel?.imagesList.accept([ImageResponse(realm: lastImage)])
        }
    }
    
    private func setupViews() {
        view.addSubview(enterTagLabel)
        view.addSubview(searchTextField)
        view.addSubview(imagesLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        enterTagLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(self.enterTagLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(self.enterTagLabel.snp.bottom).offset(10)
        }
        
        imagesLabel.snp.makeConstraints {
            $0.leading.equalTo(self.enterTagLabel.snp.leading)
            $0.top.equalTo(self.searchTextField.snp.bottom).offset(18)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.imagesLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func prepareBind() {
        viewModel?.imagesList.bind { [weak self] images in
            self?.images = images
            DispatchQueue.main.async {
                self?.imagesLabel.isHidden = images.isEmpty
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.tableView.reloadData()
            }
        }.disposed(by: rx.disposeBag)
        
        viewModel?.requestFailure.bind { [weak self] _ in
            let alert = UIAlertController(title: "Some troubles..", message: "Couldn't find the picture :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.present(alert, animated: true)
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
        cell.separatorView.isHidden = indexPath.row == images.count - 1
        
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
