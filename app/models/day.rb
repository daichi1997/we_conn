# app/models/day.rb
class Day < ActiveHash::Base
  self.data = (1..31).map { |day| { id: day, name: "#{day}日" } }
end
