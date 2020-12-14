//
//  LoadingViewManager.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import UIKit

final class LoadingViewManager {
    
    private var loadingView = LoadingView()

    func showLoading(superView: UIView) {
        self.setupView(inSuperview: superView)

        self.loadingView.labelLoading.text = "Loading"
        self.loadingView.activityIndicator.startAnimating()
    }

    func showError(superView: UIView, message: String) {
        setupView(inSuperview: superView)
        
        loadingView.labelLoading.text = message
        loadingView.activityIndicator.stopAnimating()
    }

    private func setupView(inSuperview superView: UIView) {
        removeLoading()
        
        superView.addSubview(loadingView)
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.loadingView.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        self.loadingView.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        self.loadingView.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }

    func removeLoading() {
        self.loadingView.removeFromSuperview()
    }
}