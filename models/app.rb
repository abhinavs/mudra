class App < ActiveRecord::Base
  include Mudra::Record
  extend Mudra::KeyGenerator

  DELETED = 'deleted'
  ACTIVE  = 'active'

  validates_presence_of   :name, :status, :api_key
  validates_uniqueness_of :guid, :allow_nil => true
  validates_uniqueness_of :api_key
  validates_length_of     :guid, :maximum => 30
  validates_length_of     :name, :maximum => 30

  has_many  :users
  has_many  :transactions

  attr_protected :api_key, :status, :created_at, :updated_at
  before_validation :set_default_values, :on => :create

  def self.accessible_keys
    ['name', 'guid', 'description']
  end

  def authorized?(guid_or_id)
    status != DELETED && (id == guid_or_id.to_i || guid == guid_or_id)
  end

  def self.valid_app(key)
    where('api_key = ?', key).first
  end

  def mark_as_deleted
    self.transaction do
      update_attributes!(:status => DELETED)
      User.where(:app_id => id).update_all(:status => User::DELETED)
    end
  end

  def all_transactions
    transactions.order('id DESC').includes(:user)
  end

  private

  def set_default_values
    write_attribute(:api_key, "ak_#{App.generate_key}")
    write_attribute(:status, ACTIVE)
  end

end

