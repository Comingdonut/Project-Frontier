//
//  StartController.swift
//  Project Frontier
//
//  Created by James Castrejon on 9/12/17.
//  Copyright © 2017 James Castrejon. All rights reserved.
//

import UIKit

protocol ContainerDelegateProtocol {
    func close()
}

class StartController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    
    var delegate: ContainerDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        let currentView = findCurrentView()
        switch sender.selectedSegmentIndex {
        case 0:
            changeView(current: currentView, new: viewOne)
            break
        case 1:
            changeView(current: currentView, new: viewTwo)
            break
        case 2:
            changeView(current: currentView, new: viewThree)
            break
        case 3:
            changeView(current: currentView, new: viewFour)
            break
        default:
            break
        }
    }
    
    @IBAction func nextView(_ sender: UIButton) {
        let currentView = findCurrentView()
        switch currentView.tag {
        case 0:
            changeView(current: currentView, new: viewTwo)
            changeSelectedIndex(index: 1)
            break
        case 1:
            changeView(current: currentView, new: viewThree)
            changeSelectedIndex(index: 2)
            break
        case 2:
            changeView(current: currentView, new: viewFour)
            changeSelectedIndex(index: 3)
            break
        case 3:
            exitView()
            break
        default:
            break
        }
    }
    
    private func changeView(current view1: UIView, new view2: UIView){
        view1.isHidden = true
        view2.isHidden = false
    }
    
    private func findCurrentView() -> UIView{
        var currentView: UIView = viewOne
        if !viewTwo.isHidden {
            currentView = viewTwo
        }
        else if !viewThree.isHidden {
            currentView = viewThree
        }
        else if !viewFour.isHidden {
            currentView = viewFour
        }
        return currentView
    }
    
    private func changeSelectedIndex(index num: Int){
        if num >= 0 && num <= 3 {
            segmentedControl.selectedSegmentIndex = num
        }
    }
    
    private func exitView(){
        delegate?.close()
    }
    
}
