# frozen_string_literal: true

def parse_game(game)
  parts = game.split("\n")
  {
    A: {
      X: parts[0].split('X+')[1].split(', ')[0].to_i,
      Y: parts[0].split('Y+')[1].to_i
    },
    B: {
      X: parts[1].split('X+')[1].split(', ')[0].to_i,
      Y: parts[1].split('Y+')[1].to_i
    },
    Prize: {
      X: parts[2].split('X=')[1].split(', ')[0].to_i,
      Y: parts[2].split('Y=')[1].to_i
    },
    Result: {
      A: nil,
      B: nil
    }
  }
end

cost = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))

games = input.split("\n\n").map { |g| parse_game(g) }

games.each do |game|
  bs = 0
  as = 0

  # try all B until match or bust
  bs += 1 while game[:B][:X] * bs < game[:Prize][:X] && game[:B][:Y] * bs < game[:Prize][:Y]

  if game[:B][:X] * bs == game[:Prize][:X] && game[:B][:Y] * bs == game[:Prize][:Y]
    game[:Result][:B] = bs
    next
  end

  max_bs = bs
  max_bs.times do
    bs -= 1
    as += 1 while game[:B][:X] * bs + game[:A][:X] * as < game[:Prize][:X] && game[:B][:Y] * bs + game[:A][:Y] * as < game[:Prize][:Y]
    next unless game[:B][:X] * bs + game[:A][:X] * as == game[:Prize][:X] && game[:B][:Y] * bs + game[:A][:Y] * as == game[:Prize][:Y]

    game[:Result][:B] = bs
    game[:Result][:A] = as
    break
  end

  next if game[:B][:X] * bs + game[:A][:X] * as == game[:Prize][:X] && game[:B][:Y] * bs + game[:A][:Y] * as == game[:Prize][:Y]

  as += 1 while game[:A][:X] * as < game[:Prize][:X] && game[:A][:Y] * as < game[:Prize][:Y]

  game[:Result][:A] = as if game[:A][:X] * as == game[:Prize][:X] && game[:A][:Y] * as == game[:Prize][:Y]
end

games.each do |game|
  next if game[:Result][:A].nil? && game[:Result][:B].nil?

  cost += game[:Result][:A] * 3 + game[:Result][:B]
end

puts cost
