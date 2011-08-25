class Detail < ActiveRecord::Base
  belongs_to :step
  
  
  def Detail.create_or_update( params )
    @post = Post.find_or_create({:post_secret_key => params[:uuid],
      :post_owner => params[:post_owner]
      })
    @step = Step.find_or_create( {:step => {
      :order =>  params[:step_order]}
      } , @post)

      puts "The content of params[:step_order]\n"*5
      puts params[:detail]
      puts params[:step_order]

    @detail = Detail.new(params[:detail])
    @detail.photo_content_type = MIME::Types.type_for(params[:Filename]).to_s
    @detail.step_id = @step.id
    if @detail.save
      @detail.add_to_dj
      puts "detail is saved"
    else
      puts "boom boom, something is wrong"
      puts @detail.errors.inspect
    end

    return @detail
  end
  
  
  def Detail.detail_exists?(params, step)
    detail = Detail.find(:first, :conditions => {
       :id => params[:id]
     })
  end
  
  
end
