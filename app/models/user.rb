class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :validatable
end
