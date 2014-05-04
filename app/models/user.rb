class User < ActiveRecord::Base
  devise :omniauthable, :registerable
end
