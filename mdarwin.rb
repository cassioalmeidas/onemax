require "securerandom"

module Mdarwin

  def self.random(range)
    SecureRandom.random_number(range)
  end

  class Chromossome
    attr_accessor :range, :size, :genes, :cal_fitness

    def initialize(options = {})
      @range = self.class::GENES.fetch(:range, options.fetch(:range, 100))
      @size = self.class::GENES.fetch(:size, options.fetch(:size, 2))
      @genes = Array(options.fetch(:genes, (1..@size).map { Mdarwin.random(@range) } ))
      @cal_fitness = 0
    end


    def &(other)
      split_point = Mdarwin.random(@size) + 1
      c1 = @genes[0, split_point] + other.genes[split_point,other.genes.length]
      c2 = other.genes[0,split_point] + @genes[split_point, other.genes.length]
      [self.class.new(genes: c1), self.class.new(genes: c2)]
    end

    def mutate!
      position = Mdarwin.random(@size)
      begin 
        value = Mdarwin.random(@range)
        old_gene = @genes[position]
        @genes[position] = value
      end while  value == old_gene

    end

    def fitness
      raise NotImplementedError, "Your class did not implement the fitness method, it should be implemented!"
    end

  end

  class Population

    attr_accessor :members, :population_size

    def initialize
      @members = Array.new
    end


    def make_generation(members)
      @members = members
      @population_size = members.size
    end

    # Return all fitness values
    def fitness_values
      @members.collect(&:fitness)
    end

    def sum_all_fitness
      fitness_values.inject(&:+)  
    end

    def count
      @members.count  
    end


    def best_member
      @members.sort_by { |m| m.fitness }.first
    end

    def average_fitness
      sum_all_fitness / @members.length.to_f
    end

    # Return all sum of fitness each of object
    def cal_fitness_all
      @members.collect(&:cal_fitness)
    end

    # Return total fitness calculed
    def total_cal_fitness
      cal_fitness_all.inject(&:+)
    end

    def roulletSelection
      rand_selection = Mdarwin.random(sum_all_fitness)
      total = 0
      @members.each_with_index do |member, index|
        total += member.fitness
        return member if total >= rand_selection || index == @members.count - 1
      end
    end

    def tournamentSelection(n)

      population_tmp = Population.new
      i = 0
      snrand = []
      begin
        nrand = Mdarwin.random(@population_size)
        if !snrand.include?(nrand)
          population_tmp.members << @members[nrand]
          snrand << nrand
          i += 1;
        end  
      end while i < n 

      population_tmp.best_member

    end

  end
end
