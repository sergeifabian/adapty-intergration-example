import Adapty
import AdaptyUI

final class AdaptyManager {
  static let shared = AdaptyManager()

  private let apiKey = ""
  private let placementId = ""

  func setup() async throws {
    do {
      let configurationBuilder = AdaptyConfiguration.builder(withAPIKey: apiKey)
      let configuration = configurationBuilder.build()
      try await Adapty.activate(with: configuration)
    } catch {
      throw AdaptyManagerError.configurationFailed(error)
    }
  }

  func loadPaywall() async throws -> AdaptyUI.PaywallConfiguration? {
    do {
      let paywall = try await Adapty.getPaywall(placementId: placementId)

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
