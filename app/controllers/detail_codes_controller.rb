class DetailCodesController < ApplicationController
  def create
    
    @detail_code =  DetailCode.create_or_update( params )
    puts "we are out now"
    puts @detail_code.inspect
    
    # sleep 3
    respond_to do |f|
      f.js {
      }
      
      f.html{
        redirect_to "http://google.com"
      }
    end
  end
  
  
  def update
    @detail_code = DetailCode.find_by_id(params[:id])
    @detail_code.update_attributes(params[:detail_code])
    # sleep 3
    respond_to do |format|
      format.js {
        
      }
      
      format.html { 
        redirect_to edit_post_url(@post.id)
      }
    end
  end
  
end
