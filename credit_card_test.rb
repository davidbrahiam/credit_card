require "test/unit"
require_relative './credit_card'

class CreditCardTest < Test::Unit::TestCase
    def test_cards
        assert_equal('VISA: 4111111111111111 (valid)', CreditCard.new().validate('4111111111111111') )
        assert_equal('VISA: 4111111111111 (invalid)', CreditCard.new().validate('4111111111111') )
        assert_equal('VISA: 4012888888881881 (valid)', CreditCard.new().validate('4012888888881881') )
        assert_equal('AMEX: 378282246310005 (valid)', CreditCard.new().validate('378282246310005') )
        assert_equal('Discover: 6011111111111117 (valid)', CreditCard.new().validate('6011111111111117') )
        assert_equal('MasterCard: 5105105105105100 (valid)', CreditCard.new().validate('5105105105105100') )
        assert_equal('MasterCard: 5105105105105106 (invalid)', CreditCard.new().validate('5105 1051 0510 5106') )
        assert_equal('Unknown: 9111111111111111 (invalid)', CreditCard.new().validate('9111111111111111') )
    end
end