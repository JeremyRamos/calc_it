require 'test_helper'

class UnitsCalculatorTest < ActiveSupport::TestCase
  test '#call - when accumulitive unit amount is less than 600, it calcs using tier 1' do
    calculation_params = {
      property_tariff: 'domestic',
      units_wanted: 100,
      already_purchased_units: 300
    }

    units_calculation = UnitsCalculator.new(calculation_params).call
    assert_equal 26, units_calculation.round
  end

  test '#call - when already purchased 600 units, it calcs using tier 2' do
    calculation_params = {
      property_tariff: 'domestic',
      units_wanted: 100,
      already_purchased_units: 600
    }

    units_calculation = UnitsCalculator.new(calculation_params).call
    assert_equal 21, units_calculation.round
  end
  
  test '#call - when accumulitive unit amount is more than 600, it calcs using tier 1 and tier 2' do
    calculation_params = {
      property_tariff: 'domestic',
      units_wanted: 1000,
      already_purchased_units: 500
    }

    # amount_of_units_left_in_tier_1 = 600 - 500 = 100

    # rand_amount_for_units_remaining_for_in_tier_1 = amount_of_units_left_in_tier_1 * 3.9070 = 390.70
    # amount_of_units_left_in_tier_1_for_rand_amount = rand_amount_for_units_remaining_for_in_tier_1 / 3.9070 = 100

    # rand_amount_for_units_in_tier_2 = 1000 - 390.70 = 609.30

    # amount_of_units_left_in_tier_2_for_rand_amount = rand_amount_for_units_in_tier_2 / 4.7539 = 128.33

    units_calculation = UnitsCalculator.new(calculation_params).call
    assert_equal 228, units_calculation.round
  end
end

