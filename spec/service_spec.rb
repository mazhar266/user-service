require File.dirname(__FILE__) + '/../service'
require 'spec'
require 'spec/interop/test'
require 'rack/test'


set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
  Sinatra::Application
end

describe "service" do
  before(:each) do
    user.delete_all
  end

  describe "GET on /api/v1/users/:id" do
    before(:each) do
      User.create(
      	:name => "mazhar",
      	:email => "mazhar@stsbd.com",
      	:password => "123456",
      	:bio => "Rubyist")
  	end

  	it "should return an user by name" do
  		get '/api/v1/users/mazhar'
  		last_response.should be_ok
  		attribute = JSON.parse(last_response.body)
  		attribute["name"].should == "mazhar"
  	end

  	it "should return an user with an email" do
  		get '/api/v1/users/mazhar'
  		last_response.should be_ok
  		attribute = JSON.parse(last_response.body)
  		attribute["email"].should == "mazhar@stsbd.com"
  	end

  	it "should not return an user's password" do
		get '/api/v1/users/mazhar'
		last_response.should be_ok
		attributes = JSON.parse(last_response.body)
		attributes.should_not have_key("password")
  	end
  
  	it "should return an user with a bio" do
		get '/api/v1/users/paul'
		last_response.should be_ok
		attributes = JSON.parse(last_response.body)
		attributes["bio"].should == "Rubyist"
  	end

  	it "should return a 404 for a user that doesn't exist" do
		get '/api/v1/users/foo'
		last_response.status.should == 404
	end
  end
end