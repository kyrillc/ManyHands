//
//  InteractionsHelper.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 30/08/2022.
//

import UIKit

func tap(_ button:UIButton) {
    button.sendActions(for: .touchUpInside)
}


func tap(_ button:UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}
