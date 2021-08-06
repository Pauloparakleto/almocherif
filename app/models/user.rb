class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_destroy :cant_destroy

  def cant_destroy
    raise ActiveRecord::ActiveRecordError, "Aqui não cidadão!"
  end
end
