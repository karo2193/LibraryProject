//
//  MainViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

protocol MainPageViewControllerDelegate: class {
    func nextViewController(from viewController: UIViewController)
    func previousViewController(from viewController: UIViewController)
}

class MainPageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        guard let firstViewController = getViewController(named: "MenuViewController") as? MenuViewController,
            let secondViewController = getViewController(named: "ListViewController") as? ListViewController else { return [] }
        firstViewController.delegate = self
        secondViewController.delegate = self
        return [firstViewController, secondViewController]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    private func getViewController(named name: String) -> UIViewController {
        return R.storyboard.main().instantiateViewController(withIdentifier: name)
    }
    
}

//MARK: PageViewController delegate
extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil//previous(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil//next(from: viewController)
    }
    
}

//MARK: Next/previous UIViewController getters
extension MainPageViewController {
    
    fileprivate func previous(from viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0, orderedViewControllers.count > previousIndex else { return nil }
        return orderedViewControllers[previousIndex]
    }
    
    fileprivate func next(from viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.index(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < orderedViewControllers.count else { return nil }
        return orderedViewControllers[nextIndex]
    }
    
}

//MARK: Custom MainPageViewControllerDelegate for automatic page curling
extension MainPageViewController: MainPageViewControllerDelegate {
    
    func nextViewController(from viewController: UIViewController) {
        guard let nextViewController = next(from: viewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func previousViewController(from viewController: UIViewController) {
        guard let previousViewController = previous(from: viewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }
    
}
