class CalculationsController < ApplicationController
  def new; end

  def calculate
    if calculation_params[:total_wattage].present?
      inverter_size, hours, minutes = InverterRequirementDeterminor.call((calculation_params[:total_wattage]))
      render turbo_stream: turbo_stream.replace('results', partial: 'results', locals: { inverter_size: inverter_size, hours: hours, minutes: minutes })
    else
      render turbo_stream: turbo_stream.replace('results', partial: 'results', locals: { inverter_size: nil, hours: nil })
    end
  end

  private

  def calculation_params
    params.require(:calculation).permit(:total_wattage)
  end
end
