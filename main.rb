#!/usr/bin/ruby

require 'twitter'
require 'erb'

class TemplateScope
  def initialize name, twittername, date, tweettext
    @name = name
    @twittername = twittername
    @date = date
    @tweettext = tweettext
  end
  def get_binding
    binding
  end
end

key                  =  %x(cat  ../key).chomp!
secret               =  %x(cat  ../secret).chomp!
access_token         =  %x(cat  ../access_token).chomp!
access_token_secret  =  %x(cat  ../access_token_secret).chomp!

client = Twitter::Streaming::Client.new do |c|
 c.consumer_key = key
 c.consumer_secret = secret
 c.access_token = access_token
 c.access_token_secret = access_token_secret 
end

puts "Connecting to twitter:"
client.filter(track: '#architecture, #bigquestions') do |tweet|
  puts tweet.text, tweet.user.name
  if tweet.text.include? '#architecture' and tweet.text.include? '#bigquestions'
    scope = TemplateScope.new(tweet.user.name, tweet.user.screen_name, tweet.created_at.getutc.getlocal("+10:00").to_s[0..-7], tweet.text)
    template = ERB.new(File.open('tweet-template.svg.erb').read)
    tweet_svg = template.result scope.get_binding
    tweet_file = File.open('tweet.svg','w')
    tweet_file.write( tweet_svg )
    tweet_file.close
    %x(convert tweet.svg -resize 80% -rotate 90 tweet.png)
    puts %x(sudo python print-image.py tweet.png)
  end
end
