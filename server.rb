require 'sinatra'
require 'pry'
require 'pg'

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
  query = 'SELECT recipes.name, recipes.id FROM recipes LIMIT 20 OFFSET "#{offset}'
  results= db_connection do |conn|
    conn.exec(query)
  end
  @results = results.sort_by {|result| result['name']}
end

#Getting the recipe details from the database
def get_recipes_details(params)
  query = 'SELECT recipes.name, recipes.id, recipes.description,
  recipes.instructions,ingredients.name AS ingredient_name
  FROM recipes JOIN ingredients ON recipes.id = ingredients.recipe_id
  WHERE recipes.id = $1 '
  recipes_details = db_connection do |conn|
    conn.exec_params(query,[params[:id]])
  end
  @recipes_details = recipes_details
end

#3.This route redirects the landing page to /recipes
get '/' do
  redirect '/recipes'
end

#4.This get method gets the recipes and render index page to dipaly them.
get '/recipes' do
  #paginating the list of recipes
  @page = params[:page] || 1
  @page = @page.to_i
  offset = (@page-1) * 20

  query = "SELECT recipes.name, recipes.id FROM recipes LIMIT 20 OFFSET #{offset}"
  results= db_connection do |conn|
    conn.exec(query)
  end
  @results = results.sort_by {|result| result['name']}



  erb :index
end

#4.get method that gets information about the recipes and render show page
#to dipaly the output
get '/recipes/:id' do
  get_recipes_details(params)#returns @recipes_details

  erb :'show'
end



















