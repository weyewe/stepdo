class DetailCode < ActiveRecord::Base
  

 belongs_to :step

 def DetailCode.create_or_update( params )
   @post = Post.find_or_create({:post_secret_key => params[:post_secret_key],
     :post_owner => params[:post_owner]
     })
   @step = Step.find_or_create( {:step => {
     :order =>  params[:step][:order]}
     } , @post)

     puts "The content of params[:step_order]\n"*5
     puts params[:detail_code]
     puts params[:step][:order]

   @detail_code = DetailCode.new(params[:detail_code])
   @detail_code.step_id = @step.id
   if @detail_code.save
     # @detail_code.add_to_dj
     puts "detail is saved"
   else
     puts "boom boom, something is wrong"
     puts @detail_code.errors.inspect
   end

   return @detail_code
 end

 # Any way to mitigate the concurrency problem?
 # => 
 def DetailCode.detail_exists?(params, step)
   detail = DetailCode.find(:first, :conditions => {
      :id => params[:id]
    })
 end

 def give_brush_destination
   string = self.code
   regex  = /<pre +class=\\?["']brush *: +([a-zA-Z.]+) *\\?["']>/
   string.match(regex); value  = $1
   if value.nil?
     value = 'plain'
   end
   destination = DC_MAPPER[value.to_sym]
   if destination.nil?
     return "/javascripts/SyntaxHighlighter/scripts/shBrushPlain.js"
   else
     destination
   end
 end



 DC_MAPPER = {:sql=>"/javascripts/SyntaxHighlighter/scripts/shBrushSql.js", :sass=>"/javascripts/SyntaxHighlighter/scripts/shBrushSass.js", :ruby=>"/javascripts/SyntaxHighlighter/scripts/shBrushRuby.js", :jfx=>"/javascripts/SyntaxHighlighter/scripts/shBrushJavaFX.js", :xml=>"/javascripts/SyntaxHighlighter/scripts/shBrushXml.js", :py=>"/javascripts/SyntaxHighlighter/scripts/shBrushPython.js", :js=>"/javascripts/SyntaxHighlighter/scripts/shBrushJScript.js", :pas=>"/javascripts/SyntaxHighlighter/scripts/shBrushDiff.js", :actionscript3=>"/javascripts/SyntaxHighlighter/scripts/shBrushAS3.js", :scss=>"/javascripts/SyntaxHighlighter/scripts/shBrushSass.js", :javafx=>"/javascripts/SyntaxHighlighter/scripts/shBrushJavaFX.js", :python=>"/javascripts/SyntaxHighlighter/scripts/shBrushPython.js", :plain=>"/javascripts/SyntaxHighlighter/scripts/shBrushPlain.js", :erl=>"/javascripts/SyntaxHighlighter/scripts/shBrushErlang.js", :as3=>"/javascripts/SyntaxHighlighter/scripts/shBrushAS3.js", :html=>"/javascripts/SyntaxHighlighter/scripts/shBrushXml.js", :scala=>"/javascripts/SyntaxHighlighter/scripts/shBrushScala.js", :javascript=>"/javascripts/SyntaxHighlighter/scripts/shBrushJScript.js", :jscript=>"/javascripts/SyntaxHighlighter/scripts/shBrushJScript.js", :csharp=>"/javascripts/SyntaxHighlighter/scripts/shBrushCSharp.js", :shell=>"/javascripts/SyntaxHighlighter/scripts/shBrushBash.js", :rails=>"/javascripts/SyntaxHighlighter/scripts/shBrushRuby.js", :erlang=>"/javascripts/SyntaxHighlighter/scripts/shBrushErlang.js", :css=>"/javascripts/SyntaxHighlighter/scripts/shBrushCss.js", :c=>"/javascripts/SyntaxHighlighter/scripts/shBrushCpp.js", :bash=>"/javascripts/SyntaxHighlighter/scripts/shBrushBash.js", :vb=>"/javascripts/SyntaxHighlighter/scripts/shBrushVb.js", :text=>"/javascripts/SyntaxHighlighter/scripts/shBrushPlain.js", :perl=>"/javascripts/SyntaxHighlighter/scripts/shBrushPerl.js", :delphi=>"/javascripts/SyntaxHighlighter/scripts/shBrushDelphi.js", :xhtml=>"/javascripts/SyntaxHighlighter/scripts/shBrushXml.js", :ror=>"/javascripts/SyntaxHighlighter/scripts/shBrushRuby.js", :groovy=>"/javascripts/SyntaxHighlighter/scripts/shBrushGroovy.js", :diff=>"/javascripts/SyntaxHighlighter/scripts/shBrushDiff.js", :"c#"=>"/javascripts/SyntaxHighlighter/scripts/shBrushCSharp.js", :coldfusion=>"/javascripts/SyntaxHighlighter/scripts/shBrushColdFusion.js", :vbnet=>"/javascripts/SyntaxHighlighter/scripts/shBrushVb.js", :pl=>"/javascripts/SyntaxHighlighter/scripts/shBrushPerl.js", :pascal=>"/javascripts/SyntaxHighlighter/scripts/shBrushDelphi.js", :cf=>"/javascripts/SyntaxHighlighter/scripts/shBrushColdFusion.js", :rb=>"/javascripts/SyntaxHighlighter/scripts/shBrushRuby.js", :java=>"/javascripts/SyntaxHighlighter/scripts/shBrushJava.js", :"c-sharp"=>"/javascripts/SyntaxHighlighter/scripts/shBrushCSharp.js", :cpp=>"/javascripts/SyntaxHighlighter/scripts/shBrushCpp.js", :xslt=>"/javascripts/SyntaxHighlighter/scripts/shBrushXml.js", :php=>"/javascripts/SyntaxHighlighter/scripts/shBrushPhp.js", :patch=>"/javascripts/SyntaxHighlighter/scripts/shBrushDiff.js", :applescript=>"/javascripts/SyntaxHighlighter/scripts/shBrushAppleScript.js"}

  
  
  
end
