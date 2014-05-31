require 'sinatra'
require 'pry'
require 'pg'







=begin
  Visiting /recipes/:id will show the details for a recipe with the given ID.
  The page must include the recipe name, description, and instructions.
  The page must list the ingredients required for the recipe.
  Setup
=end

#building a sinatra application that allows users to view a list of recipes
#and make a choice of the ones that seems appetizing.

#1. Connecting to the database
def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')
      yield(connection)
  ensure
    connection.close
  end
end

#2.Getting a list of all the recipes in the databse, sorted alphabetically.
def get_recipes
  query = 'SELECT recipes.name, recipes.id FROM recipes'
  results= db_connection do |conn|
    conn.exec(query)
  end
  @results = results.sort_by {|result| result['name']}
end

def get_recipes_details(params)
  query = 'SELECT recipes.name, recipes.id, recipes.description,
  recipes.instructions,ingredients.name AS ingredient_name
  FROM recipes JOIN ingredients ON recipes.id = ingredients.recipe_id
  WHERE recipes.id = $1 '
  recipes_details = db_connection do |conn|
    conn.exec(query,[params[:id]])
  end
  @recipes_details
end

#3.This route redirects the landing page to /recipes
get '/' do
  redirect '/recipes'
end

#4.This get method gets the recipes and render index page to dipaly them.
get '/recipes' do
  get_recipes

  erb :index
end

#4.A method that gets information about the recipes and render show page
#to dipaly the output
get 'recipes/:id' do
  get_recipes_details(params) #retuns @recipes_details


  erb :show
end



















