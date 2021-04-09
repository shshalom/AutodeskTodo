# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

inhibit_all_warnings!
use_frameworks!

def common_pods
  #Reactive
  pod 'RxSwift'
  pod 'RxCocoa'
  
  #Layout
  pod 'SnapKit'
  
  #Text
  pod 'SwiftyAttributes'
  
  #Code conventions enforcer
  pod 'SwiftLint'
end

target 'AutoDeskTodo' do
  # Pods for Payments
  common_pods
  # Pods for AutoDeskTodo

  target 'AutoDeskTodoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AutoDeskTodoUITests' do
    # Pods for testing
  end

end
