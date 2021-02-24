//
//  SearchViewController.swift
//  List Stargazers
//
//  Created by Mattia Cardone on 22/02/2021.
//

import UIKit

class SearchViewController: UIViewController {

    let stargazersVC = "StargazersTableViewController"
    let storyboardId = "Main"
    
    @IBOutlet weak var ownerTextField: UITextField?
    @IBOutlet weak var repoTextField: UITextField?
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton?
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.repoLabel.textColor = .black
        self.ownerLabel.textColor = .black
        self.welcomeLabel.textColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func resetButton(_ sender: Any) {
        self.ownerTextField?.text = ""
        self.repoTextField?.text = ""
    }
    

    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let owner = ownerTextField?.text, owner.count > 0,
            let repo = repoTextField?.text, repo.count > 0 else {
            return
        }

        simulateLoaderEffect(true)

        GitHub.getStargazers(by: owner, repo: repo) { (result) in
            self.simulateLoaderEffect(false)

            switch result {
                case .success(let stargazer):
                    self.presentStargazersTableViewController(with: stargazer)
                case .failure(let error):
                   self.presentErrorView(with: error.localizedDescription)
            }
        }
    }

    private func simulateLoaderEffect(_ enable: Bool) {
        self.view.alpha = enable ? 0.8 : 1.0
        self.view.isUserInteractionEnabled = !enable
    }

    private func presentErrorView(with message: String) {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }

    private func presentStargazersTableViewController(with items: [Stargazer]) {
        guard let vc = UIStoryboard(name: storyboardId, bundle: nil)
            .instantiateViewController(withIdentifier: stargazersVC) as? StargazersTableViewController else {
            return
        }
        vc.items = items
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

