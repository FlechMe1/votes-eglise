class Power < ActiveRecord::Base

  belongs_to :campaign

  belongs_to :from, polymorphic: true
  belongs_to :to, polymorphic: true


end
