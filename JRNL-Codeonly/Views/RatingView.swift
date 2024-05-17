//
//  RatingView.swift
//  JRNL-Codeonly
//
//  Created by 어재선 on 5/17/24.
//

import UIKit

class RatingView: UIStackView {
    private var ratingButtons: [UIButton] = []
    var rating = 0 {
        didSet {
            updateButtonSelectionsStates()
        }
    }
    private let buttonSzie = CGSize(width: 44, height: 44)
    private let buttonCount = 5
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        for button in ratingButtons {
            
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        let filledStar = UIImage(systemName: "star.fill")
        let emptyStar = UIImage(systemName: "star")
        let highlightStar = UIImage(systemName: "star.fill")? .withTintColor(.red,
                                                                             renderingMode: .alwaysOriginal)
        
        for _ in 0..<buttonCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightStar, for: .highlighted)
            button.setImage(highlightStar, for: [.highlighted, .selected])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(ratingButtontapped(button:)), for: .touchDown)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    private func updateButtonSelectionsStates(){
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
        
    }
    
    @objc func ratingButtontapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }

    
}
