//
//  MoreInfoCollectionViewCell.swift
//  Marinas Search
//
//  Created by mattesona on 11/27/22.
//

import Foundation
import UIKit
import SafariServices
import MapKit

class MoreInfoCollectionViewCell: UICollectionViewCell {
    private static let padding = 4.0
    private var urlAddress: String = ""
    private var latitude = 0.0
    private var longitude = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let bannerImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    private let kindLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    lazy private var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()

    private let urlLabel: UILabel = {

        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.isUserInteractionEnabled = true
        return label
    }()

    @objc
    private func goToLink(_ sender: Any) {
        if let url = URL(string: urlAddress) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let sfViewcontroller = SFSafariViewController(url: url, configuration: config)
            contentView.window?.rootViewController?.present(sfViewcontroller, animated: true)
        }
    }

    private lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill

        stack.addArrangedSubview(bannerImage)
        stack.addArrangedSubview(kindLabel)
        stack.addArrangedSubview(urlLabel)

        return stack
    }()

    func addViews() {
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(self.goToLink(_:)))
        urlLabel.addGestureRecognizer(tapGesture)

        addSubview(stackView)
        addSubview(mapView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Self.padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.padding),
            stackView.widthAnchor.constraint(equalTo:widthAnchor),
            stackView.heightAnchor.constraint(equalTo:heightAnchor, multiplier: 0.5),

            mapView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Self.padding),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.padding),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.widthAnchor.constraint(equalTo:widthAnchor),
//            mapView.heightAnchor.constraint(equalTo:stackView.heightAnchor)
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }

    func updateInfoCell(using locationData: LocationData?) {
        kindLabel.text = "Kind: " + (locationData?.kind ?? "")
        urlLabel.text = "URL: Go to Address"
        urlAddress = locationData?.web_url ?? ""
        latitude = locationData?.location.lat ?? 0.0
        longitude = locationData?.location.lon ?? 0.0

        print("lat: \(latitude), lon: \(longitude)")

        let location = CLLocation(latitude: latitude, longitude: longitude)
        let radius: CLLocationDistance = 1000
        let coordinate = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinate, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        annotation.title = locationData?.name

        mapView.addAnnotation(annotation)

        if let count = locationData?.images.data?.count, count > 0 {
            if let small_url = locationData?.images.data?[0].small_url, let url = URL(string: small_url) {
                print("Getting banner = \(small_url)")
                bannerImage.load(url: url)
            }
        } else {
            bannerImage.image = UIImage()
        }
    }
}
