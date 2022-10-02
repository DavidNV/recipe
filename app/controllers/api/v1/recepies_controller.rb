class Api::V1::RecepiesController < ApplicationController
  VALID_PARAMS = [:title, :making_time, :serves, :ingredients, :cost].freeze

  def index
    recipies = Recipe.all
    parsed_recipies = recipies.map do |r|
      r.as_json.merge(links: {
        _self: "/api/v1/recepies/#{r.id}"
      })
    end
    render json: {recipies: parsed_recipies}, status: 200
  end

  def show
    id = params[:id] || 1
    recipe = Recipe.find_by(id: id)
    render json: recipe, status: 200
  end

  def update
    id = params[:id] || 1
    recipe = Recipe.find_by(id: id)
    result = recipe.update(permitted_params)
    recipe.reload
    render json: recipe, status: 200
  end

  def delete
    id = params[:id]
    recipe = Recipe.find_by(id: id)
    if recipe
      recipe.delete
      render json: {message: "Recipe succesfully removed!"}, status: 400
    else
      render json: {message: "No recipe found"}, status: 400
    end
  end

  def create
    recipe = Recipe.new(permitted_params)
    if recipe.valid? && recipe.save
      response = {
        message: "Recipe successfully created!",
        recipe: [ recipe.as_json ]
      }
      render json: response, status: 200
    else
      render json: { 
        message: "Recipe successfully failed!",
        required: VALID_PARAMS.join(',')
      }
    end
  end

  private

  def permitted_params
    params.permit(*VALID_PARAMS)
  end

end
