module Popularable
  module Concern
    extend ActiveSupport::Concern

    included do
      # scope :order_by_recent_popularity, -> { .joins( "LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "')").where( ["popularable_popularity_events.popularity_event_date >= ?", 1.month.ago] ).group( self.to_s.pluralize.underscore + ".id" ).order( "popularity DESC" ) }

      scope :popular_today,      -> { 
        popular_since( Time.now.beginning_of_day )
      }

      scope :popular_this_week,  -> { 
        popular_since( Time.now.beginning_of_week )
      }
      
      scope :popular_this_month, -> { 
        popular_since( Time.now.beginning_of_month )
      }
      
      scope :popular_this_year,  -> { 
        popular_since( Time.now.beginning_of_year )
      }

      scope :popular_all_time,   -> { 
        popular_since( Time.now - 100.years )
      }
      
      scope :popular_since, -> (since){
        select( "#{self.table_name}.*, 0 + SUM(popularable_popularity_events.popularity) AS popularity").joins( "LEFT OUTER JOIN popularable_popularity_events ON (#{self.table_name}.id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '#{self.to_s}')").where( "popularable_popularity_events.popularity_event_date >= ?", since.to_date ).group( "#{self.table_name}.id" ).order( "popularity DESC" )
      }

      has_many :popularable_popularity_events, as: :popularable

      def self.has_popularable_concern?
        true
      end

    end

    def bump_popularity!( popularity_add_value = 1, popularity_event_time = Time.now )
      popularable_popularity_event = self.popularable_popularity_events.find_or_create_by( popularity_event_date: popularity_event_time.to_date )

      popularable_popularity_event.update_attributes( popularity: popularable_popularity_event.popularity.to_i + popularity_add_value )
    end
  end
end