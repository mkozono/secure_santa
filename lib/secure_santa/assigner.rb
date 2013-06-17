module SecureSanta

  class Assigner

    MAX_TRIES = 500

    attr_reader :assignments

    def initialize(user_ids)
      validate_input user_ids
      @user_ids = user_ids
      @assignments = nil
    end

    def assign_giftees
      try_count = 0
      begin
        @assignments = {}
        giftee_ids = @user_ids.clone.shuffle
        @user_ids.each_with_index do |user_id, index|
          @assignments[user_id] = giftee_ids[index]
        end
        try_count += 1
        # TODO: Define exception type
        raise "Unable to assign giftees within #{MAX_TRIES} tries." if try_count >= MAX_TRIES
      end until assignments_valid?
      @assignments
    end

    private

    def assignments_valid?
      return false if self_giftee_exist?
      return true
    end

    def self_giftee_exist?
      @assignments.each do |user_id, giftee_id|
        return true if user_id.to_s == giftee_id.to_s
      end
      false
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