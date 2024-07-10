class Units::CalculationsController < ApplicationController
  def new; end

  def calculate
    if calculation_params[:property_tariff].present? && calculation_params[:units_wanted].present?
      units, total_cost_in_rand = UnitsCalculator.new(calculation_params).call

      render turbo_stream: turbo_stream.replace('results', partial: 'results', locals: { units: units, total_cost_in_rand: total_cost_in_rand})
    else
      render turbo_stream: turbo_stream.replace('results', partial: 'results', locals: { units: nil, total_cost_in_rand: nil})
    end
  end

  private

  def calculation_params
    params.require(:calculation).permit(:property_tariff, :units_wanted, :already_purchased_units)
  end
end
