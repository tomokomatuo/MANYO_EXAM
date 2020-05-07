class User < ApplicationRecord
    has_many :tasks
    validates :email, uniqueness: true
    has_secure_password
end
