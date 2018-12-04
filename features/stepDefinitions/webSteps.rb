Given(/^Открываю в браузере "(.*)"$/) do |url|
    @driver.get(url)
    @driver.manage().window().maximize()
    puts url
    sleep 5
end

And(/^Переход в раздел "(.*)"$/) do |elm|
    step %(Нажать "#{elm}")
end

And(/^Сортировать "(.*)"$/) do |elm|
    step %(Нажать "#{elm}")
end

And(/^Нажать "(.*)"$/) do |elm|
    #//*[@id="xz2jum5q4kp"]/div/div/div/div[1]/div/div/div/div/div/div[1]/div[1]/div/a[2]
    what = "(//*[text() = '#{elm}'])[1]"
    @wait.until {$el = @driver.find_element(:xpath, "#{what}")}
    sleep 3
    $el.click
    sleep 3
end

And(/^Перейти в раздел "(.*)"$/) do |elm|
    #//*[@id="xz2jum5q4kp"]/div/div/div/div[1]/div/div/div/div/div/div[1]/div[1]/div/a[2]
    what = "(//*[@class='n-w-tab__control-caption'][text()='#{elm}'])[2]"
    @wait.until {$el = @driver.find_element(:xpath, "#{what}")}
    sleep 3
    $el.click
    sleep 3
end

When(/^Поиск текста на странице "(.*)"$/) do |txt|
    what = "//*[text() = '#{txt}']"
    @driver.find_element(:xpath, "#{what}")
end

When(/^Проверка открытия страницы "(.*)"$/) do |txt|
    what = "//*[@title = '#{txt}']"
    @driver.find_element(:xpath, "(#{what})[2]")
end

And(/^Установить фильтр по производителю "(.*)"$/) do |elm|
    #//*[@id="xz2jum5q4kp"]/div/div/div/div[1]/div/div/div/div/div/div[1]/div[1]/div/a[2]
    what = "//*[text() = '#{elm}']"
    el1 = @driver.find_element(:xpath, "#{what}")
    el1.click
    sleep 3
end

And(/^Установить фильтр по цене от "(.*)" до "(.*)"$/) do |val1, val2|
    el1 = @driver.find_element(xpath: "//input[@name = 'Цена от']")
    el2 = @driver.find_element(xpath: "//input[@name = 'Цена до']")
    el1.send_keys val1
    el2.send_keys val2
    sleep 3
end

And(/^Проверка отображения "(.*)" и сортировки по цене$/) do |nn|
    pg = 1
    prc1 = 0
    prc2 = 0
    while @driver.find_elements(:xpath, "//*[@class = 'button button_size_s button_theme_pseudo n-pager__button-next i-bem button_js_inited']").count == 1 do
        if pg == 1
            puts "страница 1"
        else
            puts "страница #{pg}"
            e=@driver.find_element(:xpath, "//*[@class = 'button button_size_s button_theme_pseudo n-pager__button-next i-bem button_js_inited']")
            e.click
            sleep 5
        end    
        pg = pg + 1
        #puts "новая страница #{pg}"
        #Проверка отображения только выбранного бренда
        el1 = @driver.find_elements(:xpath, "//*[@class = 'link n-link_theme_blue']")
        el1.each do |elm|
            if (elm.text.include?(nn) == false) 
                raise "Check Failed"
            else 
                puts elm.text
            end
        end
        el2 = @driver.find_elements(:xpath, "//*[@class = 'n-snippet-card2__main-price-wrapper']")
        #Проверка сортировки
        el2.each do |elm|
            prc2 = elm.text.gsub(/\D/,'').to_i
            puts "compare #{prc1} <-> #{prc2}"
            if prc2 >= prc1 
                prc1 = prc2
            else
                raise "sort check failed"
                #puts "sort check failed"
                #prc1 = prc2
            end
        end
    end     
end
