//
//  SplashVC.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import UIKit

class SplashVC: UIViewController {

    var count = 2
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    func setupUI(){
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    @objc func updateUI(){
        if count > 0 {
            count -= 1
        }else{
            showVC()
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    @objc func showVC(){
        let storyboard = UIStoryboard(name: "Characters", bundle: nil)
        let CharactersVC = storyboard.instantiateViewController(withIdentifier: "CharactersVC")
        navigationController?.pushViewController(CharactersVC, animated: true)
    }
}
