//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by Brendon Crowe on 1/17/23.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    
    
    func configureCell(for recipe: Recipe) {
        recipeName.text = recipe.label
        recipeImage.getImage(with: recipe.image) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.recipeImage.image = UIImage(systemName: "exclamationmark.triangle")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.recipeImage.image = image
                }
            }
        }
    }
}
