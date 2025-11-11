import Foundation

enum AdaptyManagerError: LocalizedError {
  case configurationFailed(Error)
  case paywallLoadingFailed(Error)

  var errorDescription: String? {
    switch self {
    case .configurationFailed(let error):
      return error.localizedDescription
    case .paywallLoadingFailed(let error):
      return error.localizedDescription
    }
  }
}
