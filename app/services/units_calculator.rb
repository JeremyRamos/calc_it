class UnitsCalculator
  UNIT_THRESHOLD = 600

  TARRIFF_UNIT_COST_MAPPING = {
    lifeline: {
      block_1: 2.3708,
      block_2: 2.3708
    },
    domestic: {
      block_1: 3.9070,
      # block_1: 3.9070,
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
    @units = calculation_params[:units_wanted].to_i
    @already_purchased_units = calculation_params[:already_purchased_units].to_i
  end

  def call
    [units, total_cost_in_rand]
  end

  private

  attr_reader :tariff, :units, :already_purchased_units

  def total_cost_in_rand
    return TARRIFF_UNIT_COST_MAPPING.dig(tariff, :block_1) * units if units + already_purchased_units <= UNIT_THRESHOLD

    tier_2_total = TARRIFF_UNIT_COST_MAPPING.dig(tariff, :block_2) * tier_two_units

    tier_1_total = TARRIFF_UNIT_COST_MAPPING.dig(tariff, :block_1) * tier_one_units

    tier_1_total + tier_2_total
  end

  def tier_two_units
    (units + already_purchased_units) - UNIT_THRESHOLD
  end

  def tier_one_units
    units - tier_two_units
  end
end