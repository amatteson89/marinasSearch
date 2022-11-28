//
//  IconLookupHelper.swift
//  Marinas Search
//
//  Created by mattesona on 11/27/22.
//

import Foundation
import UIKit

/// I had some issues drawing SVG images. So I did a work around hack to not get overly burdened by this. I just downloaded each one and saved it in Assets to pull
///  This has the obvious downside that if the image address ever changes or more are added later then this will stop working.
class IconLookupHelper {
    static func lookupIcon(_ icon: String) -> UIImage? {
        switch icon {
        case "https://marinas.com/assets/map/marker_marina-61b3ca5ea8e7fab4eef2d25df94457f060498ca1a72e3981715f46d2ab347db4.svg":
            return UIImage(named: "marina")
        case "https://marinas.com/assets/map/marker_harbor-b6a4ad67eebea11fa25cccfcb58b1515b588c226eb29350fceeb52da0144b75d.svg":
            return UIImage(named: "harbor")
        case "https://marinas.com/assets/map/marker_ferry-20bb3acde367b1ea44b1d114ad0e55ef932bc473f3900585cd611e989f64780e.svg":
            return UIImage(named: "ferry")
        case "https://marinas.com/assets/map/marker_ramp-bf89640e772dbc6730ecabdef9383c853b655e6838285aeb2ddb9f651f92ffee.svg":
            return UIImage(named: "ramp")
        case "https://marinas.com/assets/map/marker_anchorage-2f24ab8edcca606182cf75e5c4941fbcb058cd442052ac1283445b75333a0dbc.svg":
            return UIImage(named: "anchorage")
        case "https://marinas.com/assets/map/marker_lock-031ad3063a02c6ae9a9e83a4b831b71e514336e5fddc42f57dd0b1b76ad4bc4f.svg":
            return UIImage(named: "lock")
        case "https://marinas.com/assets/map/marker_landmark-ea7546c4fd3808495beb2dd71648bff53b27b53775184e82de28d6b4642bfea3.svg":
            return UIImage(named: "landmark")
        case "https://marinas.com/assets/map/marker_bridge-1a891cdf787180475bf780707eb754ede507781f5d123f3d51412deda2726631.svg":
            return UIImage(named: "bridge")
        case "https://marinas.com/assets/map/marker_inlet-d52f22ecf736a694c6d25afd910be07557cc743c23d6ff101f08c7d7819af587.svg":
            return UIImage(named: "inlet")
        case "https://marinas.com/assets/map/marker_lighthouse-4c26738be58762d672a6b14b92c79485e7fb4fd5f914f91b92c46a9dcae1d0ba.svg":
            return UIImage(named: "lighthouse")
        default:
            print("Need to add missing: \(icon)")
            return nil
        }
    }
}
