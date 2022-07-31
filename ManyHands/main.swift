//
//  main.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 31/07/2022.
//
// Code taken from https://github.com/hacknicity/TestingSceneDelegate

import UIKit

// If we have a TestingAppDelegate (i.e. we're running unit tests), use that to avoid executing initialisation code in AppDelegate
let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
