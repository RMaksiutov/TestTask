
    $body = "{
        \"data\": [
            {
                \"name\": <name>,
                \"value\": <value>,
                \"time\": <time>,
                \"isOnline\": <isOnline>
            }
        ]
        }"

Then(/^Положительный post запрос$/) do
    n=Time.now.to_s.gsub(/\D/,'')
    body = "{
    \"data\": [
        {
            \"name\": \"test#{n}\",
            \"value\": 500,
            \"time\": #{n},
            \"isOnline\": true
        }
    ]
    }"
    #отправка пост запроса и проверка ответа
    response = HTTParty.post("https://url/post", :body => body)
    checkBody201(response)
    #отправка гет запроса и проверка ответа, так же проверка что возвращенные данные соответствуют тому что ранее было отправлено в пост        
    response = HTTParty.get("https://url/get?from=#{n}&to=#{n}")
    puts response.code.to_s
    puts response.body.to_s
    jget = "{
        \"time\":  #{n},
        \"name\": \"test#{n}\",
        \"value\": 500
        }"
    if response.code.to_s == "200"
        puts "status 200"
    else
        raise "status check failed - #{response.code.to_s}"        
    end
    if jget == response.body.to_s
        puts "text OK"
    else
        raise "message check failed - #{response.body.to_s}"
    end

end

Then(/^Положительная проверка форматов полей$/) do
    
    #name = ["true", "1", "\"\"", "Б", "б", ]
    #латиница, цифры, 255 символов 
    
    name = ["\"Latin\"", "\"1\"", "\"F12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234\""]
    value = ["0", "567", "1000"]
    time = ["0", "-100", "100", "-9223372036854775808", "9223372036854775807"]
    isOnline = ["true", "false"]
    formatPositiveCheck("<name>", name)
    formatPositiveCheck("<value>", value)
    formatPositiveCheck("<time>", time)
    formatPositiveCheck("<isOnline>", isOnline)
    
end

Then(/^Отрицательная проверка форматов полей$/) do
    
    #name = ["true", "1", "\"\"", "Б", "б", ]
    #латиница, цифры, 255 символов 
    
    name = ["\"Б\"", "1", "\"\"", "true", "\"A(\"","\"A)\"","\"A,\"","\"A:\"","\"A;\"","\"A<\"","\"A>\"","\"A@\"","\"A[\"","\"A]\"","\"A#\"","\"A$\"","\"A%\"","\"A&\"","\"A*\"","\"A=\"","\"A~\"","\"A!\"","\"A+\"","\"A/\"","\"A?\"","\"A^\"","\"A_\"","\"A`\"","\"A{\"","\"A|\"","\"A}\"","\"F123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345\""]
    value = ["-1", "0.1", "1001", "\"\"", "\"1\"", "true", "\"F\""]
    time = ["\"\"", "\"100\"", "\"F\"", "-9223372036854775809", "9223372036854775808", "0.1"]
    isOnline = ["\"true\"", "\"\"", "0", "\"F\""]
    formatNegativeCheck("<name>", name)
    formatNegativeCheck("<value>", value)
    formatNegativeCheck("<time>", time)
    formatNegativeCheck("<isOnline>", isOnline)
    
end

Then(/^Проверка обязательности полей$/) do
    
    #name = ["true", "1", "\"\"", "Б", "б", ]
    #латиница, цифры, 255 символов 
    fieldRemoveCheck("<name>")
    fieldRemoveCheck("<value>")
    fieldRemoveCheck("<time>")
    fieldRemoveCheck("<isOnline>")
    
end
#Parameter	Type	Validation
#name	String	Только литиница и цифры
#value	Long	0 – 1000
#time	Long	Только цифры
#isOnline	Boolean	Boolean
def formatPositiveCheck(field, value)
    n=Time.now.to_s.gsub(/\D/,'')
    body = ""
    case fld = field
        when "<name>" 
            body = $body.sub("<value>", "1").sub("<time>", "1").sub("<isOnline>", "true")
        when "<value>"
            body = $body.sub("<name>", "test#{n}").sub("<time>", "1").sub("<isOnline>", "true")
        when "<time>"
            body = $body.sub("<name>", "test#{n}").sub("<value>", "1").sub("<isOnline>", "true")
        when "<isOnline>"
            body = $body.sub("<name>", "test#{n}").sub("<value>", "1").sub("<time>", "1")
    end
    count = nil
    count = value.size # сюда мы подставим то что взяли из массива (количество емейл)
    while count != 0 #ну и тут начинается цикл
        begin
            response = HTTParty.post("https://url/post", :body => body.sub(field, value[count-1]))
            checkBody201(response)
            count -= 1
        rescue
            raise "format check failed"
        end
    end

end

def formatNegativeCheck(field, value)
    n=Time.now.to_s.gsub(/\D/,'')
    body = ""
    case fld = field
    when "<name>" 
        body = $body.sub("<value>", "1").sub("<time>", "1").sub("<isOnline>", "true")
    when "<value>"
        body = $body.sub("<name>", "test#{n}").sub("<time>", "1").sub("<isOnline>", "true")
    when "<time>"
        body = $body.sub("<name>", "test#{n}").sub("<value>", "1").sub("<isOnline>", "true")
    when "<isOnline>"
        body = $body.sub("<name>", "test#{n}").sub("<value>", "1").sub("<time>", "1")
    end
    count = nil
    count = value.size # сюда мы подставим то что взяли из массива (количество емейл)
    while count != 0 #ну и тут начинается цикл
        begin
            response = HTTParty.post("https://url/post", :body => body.sub(field, value[count-1]))
            checkBody400(response)
            count -= 1
        rescue
            raise "format check failed"
        end
    end

end

def fieldRemoveCheck(field)
    n=Time.now.to_s.gsub(/\D/,'')
    body = ""
    case fld = field
    when "<name>" 
        body = $body.sub("\"name\": <name>,", "").sub("<value>", "1").sub("<time>", "1").sub("<isOnline>", "true")
    when "<value>"
        body = $body.sub("<name>", "test#{n}").sub("\"value\": <value>,", "").sub("<time>", "1").sub("<isOnline>", "true")
    when "<time>"
        body = $body.sub("<name>", "test#{n}").sub("<value>", "1").sub("\"time\": <time>,", "").sub("<isOnline>", "true")
    when "<isOnline>"
        body = $body.sub("<name>", "test#{n}").sub("<value>", "1").sub("<time>", "1").sub("\"isOnline\": <isOnline>,", "")
    end
    response = HTTParty.post("https://url/post", :body => body)
    checkBody400(response)
end

def checkBody201(response)
    puts response.code.to_s
    puts response.body.to_s
    jcode = JSON.parse(response.body)["code"]
    jdescription = JSON.parse(response.body)["description"]
    if response.code.to_s == "201"
        puts "status 201"
    else
        raise "format check failed - #{response.code.to_s}"        
    end
    if jcode == "ok" and jdescription == "ok"
        puts "text OK"
    else
        raise "format check failed - #{response.body.to_s}"
    end
end

def checkBody400(response)
    puts response.code.to_s
    puts response.body.to_s
    jmessage = JSON.parse(response.body)["message"]
    if response.code.to_s == "400"
        puts "status 400"
    else
        raise "format check failed - #{response.code.to_s}"        
    end
    if jmessage == "validation error"
        puts "message OK"
    else
        raise "format check failed - #{response.body.to_s}"
    end
end