class CalculatorTypesController < ApplicationController
  def index
    @types_array = view_context.calculator_types_array

    respond_to do |format|
      format.html
      format.json { render json: @types_array }
    end
  end
end
