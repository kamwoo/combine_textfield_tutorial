//
//  MyViewModel.swift
//  combine_textfield_tutorial
//
//  Created by wooyeong kam on 2021/06/06.
//

import Foundation
import Combine

class MyViewModel {
    @Published var passwordInput : String = ""
    
    @Published var passwordConfirmInput : String  = ""
    
    lazy var inMatchPasswordInput : AnyPublisher<Bool,Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .map({ (password : String, passwordConfirm : String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            
            if password == passwordConfirm {
                return true
            }else{
                return false
            }
        })
        .print()
        .eraseToAnyPublisher()
}
