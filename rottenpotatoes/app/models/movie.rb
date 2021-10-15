class Movie < ActiveRecord::Base
    
    def self.same_director_movies(id)
         director = Movie.where(id:id).pluck(:director)[0]
         if director!=nil && director!=""
             Movie.where(director:director)
         else
             return []
         end
    end
    
    #-------------------hw-3------------#
    def self.with_ratings(sort_column, ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
      if ratings_list == nil || ratings_list.length == 0
           self.all
      else
            ratings_list = ratings_list.map {|rating| rating.upcase}
            self.where(rating: ratings_list).order(sort_column)
      end
    end

  def self.all_ratings
    self.distinct.pluck(:rating).compact
  end
end
