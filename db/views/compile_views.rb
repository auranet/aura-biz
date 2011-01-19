#!/usr/bin/env ruby

require 'rubygems'
require 'ckuru-tools'
require 'ruby-debug'
class Test < ActiveRecord::Base
end

Dir.chdir(File.dirname(__FILE__))

emacs_trace do

  conn = Test.connection

  viewlist = nil

  filename = "./manifest.rb"
  if File.exists?(filename)
    eval `cat #{filename}`
    ckebug 0 , "loading #{filename}"
  else
    viewlist = Dir.glob(File.expand_path(File.join(__FILE__.gsub('compile_views.rb',''),'*.sql'))).sort
  end

  viewlist.each do |view|
    msg_exec "compiling #{view}" do
      code = `cat #{view}`
      view_name = File.basename(view).match(/(.+?)\./)[1]

      rslt = conn.execute("create or replace view #{view_name} as #{code}")
    end
  end
end
