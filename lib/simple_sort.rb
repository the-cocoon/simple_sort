require "simple_sort/version"

module SimpleSort
  class Engine < Rails::Engine; end

  module Base
    extend ActiveSupport::Concern

    included do
      scope :mysql_random, ->{ reorder('RAND()')   }
      scope :psql_random,  ->{ reorder('RANDOM()') }

      scope :max2min, ->(field = :id) {
        reorder("#{ table_name }.#{ field } DESC") if field && self.columns.map(&:name).include?(field.to_s)
      }
      scope :min2max, ->(field = :id) {
        reorder("#{ table_name }.#{ field } ASC")  if field && self.columns.map(&:name).include?(field.to_s)
      }

      scope :simple_sort, ->(params, default_sort_field = nil){
        sort_column = params[:sort_column]
        sort_type   = params[:sort_type]

        return recent(default_sort_field) unless sort_column
        return recent(sort_column)        unless sort_type

        sort_type.downcase == 'asc' ? recent(sort_column) : old(sort_column)
      }
    end
  end
end
