class HieraData < ActiveRecord::Base
  validates_presence_of :level
  validates_presence_of :key
end
