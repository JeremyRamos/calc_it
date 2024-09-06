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
    calculation_params = calculation_params
    @tariff = calculation_params[:property_tariff].to_sym
    @amount_of_units_to_buy = calculation_params[:units_wanted].to_i
    @already_purchased_units = calculation_params[:already_purchased_units].to_i
  end

  def call
    amount_of_units_to_buy / TARRIFF_UNIT_COST_MAPPING.dig(tariff, determine_block_tier)
  end

  private

  attr_reader :tariff, :amount_of_units_to_buy, :already_purchased_units

  def determine_block_tier
    return :block_1 if already_purchased_units <= UNIT_THRESHOLD

    :block_2
  end
end
