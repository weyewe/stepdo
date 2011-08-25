class Post < ActiveRecord::Base
  belongs_to :user
  has_many :steps
  def Post.create_or_update( params )
    if @post = Post.post_exists?(params)
      @post.update_attributes( params[:post] )
    else
      @post = Post.new(params[:post])
      @post.uuid = params[:post_secret_key]
      @post.user_id = params[:post_owner]
      @post.save
    end
    return @post
  end

  def Post.post_exists?(params)
     post = Post.find(:first, :conditions => {
       :uuid => params[:post_secret_key], 
       :user_id => params[:post_owner]
     })
  end

# called from the step.rb
  def Post.find_or_create( params )
    if @post = Post.post_exists?(params)
    else
      @post  = Post.create( :user_id => params[:post_owner], 
        :uuid => params[:post_secret_key]
      )
    end
    return @post
  end
end
