class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if request.original_fullpath == "/"
      session.delete(:ratings)
      session.delete(:selected_column)
    end

    @ratings_to_show =  []
    @all_ratings = Movie.all_ratings
    ratings =  @all_ratings
    @selected_column = session[:selected_column]

    if params[:home].present?
      if params[:sort_column].present?
        @selected_column = params[:sort_column]
        session[:selected_column] = @selected_column
      end
      if  params[:ratings].present?
        @ratings_to_show = params[:ratings].keys 
        ratings = @ratings_to_show
      end
      session[:ratings] = @ratings_to_show

    elsif session[:ratings].present?
        ratings = session[:ratings]
        @ratings_to_show = ratings
    end

    @movies = Movie.with_ratings(@selected_column,ratings)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def same_director
    @movie_id = params[:id]
    @movie = Movie.where(id:params[:id])
    @director =  @movie.pluck(:director)[0]
    @movies = Movie.same_director_movies(params[:id])
    # debugger
    if @movies==nil || @movies==[]
      flash[:warning] = "'#{ @movie.pluck(:title)[0]}' has no director info"
      redirect_to movies_path
    end
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
