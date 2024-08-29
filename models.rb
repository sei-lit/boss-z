require 'bundler/setup'
require 'bcrypt'
Bundler.require

ActiveRecord::Base.establish_connection

class Users < ActiveRecord::Base
    has_secure_password
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    validates :name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, format: {
        with: /\A(?=.*[a-zA-Z])(?=.*\d).+\z/, 
        message: "must include both letters and numbers" 
    }
end

class Posts < ActiveRecord::Base 
    has_many :comments, dependent: :destroy
    belongs_to :users
end

class Comments < ActiveRecord::Base 
    belongs_to :users
    belongs_to :comments
end