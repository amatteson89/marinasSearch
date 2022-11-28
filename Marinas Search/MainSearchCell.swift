//
//  MainSearchCell.swift
//  Marinas Search
//
//  Created by mattesona on 11/26/22.
//

import Foundation
import UIKit
import WebKit

/// Table view Cell to configure each cell of the main search
class MainSearchCell: UITableViewCell {
    // MARK: Properties

    static let ID = "mainSearchCell"
    private static let padding: CGFloat = 4.0

    /// Label for the name of of the point
    private let locationNameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// Label for kind of point
    private let kindLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// Icon of the point
    private let iconImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .left
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    /// Banner image (when it exists) for the location
    private let bannerImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    /// Stack view for the locations and kind of point
    private lazy var infoStackView: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [locationNameLabel, kindLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()

    /// Stack view of the icon with all the textual information
    private lazy var textStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [iconImage, infoStackView])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    /// Stack of all the information
    private lazy var stackView: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [textStack, bannerImage])
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers

    /// Configure the layout constraints
    func configureUI() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.padding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Self.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.padding),
            iconImage.widthAnchor.constraint(lessThanOrEqualToConstant: 50.0),
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Update the search cell with the location data
    func updateSearchCell(using location: LocationData?) {
        locationNameLabel.text = location?.name
        kindLabel.text = location?.kind

        if let count = location?.images.data?.count, count > 0 {
            if let small_url = location?.images.data?[0].small_url, let url = URL(string: small_url) {
                print("Getting banner = \(small_url)")
                bannerImage.load(url: url)
            }
        } else {
            bannerImage.image = UIImage()
        }

        if let icon_url = location?.icon_url {
            iconImage.image = IconLookupHelper.lookupIcon(icon_url)
        }
    }
}
