//
//  ViewController.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import UIKit


class WeatherViewController: UIViewController {
    let weatherLoader = WeatherLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: Constants.nsuImageName))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        let textColor = UIColor.white
        
        let weatherAtLabel = UILabel()
        weatherAtLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        weatherAtLabel.text = Constants.weatherAtLabel
        weatherAtLabel.textColor = textColor
        weatherAtLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weatherAtLabel)
        let weatherAtLabelInset = Constants.weatherAtLabelInset
        if #available(iOS 11.0, *) {
            weatherAtLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: weatherAtLabelInset).isActive = true
        } else {
            weatherAtLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: weatherAtLabelInset).isActive = true
        }
        weatherAtLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let nsuLabel = UILabel()
        nsuLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        nsuLabel.text = Constants.nsuLabel
        nsuLabel.textColor = textColor
        nsuLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nsuLabel)
        nsuLabel.topAnchor.constraint(equalTo: weatherAtLabel.bottomAnchor).isActive = true
        nsuLabel.centerXAnchor.constraint(equalTo: weatherAtLabel.centerXAnchor).isActive = true
        
        let temperatureLabel = UILabel()
        temperatureLabel.tag = self.temperatureLabelTag
        temperatureLabel.font = nsuLabel.font
        temperatureLabel.textColor = textColor
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(temperatureLabel)
        temperatureLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let linksView = UIView()
        linksView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(linksView)
        let linksViewBottomInset = Constants.linksViewBottomInset
        if #available(iOS 11.0, *) {
            linksView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -linksViewBottomInset).isActive = true
        } else {
            linksView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -linksViewBottomInset).isActive = true
        }
        linksView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let poweredByLabel = UILabel()
        poweredByLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        poweredByLabel.textColor = textColor
        poweredByLabel.text = Constants.poweredByLabel
        poweredByLabel.translatesAutoresizingMaskIntoConstraints = false
        linksView.addSubview(poweredByLabel)
        poweredByLabel.leftAnchor.constraint(equalTo: linksView.leftAnchor).isActive = true
        poweredByLabel.centerYAnchor.constraint(equalTo: linksView.centerYAnchor).isActive = true
        poweredByLabel.topAnchor.constraint(greaterThanOrEqualTo: linksView.topAnchor).isActive = true
        poweredByLabel.bottomAnchor.constraint(lessThanOrEqualTo: linksView.bottomAnchor).isActive = true
        
        let linkButton = UIButton(type: .system)
        linkButton.titleLabel?.font = poweredByLabel.font
        linkButton.setTitle(Constants.linkButtonLabel, for: .normal)
        linkButton.addTarget(self, action: #selector(self.openLinkAction(_:)), for: .touchUpInside)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linksView.addSubview(linkButton)
        linkButton.rightAnchor.constraint(equalTo: linksView.rightAnchor).isActive = true
        linkButton.centerYAnchor.constraint(equalTo: linksView.centerYAnchor).isActive = true
        linkButton.leftAnchor.constraint(equalTo: poweredByLabel.rightAnchor).isActive = true
        linkButton.topAnchor.constraint(greaterThanOrEqualTo: linksView.topAnchor).isActive = true
        linkButton.bottomAnchor.constraint(lessThanOrEqualTo: linksView.bottomAnchor).isActive = true
        
        let updateWeatherButtonSize = Constants.updateWeatherButtonSize
        let updateWeatherButton = UIButton(type: .system)
        updateWeatherButton.addTarget(self, action: #selector(self.updateWeatherAction(_:)), for: .touchUpInside)
        updateWeatherButton.setImage(UIImage(named: Constants.updateWeatherImageName), for: .normal)
        updateWeatherButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        updateWeatherButton.layer.cornerRadius = updateWeatherButtonSize / 2
        updateWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(updateWeatherButton)
        updateWeatherButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        updateWeatherButton.bottomAnchor.constraint(equalTo: linksView.topAnchor, constant: -Constants.updateWeatherButtonBottomSpace).isActive = true
        updateWeatherButton.widthAnchor.constraint(equalToConstant: updateWeatherButtonSize).isActive = true
        updateWeatherButton.heightAnchor.constraint(equalToConstant: updateWeatherButtonSize).isActive = true
        
        self.weatherLoader.loadData(completion: { weather in
            DispatchQueue.main.async {
                temperatureLabel.text = weather
            }
        })
    }
    
    private var temperatureLabelTag: Int {
        return -101
    }
    
    @objc private func openLinkAction(_ sender: UIButton) {
        sender.isEnabled = false
        
        UIApplication.shared.open(URL(string: "https://github.com/NSSimpleApps")!,
                                  options: [:], completionHandler: { _ in
                                    sender.isEnabled = true
                                  })
    }
    
    @objc private func updateWeatherAction(_ sender: UIButton) {
        guard let temperatureLabel = self.view.viewWithTag(self.temperatureLabelTag) as? UILabel else { return }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi
        rotationAnimation.duration = 0.35
        
        sender.isEnabled = false
        sender.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        self.weatherLoader.loadData { weather in
            DispatchQueue.main.async {
                sender.isEnabled = true
                temperatureLabel.text = weather
            }
        }
    }
}

