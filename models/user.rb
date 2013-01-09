class User < ActiveRecord::Base
  include Mudra::Record

  DELETED = 'deleted'
  ACTIVE  = 'active'

  attr_accessor :initial_balance

  validates_presence_of     :app_id, :status
  validates_uniqueness_of   :user_uid, :scope => :app_id, :on => :create
  validates_numericality_of :current_balance, :greater_than_or_equal_to => 0.0
  validates_length_of       :user_uid, :maximum => 30

  belongs_to  :app
  has_many    :transactions

  attr_protected :current_balance, :app_id, :status,
    :created_at, :updated_at

  before_validation :set_default_values, :on => :create

  scope :by_app_id_and_user_id, lambda { |app_id, user_id|
    where("app_id = ? AND (id = ? OR user_uid = ?) AND status != ?",
    app_id, user_id, user_id, DELETED) }

  def self.accessible_keys
    ['user_uid', 'description', 'initial_balance']
  end

  def self.get_by_app_id_and_user_id(ap_id, user_id)
    self.by_app_id_and_user_id(ap_id, user_id).first
  end

  def mark_as_deleted
    update_attributes!(:status => DELETED)
  end

  def create_credit_transaction(params)
    create_transaction(Transaction::CREDIT, params)
  end

  def create_debit_transaction(params)
    create_transaction(Transaction::DEBIT, params)
  end

  def all_transactions
    transactions.order('id DESC').includes(:user)
  end

  private

  def set_default_values
    if initial_balance.present? && initial_balance.to_f > 0.0
      write_attribute(:current_balance, initial_balance.to_f)
    else
      write_attribute(:current_balance, 0.0)
    end
    write_attribute(:status, ACTIVE)
  end

  def create_transaction(transaction_type, params)
    t = self.transactions.build
    t.save_attributes!(:app_id => app_id,
                       :transaction_type => transaction_type,
                       :amount => params['amount'],
                       :description => params['description'])
    t
  end


end
