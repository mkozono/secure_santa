module SecureSanta

  class Assigner

    MAX_TRIES = 500

    attr_reader :assignments

    def initialize(players)
      validate_input players
      @players = players
    end

    def assign_giftees
      @assignments = nil
      try_count = 0
      giftees = @players.clone
      begin
        @assignments = {}
        giftees.shuffle!
        @players.each_with_index do |player, index|
          @assignments[player] = giftees[index]
        end
        try_count += 1
        # TODO: Define exception type
        raise "Unable to assign giftees within #{MAX_TRIES} tries." if try_count >= MAX_TRIES
      end until assignments_valid?
      @assignments
    end

    private

    def assignments_valid?
      return false if @assignments.nil? || @assignments.empty?
      @assignments.each do |player, giftee|
        return false if player == giftee # self giftee
      end
      true
    end

    def validate_input(players)
      raise ArgumentError.new("players must not be nil") if players.nil?
      raise ArgumentError.new("expected Enumerable, got #{players.class}") if !players.class.include?(Enumerable)
      raise ArgumentError.new("players must not be empty") if players.empty?
      raise ArgumentError.new("there must be more than 2 players to assign") if players.size < 3
      raise ArgumentError.new("players must be unique") if players.to_a.uniq.size < players.size
    end

  end

end
