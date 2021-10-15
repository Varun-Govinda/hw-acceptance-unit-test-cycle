require 'rails_helper'

describe Movie do
   describe 'Tests for same_director_movies' do
    it "responds to same_director_movies" do
      Movie.should respond_to(:same_director_movies)
    end

    context "Happy path for same director movies" do
      it "returns a list of movies with the same director" do
        Movie.destroy_all(director: ['director_test', 'not_director_test'])
        Movie.create(title: 'test_movie',director: 'director_test')
        mov_id = Movie.where(title:'test_movie').pluck(:id)[0]
        5.times { Movie.create(director: 'director_test') }
        2.times { Movie.create(director: 'not_director_test') }
        movies =  Movie.same_director_movies(mov_id)

        expect(6).to eq movies.size()

      end
    end

      context "Sad path for same director movies" do
      it "returns empty string" do
        Movie.destroy_all(director: ['director_test', 'not_director_test'])
        Movie.create(title: 'test_movie')
        mov_id = Movie.where(title:'test_movie').pluck(:id)[0]
        5.times { Movie.create(director: 'not_director_test') }
        movies =  Movie.same_director_movies(mov_id)
        expect(0).to eq movies.size()
      end
    end
  end

  describe 'Test for all_ratings method' do
    it "responds to all_ratings" do
      Movie.should respond_to(:all_ratings)
    end
    it 'testing if all_ratings returns correct data' do
      Movie.destroy_all()
      2.times { Movie.create(rating: 'G') }
      3.times { Movie.create(rating: 'PG') }
      expect(["G", "PG"]).to eq Movie.all_ratings

    end
  end

    describe 'Test for with_ratings method' do
    it "responds to with_ratings" do
      Movie.should respond_to(:with_ratings)
    end

    it 'testing if with_ratings returns correct data when ratings passed is []' do
      Movie.destroy_all()
      2.times { Movie.create(rating: 'G') }
      3.times { Movie.create(rating: 'PG') }
      expect(5).to eq Movie.with_ratings(nil, []).size()
    end

    it "testing if with_ratings returns correct data when ratings passed is ['G']" do
      Movie.destroy_all()
      2.times { Movie.create(rating: 'G') }
      3.times { Movie.create(rating: 'PG') }
      expect(2).to eq Movie.with_ratings(nil, ['G']).size()
    end
  end

end
