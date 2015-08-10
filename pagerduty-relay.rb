#!/usr/bin/env ruby
require 'sinatra'
require 'pagerduty'
require 'net/http'

get '/' do
  'OK'
end

post '/pagerduty' do
  token = params['token']  # Make sure this matches our local token before we do anything
  if token == ENV['PAGERDUTY_RELAY_TOKEN']

    zd_id = params['id']
    zd_org = params['org']
    zd_title = params['title']

    if ENV['DEBUG']
      uri = URI("#{ENV['DEBUG']}")  # Yes, this is brittle.

      content_type 'application/json', :charset => 'utf-8'
      response = Net::HTTP.post_form(uri, "subject" => "[#{zd_org}] #{zd_title} (ZD##{zd_id})")
      response.message
    else
      # Trigger an incident
      #pagerduty = Pagerduty.new(ENV['PAGERDUTY_SERVICE_KEY'])
      #incident = pagerduty.trigger("[#{zd_org}] #{zd_title} (ZD##{zd_id})")
    end
  end
end
