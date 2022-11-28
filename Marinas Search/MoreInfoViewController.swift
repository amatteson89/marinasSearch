//
//  MoreInfoUpdatedViewController.swift
//  Marinas Search
//
//  Created by mattesona on 11/27/22.
//

import Foundation
import MapKit
import SafariServices
import UIKit

/// View Controller handling the extra information related to the point
class MoreInfoViewController: UIViewController {
    // MARK: Properties

    private static let padding = 4.0
    private var urlAddress: String = ""
    private var latitude = 0.0
    private var longitude = 0.0
    private var locationData: LocationData
    private var showBanner = false

    // MARK: View Overrides

    /// Sets up the view controller after the view has loaded.
    override func viewDidLoad() {
        super.viewDidLoad()

        updateInfoCell(using: locationData)
        addViews()
    }

    // MARK: Initialization

    /// Initialize the location data
    init(locationData: LocationData) {
        self.locationData = locationData

        super.init(nibName: nil, bundle: nil)
    }

    /// Default init required
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Views

    /// Image of the banner
    private let bannerImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    /// Image provided for the point
    private let iconImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .left
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    /// Label for the name of the point
    private let nameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// Label describing the diesel price
    private let dieselLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// Label for the kind of point
    private let kindLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// Map View of the point location
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()

    /// Clickable label for the URL
    private let urlLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .blue
        label.text = "View on Marinas.com"
        label.adjustsFontForContentSizeCategory = true
        label.isUserInteractionEnabled = true
        return label
    }()

    /// Review Rating Label
    private let reviewRatingLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isUserInteractionEnabled = true
        return label
    }()

    /// Review Count label
    private let reviewCountLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isUserInteractionEnabled = true
        return label
    }()

    /// Stack of most of the drawn labels
    private lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .top

        if showBanner { stack.addArrangedSubview(bannerImage) }
        stack.addArrangedSubview(dieselLabel)
        stack.addArrangedSubview(reviewRatingLabel)
        stack.addArrangedSubview(reviewCountLabel)
        stack.addArrangedSubview(kindLabel)
        stack.addArrangedSubview(urlLabel)

        return stack
    }()

    /// Add all the sub views to the main view
    func addViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToLink(_:)))
        urlLabel.addGestureRecognizer(tapGesture)

        view.addSubview(iconImage)
        view.addSubview(stackView)
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 40),
            iconImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            stackView.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: Self.padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.padding),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            mapView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Self.padding),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.padding),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Helper functions

    /// Update the views and properties with the location data
    func updateInfoCell(using locationData: LocationData?) {
        if let locationData = locationData {
            self.locationData = locationData
        }

        kindLabel.text = "Kind: " + (locationData?.kind ?? "")
        nameLabel.text = "Name: " + (locationData?.name ?? "")

        urlAddress = locationData?.web_url ?? ""
        latitude = locationData?.location.lat ?? 0.0
        longitude = locationData?.location.lon ?? 0.0

        if let rating = locationData?.rating {
            reviewRatingLabel.text = "Rating: \(rating)"
            reviewCountLabel.text = "Review Count: \(locationData?.review_count ?? 0)"
        } else {
            reviewRatingLabel.text = "No Rating"
        }

        if let hasDiesel = locationData?.fuel?.has_diesel, hasDiesel {
            dieselLabel.text = "Diesel Price: \(locationData?.fuel?.diesel_price ?? 0.0)"
        }

        if let icon_url = locationData?.icon_url {
            iconImage.image = IconLookupHelper.lookupIcon(icon_url)
        }

        addMapAnnotation()

        if let count = locationData?.images.data?.count, count > 0 {
            if let small_url = locationData?.images.data?[0].small_url, let url = URL(string: small_url) {
                print("Getting banner = \(small_url)")
                bannerImage.load(url: url)
                showBanner = true
            }
        } else {
            bannerImage.image = UIImage()
            showBanner = false
        }
    }

    /// Add the location of the point to the Map Kit view
    func addMapAnnotation() {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let radius: CLLocationDistance = 1000
        let coordinate = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinate, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        annotation.title = locationData.name

        mapView.addAnnotation(annotation)
    }

    /// Open the link provided to the main site
    @objc private func goToLink(_ sender: Any) {
        if let url = URL(string: urlAddress) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let sfViewcontroller = SFSafariViewController(url: url, configuration: config)
            view.window?.rootViewController?.present(sfViewcontroller, animated: true)
        }
    }
}
