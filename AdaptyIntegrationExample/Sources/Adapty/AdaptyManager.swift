import Adapty
import AdaptyUI

final class AdaptyManager {
  static let shared = AdaptyManager()

  private let API_KEY = ""
  private let PLACEMENT_ID = ""

  func setup() async throws {
    do {
      let configurationBuilder = AdaptyConfiguration.builder(withAPIKey: API_KEY)
      let configuration = configurationBuilder.build()
      try await Adapty.activate(with: configuration)
      try await AdaptyUI.activate()
    } catch {
      throw AdaptyManagerError.configurationFailed(error)
    }
  }

  func loadPaywall() async throws -> AdaptyUI.PaywallConfiguration? {
    do {
      let paywall = try await Adapty.getPaywall(placementId: PLACEMENT_ID)

      if paywall.hasViewConfiguration {
        return try await AdaptyUI.getPaywallConfiguration(forPaywall: paywall)
      } else {
        return nil
      }
    } catch {
      throw AdaptyManagerError.paywallLoadingFailed(error)
    }
  }
}
