class Units::CalculationsController < ApplicationController
  def new; end

  def calculate
    if calculation_params[:property_tariff].present? && calculation_params[:units_wanted].present?
      tariff = calculation_params[:property_tariff].to_sym
      tariff_unit_cost_mapping = {
        lifeline: {
          block_1: 2.1155,
          block_2: 4.2656
        },
        domestic: {
          block_1: 3.580,
          block_2: 4.2656
        },
        home_user: { 
          block_1: 3.0858,
          block_2: 4.2656
        }
      }
      units = calculation_params[:units_wanted].to_i
      already_purchased_units = calculation_params[:already_purchased_units].to_i

      total_cost_in_rand = nil

      if units + already_purchased_units <= 600
        total_cost_in_rand = tariff_unit_cost_mapping.dig(tariff, :block_1) * units
      else 
        tier_2_units = (units + already_purchased_units) - 600
        tier_2_total = tariff_unit_cost_mapping.dig(tariff, :block_2) * tier_2_units

        tier_1_units = units - tier_2_units
        tier_1_total = tariff_unit_cost_mapping.dig(tariff, :block_1) * tier_1_units

        total_cost_in_rand = tier_1_total + tier_2_total
      end 

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
