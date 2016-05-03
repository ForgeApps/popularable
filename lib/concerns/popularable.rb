module Popularable
  module Concern
    extend ActiveSupport::Concern

    included do
      # scope :order_by_recent_popularity, -> { .joins( "LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "')").where( ["popularable_popularity_events.popularity_event_date >= ?", 1.month.ago] ).group( self.to_s.pluralize.underscore + ".id" ).order( "popularity DESC" ) }

      scope :popular_today,      -> { find_by_sql( ["SELECT " + self.table_name + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.table_name + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.table_name + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.table_name + ".id ORDER BY popularity DESC", Time.now.to_date] ) }

      scope :popular_this_week,  -> { find_by_sql( ["SELECT " + self.table_name + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.table_name + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.table_name + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.table_name + ".id ORDER BY popularity DESC", Time.now.beginning_of_week.to_date] ) }

      scope :popular_this_month, -> { find_by_sql( ["SELECT " + self.table_name + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.table_name + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.table_name + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.table_name + ".id ORDER BY popularity DESC", Time.now.beginning_of_month.to_date] ) }

      scope :popular_this_year,  -> { find_by_sql( ["SELECT " + self.table_name + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.table_name + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.table_name + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.table_name + ".id ORDER BY popularity DESC", Time.now.beginning_of_year.to_date] ) }

      scope :popular_all_time,   -> { find_by_sql( ["SELECT " + self.table_name + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.table_name + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.table_name + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') GROUP BY " + self.table_name + ".id ORDER BY popularity DESC"] ) }

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