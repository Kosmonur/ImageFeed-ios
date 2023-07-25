//
//  AlertPresenter .swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 26.06.2023.
//

import UIKit

struct AlertOneButton {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
    
    static var notLogin: AlertOneButton {
        return AlertOneButton(title: "Что-то пошло не так(",
                              message: "Не удалось войти в систему",
                              buttonText: "ОК",
                              completion: {})
    }
}

struct AlertTwoButton {
    let title: String
    let message: String
    let button1Text: String
    let button2Text:String
    var completion1Button: () -> Void
    var completion2Button: () -> Void
    
    static var repeatOrNot: AlertTwoButton {
        return AlertTwoButton(title: "Что-то пошло не так.",
                              message: "Попробовать ещё раз?",
                              button1Text: "Повторить",
                              button2Text: "Не надо",
                              completion1Button: {},
                              completion2Button: {})
    }
    
    static var exitOrNot: AlertTwoButton {
        return AlertTwoButton(title: "Пока, пока!",
                              message: "Уверены, что хотите выйти?",
                              button1Text: "Нет",
                              button2Text: "Да",
                              completion1Button: {},
                              completion2Button: {})
    }
}



final class AlertPresenter {
    private weak var alertController: UIViewController?
    
    init(alertController: UIViewController? = nil) {
        self.alertController = alertController
    }
    
    func showAlert(alertModel: AlertOneButton) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        alertController?.present(alert, animated: true)
    }
    
    func showAlert(alertModel: AlertTwoButton) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: alertModel.button1Text, style: .cancel) { _ in
            alertModel.completion1Button()
        }
        
        let action2 = UIAlertAction(title: alertModel.button2Text, style: .default) { _ in
            alertModel.completion2Button()
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alertController?.present(alert, animated: true)
    }
}

