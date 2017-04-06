ActionMailer::Base.default :content_type => 'text/html'
ActionMailer::Base.smtp_settings = { :address => 'localhost.tmgm-mail', :port => 52678 }
