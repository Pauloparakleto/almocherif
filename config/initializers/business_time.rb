BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferriss!
# BusinessTime::Config.beginning_of_workday = "9:00 am"
# BusinessTime::Config.end_of_workday = "18:00 pm"
#  BusinessTime::Config.holidays << Date.parse("August 4th, 2010")

