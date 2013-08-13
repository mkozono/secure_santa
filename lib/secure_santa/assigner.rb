module SecureSanta

  class Assigner

    MAX_TRIES = 500

    attr_reader :assignments

    def initialize(users)
      validate_input users
      @users = users
    end

    def assign_giftees
      @assignments = nil
      try_count = 0
      giftees = @users.clone
      begin
        @assignments = {}
        giftees.shuffle!
        @users.each_with_index do |user, index|
          @assignments[user] = giftees[index]
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
      @assignments.each do |user, giftee|
        return false if user == giftee # self giftee
      end
      true
    end

    def validate_input(users)
      raise ArgumentError.new("users must not be nil") if users.nil?
      raise ArgumentError.new("expected Enumerable, got #{users.class}") if !users.class.include?(Enumerable)
      raise ArgumentError.new("users must not be empty") if users.empty?
      raise ArgumentError.new("there must be more than 2 users to assign") if users.size < 3
      raise ArgumentError.new("users must be unique") if users.to_a.uniq.size < users.size
    end

  end

end