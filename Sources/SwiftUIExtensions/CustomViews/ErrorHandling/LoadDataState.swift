//
//  LoadDataState.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 18.04.2023.
//

import Foundation
import NetworkService
import Combine

public enum LoadDataEvent{
    case load
}
///Перечисление состояний загрузочного экрана
public enum LoadDataState{
    ///Стартовое состояние
    case start
    ///Нет соединения с интернетом
    case noInternetConnection
    ///Нет соединения с сервером
    case noConnectionToServer(message:String)
    ///Данные загружены успешно
    case dataLoadSuccessful
    ///Данные загружаются
    case loading
    
    public init(_ error:Error){
        switch error{
        case is RequestError:
            switch error as! RequestError{
            case .clientError(message: let message):
                self = .noConnectionToServer(message: "Клиентская ошибка (40х):\n\(message)")
            case .serverError(message:let message):
                self = .noConnectionToServer(message: "Серверная ошибка (500x):\n\(message)")
            case .badRequest(message: let message):
                self = .noConnectionToServer(message: "Ошибка 400:\n\(message)")
            case .unauthorized(message:let message):
                self = .noConnectionToServer(message: "Пользователь не авторизован:\n\(message)")
            case .notFound(message: let message):
                self = .noConnectionToServer(message: "Не найдено (404):\n\(message)")
            case .invalidParameters:
                self  = .noConnectionToServer(message: "Неправильные параметры запроса")
            case .noHttpResponse:
                self = .noConnectionToServer(message: "Пришел не HTTP ответ")
            case .invalidDate(message: let message):
                self = .noConnectionToServer(message: "Направильный формат даты: \(message)")
            }
        case is DecodingError:
            switch error as! DecodingError{
            case .valueNotFound(let type, let context):
                let message = "Значение не найдено " + String(describing: type) + "\n" + String(describing: context)
                self = .noConnectionToServer(message: message)
            case .dataCorrupted(let context):
                let message = "Данные повереждены\n" + String(describing: context)
                self = .noConnectionToServer(message: message)
            case .keyNotFound(let key, let context):
                let message = "Ключ не найден " + String(describing: key) + "\n" + String(describing: context)
                self  = .noConnectionToServer(message: message)
            case .typeMismatch(let type, let context):
                let message = "Несовпадение типов " + String(describing: type) + "\n" + String(describing: context)
                self = .noConnectionToServer(message: message)
            @unknown default:
                self = .noConnectionToServer(message: "Ошибка декодирования данных: \(error.localizedDescription)")
            }
        case is URLError:
                let urlError = error as! URLError
                switch urlError.errorCode{
                case URLError.cannotConnectToHost.rawValue:
                    self = .noConnectionToServer(message: "Невозможно подключиться к host")
                case URLError.timedOut.rawValue:
                    self = .noConnectionToServer(message: "Время ожидания ответа вышло")
                case URLError.notConnectedToInternet.rawValue:
                    self = .noInternetConnection
                default:
                    self = .noConnectionToServer(message: "Неожиданная ошибка:\n\(error.localizedDescription)")
            }
        default:
            self = .noConnectionToServer(message: error.localizedDescription)
        }
        
    }
    
    public init<Failure:Error>(completion: Combine.Subscribers.Completion<Failure>){
        switch completion{
        case .finished:
            self = .dataLoadSuccessful
        case .failure(let error):
            self.init(error)
        }
    }
    
//    public init(completion:Subscribers.Completion<Never>){
//        switch completion {
//        case .finished:
//            self = .dataLoadSuccessful
//        case .failure(let failure):
//            self = .init(failure)
//        }
//        
//    }
}
