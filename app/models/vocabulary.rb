class Vocabulary < ApplicationRecord
  has_many :terms, dependent: :destroy
  validates :name, :machine_name, presence: true
  default_scope -> { order :name }

  def term_exists?(term)
    terms.where(name: term).exists?
  end

  def self.by_name(name)
    where(machine_name: name).first
  end
end
