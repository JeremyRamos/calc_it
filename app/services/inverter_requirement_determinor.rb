module InverterRequirementDeterminor
  extend self

  def call(total_wattage, battery_size)
    return [0, 0, 0] if total_wattage.to_s.start_with?('0')

    [calculate_inverter_size(total_wattage), *calculate_battery_duration(total_wattage, battery_size.to_i)]
  end

  private

  def calculate_inverter_size(total_wattage)
    inverter_size = total_wattage.to_f + (total_wattage.to_f * 0.20)
    inverter_size.ceil
  end

  def calculate_battery_duration(total_wattage, battery_size = 105, efficiency = 0.8, voltage = 12)
    # Assuming an 80% efficiency rate. An 80% efficient inverter will use (watts / 0.8) W to produce total_wattage.
    power_required = total_wattage.to_f / efficiency

    # this is the ampere a 12 volt battery will require to produce the power_required
    amp_hours = power_required / voltage

    # how long the size batter will provide power
    duration_in_hours = ((battery_size / 2) / amp_hours)

    # get hours and minutes from hours
    hours, minutes = duration_in_hours.divmod(1)
    minutes = (minutes * 60).to_i

    [hours, minutes]
  end
end
