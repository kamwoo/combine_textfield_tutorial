//
//  ViewController.swift
//  combine_textfield_tutorial
//
//  Created by wooyeong kam on 2021/06/06.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var passwordConfirmTextfield: UITextField!
    
    var viewModel : MyViewModel!
    
    private var mySubcriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MyViewModel()
        
        // kvo 방식으로 구독
        // 텍스트 필드에서 나가는 이벤트가 모델의 프로퍼티가 구독
        passwordTextfield
            .myTextPublisher
            .print()
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &mySubcriptions)
        
        passwordConfirmTextfield
            .myTextPublisher
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubcriptions)
        
        // 버튼이 모델의 프로퍼티를 구독
        viewModel.inMatchPasswordInput
            .print()
            // 다른 쓰레드와 함께 돌리기위해서 Runloop를 많이 사용
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: myButton )
            .store(in: &mySubcriptions)
    }

    
    
}

extension UITextField{
    var myTextPublisher : AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            // uitextfield 가져옴
            .compactMap{
                $0.object as? UITextField
            }
            // String을 가져옴
            .map{
                $0.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}


extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}
