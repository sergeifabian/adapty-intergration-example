enum AdaptyManagerError: Error {
  case configurationFailed(Error)
  case paywallLoadingFailed(Error)
}
