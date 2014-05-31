SELECT recipes.name, recipes.id, recipes.descriptions, recipes.instructions
      ingredients.name FROM recipes JOIN recipes WHERE recipes.id = ingredients.recipe_id
