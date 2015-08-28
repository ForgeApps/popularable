class PopularablePopularityEvent < ActiveRecord::Base
  belongs_to :popularable, polymorphic: true

end