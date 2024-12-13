# frozen_string_literal: true

# These problems are a system of equations (thanks Reddit) boy am I stupid

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
      X: parts[2].split('X=')[1].split(', ')[0].to_i + 10_000_000_000_000,
      Y: parts[2].split('Y=')[1].to_i + 10_000_000_000_000
    }
  }
end

cost = 0
input = File.read(File.join(File.dirname(__FILE__), 'sample.txt'))

games = input.split("\n\n").map { |g| parse_game(g) }

# Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400
games.each do |game|
  lcm = game[:A][:X].lcm(game[:A][:Y]) # 94.lcm(34) == 1598
  x_coefficient = lcm / game[:A][:X] # 1598 / 94 == 17
  y_coefficient = lcm / game[:A][:Y] # 1598 / 34 == 47

  game[:A][:X] *= x_coefficient # 94 * 17 == 1598
  game[:B][:X] *= x_coefficient # 22 * 17 == 374
  game[:Prize][:X] *= x_coefficient # 8400 * 17 == 142800

  game[:A][:Y] *= y_coefficient # 34 * 47 == 1598
  game[:B][:Y] *= y_coefficient # 67 * 47 == 3149
  game[:Prize][:Y] *= y_coefficient # 5400 * 47 == 253800

  bs = (game[:Prize][:X] - game[:Prize][:Y]) / (game[:B][:X] - game[:B][:Y]) # (142800 - 253800) / (374 - 3149) == 40
  as = (game[:Prize][:X] - game[:B][:X] * bs) / game[:A][:X] # (142800 - 374 * 40) / 1598 == 80

  next unless game[:Prize][:X] == game[:A][:X] * as + game[:B][:X] * bs && game[:Prize][:Y] == game[:A][:Y] * as + game[:B][:Y] * bs

  cost += (as * 3) + bs
end

puts cost
