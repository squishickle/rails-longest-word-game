require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(9)
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @grid = params[:grid]
    @attempt = params[:attempt]
    @score = final_score(@end_time).round(2)
    if included?(@grid, @attempt)
      if real_word?(@attempt)
        @response = "Correct! Your time: #{@score} seconds"
      else
        @response = "Nope, #{@attempt} is not a real word."
      end
    else
      @response = "Those letters are not in the grid."
    end
  end

  def included?(grid, attempt)
    attempt.chars.all? do |letter|
      attempt.count(letter) <= grid.chars.count(letter)
    end
  end

  def real_word?(attempt)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def final_score(end_time)
    end_time - params[:start_time].to_time
  end
end
