class UnitsCalculator
  UNIT_THRESHOLD = 600

  TARRIFF_UNIT_COST_MAPPING = {
    lifeline: {
      block_1: 2.3708,
      block_2: 2.3708
    },
    domestic: {
      block_1: 3.9070,
      block_2: 4.7539
    },
    home_user: { 
      block_1: 3.4351,
      block_2: 4.7539
    }
  }.freeze

  def initialize(calculation_params)
    @tariff = calculation_params[:property_tariff].to_sym
    @amount_of_units_to_buy = calculation_params[:units_wanted].to_i
    @already_purchased_units = calculation_params[:already_purchased_units].to_i
  end

  def call
    calculate_units_for_amount(tariff, already_purchased_units, amount_of_units_to_buy)
  end

  private

  attr_reader :tariff, :amount_of_units_to_buy, :already_purchased_units

  def calculate_units_for_amount(tariff, previous_units, amount)
    tariff = TARRIFF_UNIT_COST_MAPPING[tariff]
  
    # Calculate how many units are left in block_1 (up to 600 total units)
    remaining_units_in_block_1 = [UNIT_THRESHOLD - previous_units, 0].max
  
    # Calculate the total cost for remaining block_1 units
    block_1_cost = remaining_units_in_block_1 * tariff[:block_1]

    return amount / tariff[:block_2] if remaining_units_in_block_1.zero?

    # Calculate using Block 1 tariff until 600 units then calculate excess in Block 2 tariff
    if amount > block_1_cost
      total_units = block_1_cost / tariff[:block_1]

      # calculate excess units (more than 600) using block 2 tariff cost
      block_2_cost = amount - block_1_cost
      total_units += block_2_cost / tariff[:block_2]
    else
      # If the amount of units to buy is less than Block 1 cost, calculate using block 1 tariff
      total_units = amount / tariff[:block_1]
    end
  end
end
