Before do |scenario|
    #запуск браузера
    puts "Запуск браузера chrome"
    @driver = Selenium::WebDriver.for :chrome
    #USER_AGENT = "autotest" #установка USER_AGENT, для того чтобы не попадать в статистику в бою. Реализовано для SSO, подробности у Алисы.
    #@driver = Selenium::WebDriver.for :chrome, :switches => %W[--user-agent=#{USER_AGENT}]
    @wait = Selenium::WebDriver::Wait.new(:timeout => 120)
end


After do |scenario|
    #закрытие браузера, вывод ошибки и созранение скриншота, если сценарий неуспешен
    if scenario.failed?
        #timestamp = Time.new.strftime("%Y%m%d_%H%M%S")
        #filename = "error-#{timestamp}"
        #@driver.save_screenshot("screenshots/#{filename}.png")
        puts scenario.name
        puts scenario.exception.message
    else 
        @driver.close
    end
end