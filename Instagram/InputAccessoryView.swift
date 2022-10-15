//
//  InputAccessoryView.swift
//  Instagram
//
//  Created by 和泉淳子 on 2022/10/12.
//

import UIKit

class InputAccessoryView: UIView {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            loadNib()
            setupViews()
            autoresizingMask = .flexibleHeight
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

    // MARK: - setup nib
    private extension InputAccessoryView {
        func loadNib() {
            let nib = UINib(nibName: String(describing: InputAccessoryView.self), bundle: nil)
            guard let view = nib.instantiate(withOwner: self,
                                             options: nil).first as? UIView else { return }
            view.frame = self.bounds
            self.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            self.addSubview(view)
        }
    }

    // MARK: - setup views
    private extension InputAccessoryView {
        func setupViews() {
            textView.layer.cornerRadius = 15
            sendButton.layer.cornerRadius = 15
            //sendButton.isEnabled = false
        }
        
        internal override var intrinsicContentSize: CGSize{
            return .zero
        }

}
