//
// Created by Alexey on 11.01.2023.
//

import Combine

public protocol AuthorizationManager:ObservableObject, AnyObject {

        //Проверка результатов авторизации
        var isAuthorizationSuccessful:AnyPublisher<Bool, Never> {get}
    
        var isLoginFailed:AnyPublisher<Bool, Never> {get}

        var accessToken: String? {get}
        var tokenType:String? {get}

        //func checkAuthorization()
        /*
        var issuer:String{get set}
        var clientId:String{get set}
        var scopes:[String]{get set}
        var callbackURL:String{get set}
        */
    var authConfiguration:AuthorizationConfiguration{get set}
    var issuer:String{get set}
        func login()

        func logout()

}
/*
public class AuthorizationManagerLog:AuthorizationManager{
        public var isAuthorizationSuccessful: Combine.AnyPublisher<Bool, Never>{
                print("AuthorizationManager: Get isAuthorizationSuccessful")
                return authorizationManager.isAuthorizationSuccessful
                        .print("AuthorizationManager.isAuthorizationSuccessful")
                        .eraseToAnyPublisher()
        }
    
        public var isLoginFailed: AnyPublisher<Bool, Never>{
            print("AuthorizationManager: Get isLoginFailed")
            return authorizationManager.isLoginFailed
                    .print("AuthorizationManager.isLoginFailed")
                    .eraseToAnyPublisher()
        }

        private var authorizationManager:any AuthorizationManager
        public init(_ authorizationManager:any AuthorizationManager){
                self.authorizationManager = authorizationManager
        }
        /*public var isAuthorizationSuccessful: Combine.AnyPublisher<Bool, Never>{
                print("AuthorizationManager: Get isAuthorizationSuccessful")
                return authorizationManager.isAuthorizationSuccessful
        }*/

        public var accessToken: String?{
                print("AuthorizationManager: Get access token \(authorizationManager.accessToken ?? "token is nil")")
                return authorizationManager.accessToken
        }

        public var tokenType: String?{
                print("AuthorizationManager: Get tokenType \(authorizationManager.tokenType ?? "tokenType is nil")")
                return authorizationManager.tokenType
        }

        /*public func checkAuthorization() {
                print("checkAuthorization in AuthorizationManager")
                authorizationManager.checkAuthorization()
        }*/

    /*
        public var issuer: String{
                set{
                        print("AuthorizationManager: Set issuer \(newValue)")
                        authorizationManager.issuer = newValue
                }
                get{
                        print("AuthorizationManager: Get issuer \(authorizationManager.issuer)")
                        return authorizationManager.issuer
                }
        }

        public var clientId: String{
                set{
                        print("AuthorizationManager: Set clientId \(newValue)")
                       authorizationManager.clientId = newValue
                }
                get{
                        print("AuthorizationManager: Get clientId \(authorizationManager.clientId)")
                        return authorizationManager.clientId
                }
        }

        public var scopes: [String]{
                set {
                        print("AuthorizationManager: Set scopes \(newValue)")
                        authorizationManager.scopes = newValue
                }
                get{
                        print("AuthorizationManager: Get scopes \(authorizationManager.scopes)")
                        return authorizationManager.scopes
                }
        }

        public var callbackURL: String{
                set{
                        print("AuthorizationManager: Set callbackUrl \(newValue)")
                        authorizationManager.callbackURL = newValue
                }
                get{
                        print("AuthorizationManager: Get callbackURL \(authorizationManager.callbackURL)")
                        return authorizationManager.callbackURL
                }
        }
    */

        public func login(){
                print("AuthorizationManager: login")
                return authorizationManager.login()
        }

        public func logout(){
                print("AuthorizationManager: logout")
                return authorizationManager.logout()
        }


}
*/
