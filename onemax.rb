require './populacao.rb'
require './cromossomo.rb'

TAM_POPULACAO = 100
TAM_GERACOES = 1000
T_MUTACAO = 0.2
T_CRUZ = 0.4

populacao = Populacao.new
cromossomos = []
TAM_POPULACAO.times { cromossomos << Cromossomo.new }
populacao.make_generation(cromossomos)


TAM_GERACOES.times do |geracao|
  descendencia = Populacao.new

  while descendencia.count < populacao.count do
    p1 = populacao.tournamentSelection(2)
    p2 = populacao.tournamentSelection(2)


    if rand <= T_CRUZ
      c1, c2 = p1 & p2
    else
      c1, c2 = p1, p2
    end

    if  rand <= T_MUTACAO
      c1.mutate!
      c2.mutate!
    end

    descendencia.members << c1 << c2
  end
  puts "Geracao #{geracao} - média fitness: #{populacao.average_fitness} - Melhor: #{populacao.best_member.genes}"
  if populacao.best_member.fitness == Cromossomo::GENES[:size]
    exit
  end
  populacao = descendencia
end
