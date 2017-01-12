require './mdarwin.rb'

class Cromossomo < Mdarwin::Chromossome

  GENES = {
    size: 10,
    range: 0..1
  }

  def fitness
    @genes.inject(&:+)
  end

end