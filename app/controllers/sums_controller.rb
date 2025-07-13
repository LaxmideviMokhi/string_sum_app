class SumsController < ApplicationController
	def create
  		input = params[:input]
  		sum = add_numbers_from_string(input)
  		render json: { sum: sum }
		rescue ArgumentError => e
  		render json: { error: e.message }, status: :unprocessable_entity
	end

  	private

  	def add_numbers_from_string(str)
  		return 0 if str.blank?

 		numbers = str.scan(/-?\d+/).map(&:to_i)
  		negatives = numbers.select { |n| n < 0 }

  		if negatives.any?
    		raise ArgumentError.new("negative numbers are not allowed: #{negatives.join(', ')}")
  		end

  		numbers.reject { |n| n >= 1000 }.sum
	end
end
