class Transaction < ActiveRecord::Base
  include Mudra::Record

  CREDIT = 'credit'
  DEBIT  = 'debit'

  validates_presence_of     :app_id, :user_id, :amount, :transaction_type
  validates_inclusion_of    :transaction_type, :in => [CREDIT, DEBIT]
  validates_numericality_of :amount, :greater_than_or_equal_to => 0.0
  validates_numericality_of :updated_balance, :greater_than_or_equal_to => 0.0

  belongs_to  :app
  belongs_to  :user

  # attr_protected  :app_id, :user_id, :transaction_type,
  #                 :created_at, :updated_at

  before_validation :set_default_values, :on => :create
  after_create :update_current_balance

  def save_attributes!(attrs)
    attrs.each do |key, value|
      self.send("#{key}=", value)
    end
    save!
  end

  def attrs
    _attrs = super
    _attrs['user_uid'] = user.user_uid
    _attrs
  end

  private

  def set_default_values
    if amount.present?
      write_attribute(:amount, amount.round(2))
      new_current_balance = transaction_type == CREDIT ?
        user.current_balance + amount :
        user.current_balance - amount
      write_attribute(:updated_balance, new_current_balance.round(2))
    end
  end

  def update_current_balance
    user.current_balance = updated_balance
    user.save!
  end

end
