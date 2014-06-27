module DatasetsHelper
  
   def strawberry(id)
     # @dataset =  Dataset.where(["id = ?",id]).first
#      
     # if Kai.test_file(@dataset.jdx_file)
       # file=@dataset.jdx_file 
#      
     # puts "nice dataset @<#{file}>"
        # @kumara=Rails.cache.fetch("#{file}", :expires_in => 5.minutes){ 
        # puts " spoon !  " 
        # opt=":file "+file.to_s+" :tab all :process header spec param data point raw first_page " 
        # dx_data=Kai.new(opt).flotr2_data 
       # if dx_data.is_a?(Switchies::Ropere) 
          # puts "\nhello Kumara! \n"
          # kumara=dx_data.to_kumara
       # else  
          # puts "\nwanna chips? Bro'  \n"
         # nil
       # end  
      # }
      # end
#        
      # if @kumara
      # else
        # puts "\nno strawberry!!\n"
        # @kumara=Switchies::Kumara.blank
      # end
#       
#       
      # @plotdx=@kumara.chip_it  
      # puts "\n<3 <3 <3 <3 <3 <3 <3 <3 \nstrawberry time!"
      # puts @plotdx.inspect.slice(0..100)
      # puts "C> C> C> C> C> C> C> C>\n"
#       
   end
  
  def kumara_chip(kumara,r=0..-1,block=0,page=0,limit=2048)
    if !kumara.is_a?(Switchies::Kumara)
      kumara= Switchies::Kumara.blank
    end
    chip=kumara.chip_it(r,block,page,limit)
    chip
  end
  

end
