require "test/unit"
require_relative './credit_card'

class CreditCardTest < Test::Unit::TestCase
    include ModuleCreditCardHelper

    # Check types of credit cards
    def test_types
        cards_list = [
            {type: "VISA", status: :success, number: '4111111111111111'},
            {type: "VISA", status: :success, number: '4111111111111'},
            {type: "VISA", status: :success, number: '4012888888881881'},
            {type: "AMEX", status: :success, number: '378282246310005'},
            {type: "Discover", status: :success, number: '6011111111111117'},
            {type: "Unknown", status: :error, number: '9111111111111111'},
            {type: "MasterCard", status: :success, number: '5105105105105106'},
            {type: "Unknown", status: :error, number: '5105 1051 0510 5106'},
        ]
        cards_list.each do |card|
            assert_equal(Hash, ModuleCreditCardHelper.check_type(card[:number]).class)
            assert_equal(card[:status], ModuleCreditCardHelper.check_type(card[:number])[:status])
            assert_equal(card[:type], ModuleCreditCardHelper.check_type(card[:number])[:type])
        end
    end

    # Check the sum of numbers cards
    def test_numbers
        assert_equal("valid", ModuleCreditCardHelper.check_sum('4111111111111111'))
        assert_equal("invalid", ModuleCreditCardHelper.check_sum('9111111111111111'))
        assert_equal("valid", ModuleCreditCardHelper.check_sum('911111111111111'))
        assert_equal("valid", ModuleCreditCardHelper.check_sum('378282246310005'))
        assert_equal("valid", ModuleCreditCardHelper.check_sum('5105105105105100'))
        assert_equal("invalid", ModuleCreditCardHelper.check_sum('5105 1051 0510 5106'))
        assert_equal("invalid", ModuleCreditCardHelper.check_sum('5105 1051 0510 5100'))
        assert_equal("invalid", ModuleCreditCardHelper.check_sum('5105105105105106'))
    end

    # Check validation from some cards
    def test_cards
        assert_equal('VISA: 4111111111111111 (valid)', CreditCard.new().validate('4111111111111111') )
        assert_equal('VISA: 4111111111111 (invalid)', CreditCard.new().validate('4111111111111') )
        assert_equal('VISA: 4012888888881881 (valid)', CreditCard.new().validate('4012888888881881') )
        assert_equal('AMEX: 378282246310005 (valid)', CreditCard.new().validate('378282246310005') )
        assert_equal('Discover: 6011111111111117 (valid)', CreditCard.new().validate('6011111111111117') )
        assert_equal('MasterCard: 5105105105105100 (valid)', CreditCard.new().validate('5105105105105100') )
        assert_equal('MasterCard: 5105105105105106 (invalid)', CreditCard.new().validate('5105 1051 0510 5106') )
        assert_equal('Unknown: 9111111111111111 (invalid)', CreditCard.new().validate('9111111111111111') )

        assert_equal('MasterCard: 5155327746759207 (valid)', CreditCard.new().validate('5155327746759207') )
        assert_equal('Discover: 6011951670514932 (valid)', CreditCard.new().validate('6011951670514932') )
        assert_equal('Unknown: 515527746759207 (invalid)', CreditCard.new().validate('515527746759207') )
        
        assert_equal('Error of Character', CreditCard.new().validate('911111eqweweeqw1111111111') )
        assert_equal('Error of Character', CreditCard.new().validate('') )
        assert_equal('Error of Character', CreditCard.new().validate('312;3"11232-30eqwe09qw8093812') )
        assert_equal('AMEX: 378282246310005 (valid)', CreditCard.new().validate('3782    82246310005') )
        assert_equal('Error of Character', CreditCard.new().validate('ddjoidj1o2ij312j312oi3') )
    end
end