class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     @movies = Movie.all
    # if params[:sort]
    #   @movies = Movie.order(params[:sort])
    # else
    #   @movies = Movie.all
    # end
    @all_ratings = Movie.pluck(:rating).uniq
    @checks = @all_ratings
    
        
    if params.key?(:sort)
      session[:sort] = params[:sort]
    end
    
    if params.key?(:all_ratings)
      session[:all_ratings] = params[:all_ratings].keys
    end
    
    
    if session.key?(:all_ratings)
      @checks = session[:all_ratings]
       @movies = @movies.where(rating: @checks)
    end
    
    
    if session[:sort] == 'title'
       @movies = @movies.order(:title)
      @title = 'bg-warning text-dark'
    elsif session[:sort] == 'release'
      @movies = @movies.order(:release_date)
      @release = 'bg-warning text-dark'
    end
     
    flash.keep

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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
