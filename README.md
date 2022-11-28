# README

Small demo app which searches through Point data 

# Build with...

- Xcode 14.1
- Targeted: iPhone 14 sim, iPhone 14 ProMax(physical)

# How to Run

This project only has one target, `Marinas Search`. Open in Xcode and Run. There are no additional dependencies outside of what is provided by Xcode by default.

# Caveats

- Only tested on iPhone 14 simulator and iPhone 14ProMax (physical device)
- Doesn't cache any of the searches.
- The point kind icon is stored on the server as a SVG and XCode doesn't support these very well. I was running into issues trying to get a 3rd party library to pull these in so I resorted to a bit of hackery. Since there was a very small limited set of these, I just downloaded and put them in the Assets to use.
- Included is the Unit Test and UITest folders but I didn't add any tests.

# Example run

![Alt Text](test.gif)