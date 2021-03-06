class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end 

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    @ratings_selected = @all_ratings
    all_ratings_hash = Hash.new
    all_ratings_hash.store("G",1)
    all_ratings_hash.store("PG",1)
    all_ratings_hash.store("PG-13",1)
    all_ratings_hash.store("R",1)
    
    session[:ratings] ||= all_ratings_hash
    session[:sort] ||= "title"
    
    session[:ratings] = params[:ratings] if params.keys.include? "ratings"
    @ratings_selected = session[:ratings].keys
    
    @sort_by = params[:sort] || session[:sort]
    session[:sort] = @sort_by
    
    @movies = Movie.where(:rating => @ratings_selected).order(@sort_by)
    
    if (params[:sort] != session[:sort])
      flash.keep
      redirect_to movies_path + "?sort=" + session[:sort]
    end
      
    if (@sort_by) == 'title'
      @css_title = 'hilite'
    elsif (@sort_by) == 'release_date'
      @css_release_date = 'hilite'
    end
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

end
