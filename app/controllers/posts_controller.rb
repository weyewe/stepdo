class PostsController < ApplicationController
  def index 
    @posts = Post.all
  end
  
  def new
    @post_secret_key = UUIDTools::UUID.timestamp_create.to_s 
  end


  def create
    @post=  Post.create_or_update( params )
    respond_to do |format|
      format.js{
      }
      format.html{
        redirect_to edit_post_url(@post.id)
      }
    end
  end
  
  
  def edit
    @post = Post.find_by_id(params[:post_id])
    @post_secret_key  = @post.uuid
    # if @post
    #   # there is post? 
    # else
    #   @post = PermalinkRepo.find_by_permalink(params[:permalink ])
    # end
  end
  
  def update
    @post = Post.find_by_id(params[:id])
    @post.update_attributes(params[:post])
    # sleep 5 
    respond_to do |format|
      format.js {
        
      }
      
      format.html { 
        redirect_to edit_post_url(@post.id)
      }
    end
  end
  
  
  
  
  def show
    @post = Post.find_by_id(params[:post_id])
  end
  
  
  def add_step
    @new_step = Post.find_by_id( params[:post_id] ).steps.new
    respond_to do |format|
      format.js{
      }
      format.html{
      }
    end
  end
  
  
  
end
