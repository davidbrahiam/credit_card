
# Credit Card Exercise

This repository is used for check if a credit card number is ``valid`` or ``invalid``.

This is the list of credit cards allowed
```
+============+=============+===============+
| Card Type  | Begins With | Number Length |
+============+=============+===============+
| AMEX       | 34 or 37    | 15            |
+------------+-------------+---------------+
| Discover   | 6011        | 16            |
+------------+-------------+---------------+
| MasterCard | 51-55       | 16            |
+------------+-------------+---------------+
| Visa       | 4           | 13 or 16      |
+------------+-------------+---------------+
```

All the code is on ``credit_card.rb``.

It's used ``thor`` gem for help to use the code. 

## First Step
Clone the repository on your environment.

``git clone https://github.com/davidbrahiam/credit_card.git``

Install the gem's with ``bundler install`` 

### How to use
You can run it as ``ruby credit_card.rb validate CREDIT_CARD_NUMBER``.

For example: ``ruby credit_card.rb validate 4111111111111111``.

### Preview Tests
There is some tests already done for you check how it works.

You can run the tests with ``ruby credit_card_test.rb``.

## How it works
The code contains a method ``validate`` which makes the validation of determined credit card number.

```ruby
def  validate(credit_card_number)
	# Make sure that credit card number only contains numbers and spaces
	return  puts  "Error of Character, the Credit Card number has to only contains NUMBERS"  if  credit_card_number.to_s.match(/\D.\s/)
	# In case that the credit card contains spaces, this removes the spaces
	number = credit_card_number.split(" ").join("")
	credit_card = { type:  "", number:  number, validation:  ""}
	getting_type = check_type(number)
	case  getting_type[:status]
	when  :error
		puts  "Unknown: #{number} (invalid)"
		return  "Unknown: #{number} (invalid)"
	when  :success
		credit_card[:type] = getting_type[:type]
		credit_card[:validation] = check_sum(number)
		puts  "#{credit_card[:type]}: #{credit_card[:number]} (#{credit_card[:validation]})"
		return  "#{credit_card[:type]}: #{credit_card[:number]} (#{credit_card[:validation]})"
	end
end
```

The method ``validate`` contains the method ``check_type`` which checks if exists the type of the number.

if it does, then is returned the type of the credit card, else the credit card is assigned as an unknown type.

```ruby
# Check the type of the credit card number
def  check_type(number)
	num2 = number.slice(0,2)
	if (num2 == '34' || num2 == '37') && number.length == 15
		return {status:  :success, type:  "AMEX"}
	elsif [*51..55].include?(num2.to_i) && number.length == 16
		return {status:  :success, type:  "MasterCard"}
	elsif  number.slice(0,4) == '6011' && number.length == 16
		return {status:  :success, type:  "Discover"}
	elsif  number[0] == '4' && (number.length == 13 || number.length == 16)
		return {status:  :success, type:  "VISA"}
	end
	{status:  :error}
end
```

The last verification done is check if the credit card number is ``valid`` or ``invalid``.

The ``check_sum`` method consist on a sum numbers from the credit card, the number is doubled for those numbers which starting with the next to last digit and continuing with every other digit going back to the beginning of the card.

If the number is greater than 9, then sums every digit.

After that, if the total sum is divisible by 10 (without rest), then is a ``valid`` number, else is an ``invalid`` number.

```ruby
# Calculates the sum the credit card number
def  check_sum(number)
	sum = 0
	number.reverse.split("").each_with_index  do |num, i|
		if((i+1)%2 == 0)
			aux = (num.to_i*2).to_s
			aux.length > 1 ? sum += aux[0].to_i+aux[1].to_i : sum+=aux.to_i
		else
			sum+=num.to_i
		end
	end
	sum %10 == 0 ? "valid" : "invalid"
end
```

### Contact
You can open an issue or sent me a message by email throw ``dbrahiam@gmail.com``.
If you prefer a call, this is my number ``(+34) 623033964``.