require 'mdarwin.rb'

class Populacao < Mdarwin::Population

  def best_member
    @members.sort_by { |c| c.fitness }.last
  end
end