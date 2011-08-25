class Step < ActiveRecord::Base
  belongs_to :post
  has_many :details
  has_one :detail_code
  
  
  def Step.create_or_update( params )
    @post = Post.find_or_create( params )
    
    if @step = Step.step_exists?(params, @post)
      @step.update_attributes( params[:step] )
    else
      @step = Step.new(params[:step])
      @step.post_id = @post.id
      @step.save
    end
    return @step
  end
  
  
  def Step.step_exists?(params, post)
    step = Step.find(:first, :conditions => {
       :id => params[:id]
     }) or 
     Step.find(:first, :conditions => {
       :post_id => post.id,
       :order => ( params[:step][:order])
     })
     
     # the after or is to mitigate concurrency problem
     #  what if there are 2nd create POST
     #  even before the 1st create POST response
     #  had been received by the client
  end
  
  def Step.find_or_create( params, post )
    puts "This is the params in Step.find_or_create\n"*10
    puts params[:step][:order]
    if @step = Step.step_exists?( params , post)
    else
      @step  = Step.create( :post_id => post.id, 
        :order => ( params[:step][:order])
      )
    end
    return @step
  end
  
  
end
