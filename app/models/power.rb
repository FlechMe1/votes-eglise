class Power < ActiveRecord::Base

  belongs_to :campaign

  belongs_to :from, polymorphic: true
  belongs_to :to, polymorphic: true

  delegate :name, to: :from, prefix: true, allow_nil: true
  delegate :name, to: :to, prefix: true, allow_nil: true

end
