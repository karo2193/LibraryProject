//
//  MainViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

protocol MainPageViewControllerDelegate: class {
    func presentViewController(_ viewController: UIViewController)
    func next(viewController: UIViewController)
    func previous(viewController: UIViewController)
    func initNavigationBar(withTitle title: String?, leftButton: UIBarButtonItem?, rightButton: UIBarButtonItem?)
}

class MainPageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        guard let firstViewController = getViewController(named: "SearchViewController") as? SearchViewController else {
            return []
        }
        firstViewController.delegate = self
        return [firstViewController]
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
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}

//MARK: Custom MainPageViewControllerDelegate for automatic page curling
extension MainPageViewController: MainPageViewControllerDelegate {
    
    func presentViewController(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func next(viewController: UIViewController) {
        setViewControllers([viewController], direction: .forward, animated: true, completion: {
            completed in
            self.view.isUserInteractionEnabled = true
        })
    }
    
    func previous(viewController: UIViewController) {
        setViewControllers([viewController], direction: .reverse, animated: true, completion: {
            completed in
            self.view.isUserInteractionEnabled = true
        })
    }
    
    func initNavigationBar(withTitle title: String?, leftButton: UIBarButtonItem?, rightButton: UIBarButtonItem?) {
        DispatchQueue.main.async {
            let navigationBar = self.navigationController?.navigationBar
            navigationBar?.barStyle = .blackOpaque
            navigationBar?.barTintColor = .tintDark
            navigationBar?.tintColor = .main
            navigationBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.main]
            navigationBar?.topItem?.title = title
            self.navigationItem.rightBarButtonItem = rightButton
            self.navigationItem.leftBarButtonItem = leftButton
        }
    }
    
}
