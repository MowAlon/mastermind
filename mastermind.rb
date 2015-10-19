def show_instructions
  @response == 'i'
end

def play_game
  @response == 'p'
end

def quit
  @response == 'q'
end

def instructions
  "  *** INSTRUCTIONS ***\n
  This is how you play the game.\n
  *** END INSTRUCTIONS ***\n\n"
end

def game_intro
  "\nI have generated a beginner sequence with four elements made up of:\n(r)ed, (g)reen, (b)lue, and (y)ellow.\nUse (q)uit at any time to end the game.\n\nWhat's your guess?\n"
end

def set_game_parameters
  @game_size = 4
  @colors = %w(r g b y)
  @answer = correct_sequence
  @guess_count = 0
  @game_time = 0
  @start_time = Time.now
end

def game
  set_game_parameters
# p "Debug: #{@answer}"
  puts game_intro
  @guess = gets.chomp.downcase.chars
  @guess_count += 1

  while @guess != ['q'] && @guess != @answer
    respond_to_invalid_guess if @guess != 'q'
    puts hint

    print "Another guess? or (q)uit >>> "
    @guess = gets.chomp.downcase.chars
    @guess_count += 1
  end

  end_game if @guess == @answer
  puts "\nSorry to see you go, but thanks for playing!"
  abort
end

def hint
  "'#{@guess.join.upcase}' has #{correct_elements} of the correct elements with #{correct_positions} in the correct position(s).\nGuesses so far: #{@guess_count}\n"
end

def correct_elements
  total = 0
  guesses = @guess.group_by{|color| color}
  guesses.each{|k,v| guesses[k] = v.size}
  answers = @answer.group_by{|color| color}
  answers.each{|k,v| answers[k] = v.size}
  guesses.each do |color, guess_count|
    if !answers[color].nil?
      total += guess_count <= answers[color] ? guess_count : answers[color]
    end
  end
  total
end

def correct_positions
  total = 0
  @game_size.times do |index|
    total += 1 if @guess[index] == @answer[index]
  end
  total
end

def end_game
  puts "Congratulations! You guessed the sequence '#{@answer.join.upcase}' in #{@guess_count} guess(es) over #{(Time.now - @start_time)} seconds.\n\n Do you want to (p)lay again or (q)uit?"
  play_again = gets.chomp.downcase
  unless play_again == 'p' || play_again == 'q'
    puts "What's that? (p)lay again or (q)uit?"
    play_again = gets.chomp.downcase
  end
  game if play_again == 'p'
end

def correct_sequence
  sequence = []
  @game_size.times do
    sequence << @colors.sample
  end
  sequence
end

def respond_to_invalid_guess
  if @guess.length != @game_size
    puts "😱  I'm looking for #{@game_size} characters."
    if @guess.length < @game_size
      puts "Your guess was too short."
    else
      puts "Your guess was too long."
    end
    puts "Please try again."
  end
end

#----------------

while !quit
  puts "Welcome to MASTERMIND\n"
  puts "Would you like to (p)lay, read the (i)nstructions, or (q)uit?"
  print "> "
  @response = gets.chomp.downcase

  if play_game
    game
  elsif show_instructions
    puts instructions
  end

end
