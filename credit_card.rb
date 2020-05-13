require 'thor' # gem install thor; if you dont have installed

# Usage: 
#       ruby credit_card.rb validate CREDIT_CARD_NUMBER
# Example: ruby credit_card.rb validate 4111111111111111
#          ruby credit_card.rb validate '5105 1051 0510 5106'
# For Help:
#       ruby credit_card.rb 

module ModuleCreditCardHelper
    # Calculates the sum the credit card number
    def self.check_sum(number)
        sum = 0
        number.reverse.split("").each_with_index do |num, i|
            if((i+1)%2 == 0)
                aux = (num.to_i*2).to_s
                aux.length > 1 ? sum += aux[0].to_i+aux[1].to_i : sum+=aux.to_i
            else
                sum+=num.to_i
            end
        end
        sum %10 == 0 ? "valid" : "invalid"
    end

    # Check the type of the credit card number
    def self.check_type(number)
        num2 = number.slice(0,2)
        if (num2 == '34' || num2 == '37') && number.length == 15
            return {status: :success, type: "AMEX"}
        elsif [*51..55].include?(num2.to_i) && number.length == 16
            return {status: :success, type: "MasterCard"}
        elsif number.slice(0,4) == '6011' && number.length == 16
            return {status: :success, type: "Discover"}
        elsif number[0] == '4' && (number.length == 13 || number.length == 16)
            return {status: :success, type: "VISA"}
        end
        {status: :error, type: "Unknown"}
    end 
end

class CreditCard < Thor
    include ModuleCreditCardHelper
    class_option :verbose, :type => :boolean, :aliases => "-v"

    desc "validate CREDIT_CARD_NUMBER", "Check if the number of the credit card it's valid"
    def validate(credit_card_number)
        # In case that the credit card contains spaces, this removes the spaces
        number = credit_card_number.split(" ").join("")
        
        # Make sure that credit card number only contains numbers and is not empty
        if number.to_s.match(/\D/) || number.length == 0
            puts "Error of Character, the Credit Card number has to only contains NUMBERS" 
            return "Error of Character"
        end
        
        credit_card = { type: "",  number: number, validation: ""}
        
        getting_type = ModuleCreditCardHelper.check_type(number)
        case getting_type[:status]
        when :error 
            puts "#{getting_type[:type]}: #{number} (invalid)"
            return "#{getting_type[:type]}: #{number} (invalid)"
        when :success
            credit_card[:type] = getting_type[:type]
            credit_card[:validation] = ModuleCreditCardHelper.check_sum(number)
            puts "#{credit_card[:type]}: #{credit_card[:number]} (#{credit_card[:validation]})"
            return "#{credit_card[:type]}: #{credit_card[:number]} (#{credit_card[:validation]})"
        end
    end

    def self.exit_on_failure?
        puts "Command not found. Please check the syntax"
    end
end

CreditCard.start(ARGV)