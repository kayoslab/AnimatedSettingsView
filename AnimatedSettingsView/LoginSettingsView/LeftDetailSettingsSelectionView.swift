/*
 *
 * Copyright (C) Kayos UG (haftungsbeschränkt) - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Kayos UG (haftungsbeschränkt) and its suppliers,
 * if any. The intellectual and technical concepts contained
 * herein are proprietary to Kayos UG (haftungsbeschränkt)
 * and its suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Kayos UG (haftungsbeschränkt).
 *
 * Written by Simon Christian Krüger <krueger.s@kayos.eu>, April 2016
 *
 */

protocol LeftDetailSettingsSelectionDelegate {

}

import Foundation
import UIKit

class LeftDetailSettingsSelectionView: UIView {
    @IBOutlet internal weak var view: UIView!
    @IBOutlet internal weak var settingsSwitch: UISwitch!
    @IBOutlet internal weak var settingsLabel: UILabel!
    @IBOutlet internal weak var settingsSubtitleLabel: UILabel!
    @IBOutlet internal weak var settingsImageView: UIImageView!

    internal var color:UIColor = .clear
    internal var invertTitleColor:Bool = false
    internal var delegate: LeftDetailSettingsSelectionDelegate?
    private var shapeLayer:CAShapeLayer?

    //MARK: - Draw Functions
    override func draw(_ rect: CGRect) {
        //
    }

    // Init from XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("LeftDetailSettingsSelectionView", owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0.0))
        self.settingsSwitch.setNeedsLayout()
        self.settingsLabel.setNeedsLayout()
        self.settingsSubtitleLabel.setNeedsLayout()
        self.settingsImageView.setNeedsLayout()
        self.layoutSubviews()
    }

    // Use for rotation-update
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.shapeLayer != nil {
            if (self.settingsSwitch.isOn == true) {

                var radius:CGFloat = 0.0
                if self.view.bounds.width > self.view.bounds.height {
                    radius = self.view.bounds.width * 2
                } else {
                    radius = self.view.bounds.height * 2
                }
                let animation1 = CABasicAnimation(keyPath: "path")
                let stopPath1 = self.circlePathWithCenter(center: self.settingsSwitch.center, radius: radius).cgPath
                animation1.fromValue = self.shapeLayer!.path
                animation1.toValue = stopPath1
                animation1.duration = 0.0
                animation1.beginTime = 0.0
                animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
                self.shapeLayer!.path = stopPath1
                self.shapeLayer!.add(animation1, forKey: animation1.keyPath)
            }
        }
    }

    func setup(withBackgroundColor color:UIColor, invertTitleColor:Bool = false) {
        self.color = color
        self.invertTitleColor = invertTitleColor
        if invertTitleColor {
            if self.settingsSwitch.isOn {
                self.settingsLabel.textColor = .white
            } else {
                self.settingsLabel.textColor = self.color
            }
        }
        self.setup()
    }

    // Initial Setup
    func setup() {
        // Create a CAShapeLayer
        self.shapeLayer = CAShapeLayer()
        // The Bezier path that we made needs to be converted to
        // a cgPath before it can be used on a layer.
        if self.settingsSwitch.isOn {
            var radius:CGFloat = 0.0
            if self.view.bounds.width > self.view.bounds.height {
                radius = self.view.bounds.width * 2
            } else {
                radius = self.view.bounds.height * 2
            }
            self.shapeLayer!.path = self.circlePathWithCenter(center: self.settingsSwitch.center, radius: radius).cgPath
        } else {
            self.shapeLayer!.path = self.circlePathWithCenter(center: self.settingsSwitch.center, radius: 0.0).cgPath
        }

        self.shapeLayer!.position = self.view.frame.origin
        self.shapeLayer!.fillColor = self.color.cgColor
        self.settingsSwitch.onTintColor = self.color
        // add the new layer to our custom view
        self.view.layer.insertSublayer(self.shapeLayer!, at: 0)
    }

    func circlePathWithCenter(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI/2), clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(M_PI/2), endAngle: 0, clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: -CGFloat(M_PI/2), clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: -CGFloat(M_PI/2), endAngle: -CGFloat(M_PI), clockwise: true)

        circlePath.close()
        return circlePath
    }

    // MARK: - Switch functions
    @IBAction func settingsSwitchValueChanged(sender: UISwitch) {
        if self.shapeLayer == nil {
            self.setup()
        }

        if invertTitleColor {
            if sender.isOn {
                self.settingsLabel.textColor = .white
            } else {
                self.settingsLabel.textColor = self.color
            }
        }

        if sender.isOn {
            var radius:CGFloat = 0.0
            if self.view.bounds.width > self.view.bounds.height {
                radius = self.view.bounds.width * 2
            } else {
                radius = self.view.bounds.height * 2
            }
            let animation = CABasicAnimation(keyPath: "path")
            let stopPath = self.circlePathWithCenter(center: self.settingsSwitch.center, radius: radius).cgPath
            animation.fromValue = self.shapeLayer!.path
            animation.toValue = stopPath
            animation.duration = 0.5
            animation.beginTime = 0.0
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
            self.shapeLayer!.path = stopPath
            self.shapeLayer!.add(animation, forKey: animation.keyPath)
        } else {
            let animation = CABasicAnimation(keyPath: "path")
            let stopPath = self.circlePathWithCenter(center: self.settingsSwitch.center, radius: 0.0).cgPath
            animation.fromValue = self.shapeLayer!.path
            animation.toValue = stopPath
            animation.duration = 0.5
            animation.beginTime = 0.0
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
            self.shapeLayer!.path = stopPath
            self.shapeLayer!.add(animation, forKey: animation.keyPath)
        }
    }
}
