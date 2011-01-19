

class Author < CkuruTools::HashInitializerClass
  attr_accessor :name

  def url
    "/author/#{name}"
  end
end

class Post < CkuruTools::HashInitializerClass
  attr_accessor :title,:body,:published_at
  attr_accessor :author

  attr_accessor :array
end  

class BillablePeriodsController < ApplicationController
  hobo_model_controller

  auto_actions :all

  index_action :test_action do
    @this = @blog_post = Post.new(:title => "My Blog Post",
                                  :author => Author.new(:name => "Bret"),
                                  :published_at => Time.now,
                                  :array => [1,2,3,4,5],
                                  :body => "Hey this is my blog post.")
  end

  web_method :run_maintenance

  def run_maintenance 
    @this = BillablePeriod.find(params["id"].to_i)

    @this.maintenance

    redirect_to :action => "index"
  end

end
