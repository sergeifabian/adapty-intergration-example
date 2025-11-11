import SwiftUI
import Adapty
import AdaptyUI

@Observable
final class AdaptyIntegrationContentViewModel {
  var paywallFullScreen = true
  var paywallPresented = false
  var paywallConfiguration: AdaptyUI.PaywallConfiguration?
  var shouldLoadSDK = true
  var loading = false
  var loadingError: Error?

  func setupSDK() {
    Task {
      if shouldLoadSDK {
        await MainActor.run {
          shouldLoadSDK = false
          loading = true
        }

        do {
          try await AdaptyManager.shared.setup()

          if let configuration = try await AdaptyManager.shared.loadPaywall() {
            await MainActor.run {
              paywallConfiguration = configuration
              paywallPresented = true
            }
          } else {
            print("Manager passed empty configuration")
          }

          loading = false
        } catch {
          print(error)

          loadingError = error
          loading = false
        }
      }
    }
  }

  func togglePaywallPresentation() {
    paywallPresented.toggle()
  }
}
