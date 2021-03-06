class Address < ApplicationRecord
  # Modules to help with some functionality
  include AppHelpers::Validations
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # get an array of the states in U.S. (from PATS)
  STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]

  # Relationships
  belongs_to :customer
  has_many :orders

  # Scopes
  scope :by_recipient,  -> { order(:recipient) }
  scope :by_customer,   -> { joins(:customer).order('customers.last_name').order('customers.first_name') }
  scope :shipping,      -> { where(is_billing: false) }
  scope :billing,       -> { where(is_billing: true) }

  # Validations
  validates_presence_of :street_1, :recipient, :city
  validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
  validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
  # or the long way...
  # validates_inclusion_of :state, in: ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"], message: "is not an option"
  
  validate -> { is_active_in_system(:customer) }, on: :create
  validate :address_is_not_a_duplicate, on: :create
  validate :there_is_one_active_billing_address

  def already_exists?
    Address.where(customer_id: self.customer_id, recipient: self.recipient, zip: self.zip).size == 1
  end

  # Callbacks
  before_update :reset_prior_billing_address

  # Private methods
  private
  def address_is_not_a_duplicate
    return true if self.customer_id.nil? || self.recipient.nil? || self.zip.nil?
    if self.already_exists?
      errors.add(:recipient, "already exists for this recipient at this zip code")
    end
  end

  def there_is_one_active_billing_address
    return true if self.is_billing && self.active
    return true if self.street_1.nil? || self.recipient.nil? || self.zip.nil? || self.state.nil?
    other_addresses = self.customer.addresses.active.billing - [self]
    if other_addresses.empty?
      errors.add(:base, "There must be an active billing address on file.")
    end
  end

  def reset_prior_billing_address
    return true unless self.is_billing
    prior_billing_address = self.customer.addresses.active.billing.first
    prior_billing_address.update_attribute(:is_billing, false)
  end

end
