//
//  IntroPageViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController {

    lazy var subViewControllers: [TutorialViewController] = {
        let controllers: [TutorialViewController] = [
            UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewControllerWelcome") as! TutorialViewController,
        UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewControllerSmartAddresses") as! TutorialViewController,
        UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewControllerSearch") as! TutorialViewController,
        UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewControllerMessaging") as! TutorialViewController,
        ]
        return controllers
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        if let firstViewController = self.subViewControllers.first {
            setViewControllers([firstViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true) { (flipped) in
            }
        }
        if let lastViewController = self.subViewControllers.last {
            lastViewController.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension IntroPageViewController: UIPageViewControllerDelegate {

}

extension IntroPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? TutorialViewController,
            let index = subViewControllers.firstIndex(of: viewController), index > 0 {
            return subViewControllers[index - 1]
        }
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? TutorialViewController,
            let index = subViewControllers.firstIndex(of: viewController), index < subViewControllers.count - 1 {
            return subViewControllers[index + 1]
        }
        return nil
    }


    // A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
    // Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }

    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension IntroPageViewController: TutorialDelegate {
    func tutorialComplete() {
        let onboardingVc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
        self.view.window?.rootViewController = onboardingVc
    }
}
