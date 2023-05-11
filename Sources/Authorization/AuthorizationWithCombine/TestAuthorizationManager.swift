//
// Created by Alexey on 17.01.2023.
//

import AppAuth
import Combine

struct OpenIDConfiguration {
    var issuer: URL
    var clientID: String
    var scope: String
    var redirectURL: URL
}

protocol AuthStateStorage {
    var state: OIDAuthState? { get set }
}



// Convenience …
internal func futureProofError(_ error: Error?) -> Error {
    guard let error = error else {
        return AuthError.shouldNeverHappen
    }
    return error
}

public class AppAuthenticator: NSObject, ObservableObject {
    var client: OpenIDConfiguration
    var tokenStorage: AuthStateStorage?

    private var authState: OIDAuthState? {
        didSet {
            authState?.stateChangeDelegate = self
        }
    }

    // Variables we need to store asynchronous tasks
    private var authSession: OIDExternalUserAgentSession?
    private var cancellables = Set<AnyCancellable>()

    init(client: OpenIDConfiguration, tokenStorage: AuthStateStorage?) {
        self.client = client
        self.tokenStorage = tokenStorage

        self.authState = tokenStorage?.state
    }

    // MARK: -
    // MARK: This is where the cookie crumbles
    public func accessToken() -> AnyPublisher<String, Error> {

        return AppAuthenticator.performActionWithFreshToken(authState: authState)
                .catch { (error: Error) -> AnyPublisher<String, Error> in
                    debugPrint("ⓘ Full login required")

                    return self.fullLoginWithDiscovery()
                }
                .eraseToAnyPublisher()
    }

    // MARK: -
    // MARK: Futures for AppAuth methods
    internal static func discoverFuture(issuer: URL) -> Future<OIDServiceConfiguration, Error> {
        return Future { promise in
            OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
                guard let configuration = configuration else {
                    promise(.failure(futureProofError(error)))
                    return
                }

                promise(.success(configuration))

            }
        }
    }

    internal func authWithAutoCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String? = nil, redirectURL: URL) -> Future<OIDAuthState, Error> {

        return Future { promise in
            let request = OIDAuthorizationRequest(
                    configuration: configuration,
                    clientId: clientID,
                    clientSecret: clientSecret,
                    scopes: [OIDScopeOpenID, OIDScopeProfile],
                    redirectURL: redirectURL,
                    responseType: OIDResponseTypeCode,
                    additionalParameters: nil)

            DispatchQueue.main.async {
                guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
                    promise(.failure(AuthError.noViewController))
                    return
                }

                self.authSession = OIDAuthState.authState(byPresenting: request, presenting: viewController, callback: { (authState, error) in
                    guard let authState = authState else {
                        promise(.failure(futureProofError(error)))
                        return
                    }

                    promise(.success(authState))

                })
            }
        }
    }

    internal static func exchangeIDMTokenFuture(refreshToken: String?, configuration: OIDServiceConfiguration, clientID: String, scope: String) -> Future<OIDTokenResponse, Error> {

        return Future { promise in

            guard let refreshToken = refreshToken else {
                promise(.failure(AuthError.invalidGrant))
                return
            }

            let exchangeRequest = OIDTokenRequest(
                    configuration: configuration,
                    grantType: OIDGrantTypeRefreshToken,
                    authorizationCode: nil,
                    redirectURL: nil,
                    clientID: clientID,
                    clientSecret: nil,
                    scope: scope,
                    refreshToken: refreshToken,
                    codeVerifier: nil,
                    additionalParameters: nil)

            OIDAuthorizationService.perform(exchangeRequest) {
                tokenResponse, error in
                guard let tokenResponse = tokenResponse else {
                    if let error = error as NSError?,
                       error.domain == OIDOAuthTokenErrorDomain,
                       error.code == OIDErrorCodeOAuth.invalidGrant.rawValue {
                        promise(.failure(AuthError.invalidGrant))
                    } else {
                        promise(.failure(futureProofError(error)))
                    }
                    return
                }

                promise(.success(tokenResponse))
            }
        }
    }

    internal static func performActionWithFreshToken(authState: OIDAuthState?) -> Future<String, Error> {
        return Future { promise in
            guard let authState = authState else {
                promise(.failure(AuthError.noPreviousAuthState))
                return
            }
            debugPrint("ⓘ using existing authState")

            authState.performAction { (accessToken, idToken, error) in

                guard let accessToken = accessToken else {
                    promise(.failure(futureProofError(error)))
                    return
                }

                debugPrint("ⓘ accessToken acquired")
                promise(.success(accessToken))
            }
        }
    }

    // MARK: -
    // MARK: Combine helper methods
    internal func exchangeScope(configuration: OIDServiceConfiguration) -> AnyPublisher<String, Error> {

        let authState = self.authState?.refreshToken

        return AppAuthenticator.exchangeIDMTokenFuture(refreshToken:
                authState,
                        configuration: configuration,
                        clientID: self.client.clientID,
                        scope: self.client.scope
                )
                .tryMap { (tokenResponse) -> String in
                    guard let accessToken = tokenResponse.accessToken else {
                        throw AuthError.shouldNeverHappen
                    }
                    debugPrint("ⓘ successful refresh")

                    self.authState?.update(with: tokenResponse, error: nil)
                    self.tokenStorage?.state = self.authState
                    return accessToken
                }
                .eraseToAnyPublisher()
    }

    internal func codeAndScopeExchange(configuration: OIDServiceConfiguration) -> AnyPublisher<String, Error> {
        return self.authWithAutoCodeExchange(configuration: configuration,
                        clientID: client.clientID,
                        redirectURL:
                        client.redirectURL)
                .map { authState -> AnyPublisher<String, Error> in
                    self.authState = authState
                    self.saveState()
                    return self.exchangeScope(configuration: configuration)
                }
                .switchToLatest()
                .eraseToAnyPublisher()
    }

    internal func fullLoginWithDiscovery() -> AnyPublisher<String, Error> {
        return AppAuthenticator.discoverFuture(issuer: self.client.issuer)
                .flatMap { [self] configuration in
                    self.codeAndScopeExchange(configuration: configuration)
                }
                .eraseToAnyPublisher()
    }

    // MARK: -
    // MARK: Persistence Methods
    internal func saveState() {
        self.tokenStorage?.state = authState
    }
}

//MARK: -
//MARK: OIDAuthState Delegate
extension AppAuthenticator: OIDAuthStateChangeDelegate {

    public func didChange(_ state: OIDAuthState) {
        debugPrint("ⓘ Auth State did change")
        self.saveState()
    }
}
