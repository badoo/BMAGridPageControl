source 'https://github.com/CocoaPods/Specs.git'

workspace 'BMAGridPageControl.xcworkspace'
xcodeproj 'BMAGridPageControl.xcodeproj'
xcodeproj 'BMAGridPageControlExample.xcodeproj'

platform :ios, '7.0'

target 'BMAGridPageControlExample', :exclusive => true do
  pod 'TLLayoutTransitioning'
  xcodeproj 'BMAGridPageControlExample.xcodeproj'
end

target 'BMAGridPageControlTests', :exclusive => true do
  pod 'OCMock'
  xcodeproj 'BMAGridPageControl.xcodeproj'
end
