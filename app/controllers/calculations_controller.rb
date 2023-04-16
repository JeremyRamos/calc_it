class CalculationsController < ApplicationController
  def new; end

  def calculate
    if calculation_params[:total_wattage].present?
      battery_size = calculation_params[:battery_size]
      inverter_size, hours, minutes = InverterRequirementDeterminor.call(calculation_params[:total_wattage], battery_size)
      render turbo_stream: turbo_stream.replace('results', partial: 'results', locals: { inverter_size: inverter_size, hours: hours, minutes: minutes, battery_size: battery_size })
    else
      render turbo_stream: turbo_stream.replace('results', partial: 'results', locals: { inverter_size: nil, hours: nil })
    end
  end

  private

  def calculation_params
    params.require(:calculation).permit(:total_wattage, :battery_size)
  end
end
