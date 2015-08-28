module Popularable
  module Concern
    extend ActiveSupport::Concern

    included do
      # scope :order_by_popularity, -> { order(  ) }

      scope :popular_today,      -> { find_by_sql( ["SELECT " + self.to_s.pluralize.underscore + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.to_s.pluralize.underscore + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.to_s.pluralize.underscore + ".id ORDER BY popularity DESC", Time.now.to_date] ) }

      scope :popular_this_week,  -> { find_by_sql( ["SELECT " + self.to_s.pluralize.underscore + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.to_s.pluralize.underscore + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.to_s.pluralize.underscore + ".id ORDER BY popularity DESC", Time.now.beginning_of_week.to_date] ) }

      scope :popular_this_month, -> { find_by_sql( ["SELECT " + self.to_s.pluralize.underscore + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.to_s.pluralize.underscore + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.to_s.pluralize.underscore + ".id ORDER BY popularity DESC", Time.now.beginning_of_month.to_date] ) }

      scope :popular_this_year,  -> { find_by_sql( ["SELECT " + self.to_s.pluralize.underscore + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.to_s.pluralize.underscore + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') WHERE popularable_popularity_events.popularity_event_date >= ? GROUP BY " + self.to_s.pluralize.underscore + ".id ORDER BY popularity DESC", Time.now.beginning_of_year.to_date] ) }

      scope :popular_all_time,   -> { find_by_sql( ["SELECT " + self.to_s.pluralize.underscore + ".*, 0 + SUM(popularable_popularity_events.popularity) AS popularity FROM " + self.to_s.pluralize.underscore + " LEFT OUTER JOIN popularable_popularity_events ON (" + self.to_s.pluralize.underscore + ".id = popularable_popularity_events.popularable_id AND popularable_popularity_events.popularable_type = '" + self.to_s + "') GROUP BY " + self.to_s.pluralize.underscore + ".id ORDER BY popularity DESC"] ) }

      has_many :popularable_popularity_events, as: :popularable

      def self.has_popularable_concern?
        true
      end

    end

    def bump_popularity!( popularity_add_value = 1 )
      popularable_popularity_event = self.popularable_popularity_events.find_or_create_by( popularity_event_date: Time.now.to_date )

      popularable_popularity_event.update_attributes( popularity: popularable_popularity_event.popularity.to_i + popularity_add_value )
    end

    # def boost_trending_power!( add_value = 1000 )
    #   self.update_attributes( trending_power: trending_power + add_value )
    # end
    #
    # def fade_out_trending_power!( multiplier = 0.9 )
    #   self.update_attributes( trending_power: trending_power * multiplier )
    # end
  end
end