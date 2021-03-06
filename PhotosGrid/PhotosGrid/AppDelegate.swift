//
//  AppDelegate.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-07.
//  Copyright © 2018 nil. All rights reserved.
//
//  ****************
//  *  REFERENCES  *
//  ****************
//  'iOS Programming: the Big Nerd Ranch Guide 6th ed.' Especially ch.20 (Web Services), and ch.21 (Collection Views)
//  UITableView Infinite Scrolling Tutorial
//  @ https://www.raywenderlich.com/5786-uitableview-infinite-scrolling-tutorial
//  UIScrollView Getting Started
//  @ https://www.raywenderlich.com/560-uiscrollview-tutorial-getting-started, Especially 'Paging with UIPageViewController' section
//  iOS Animation Tutorial: Custom View Controller Presentation Transitions
//  @ https://www.raywenderlich.com/359-ios-animation-tutorial-custom-view-controller-presentation-transitions
//  ****************

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

