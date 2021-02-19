module ApplicationHelper
    
    def increase_timeout session
        session['timeout'] = 0 if session['timeout'].nil?
        session['timeout'] = session['timeout'] + 1
    end
    
    def increase_retry session
        session['retry'] = 0 if session['retry'].nil?
        session['retry'] = session['retry'] + 1
    end
    
    def increase_reject session
        session['reject'] = 0 if session['reject'].nil?
        session['reject'] = session['reject'] + 1
    end

    def save_result session
        result = session["result_item"].present? ? session["result_item"] : {}
        session["result_item"] = result if session["result_item"].blank?
        product = get_product(session)
        intention = get_intention(session)
        result["product"] = product
        result["intention"] = intention
        session["result_item"] = result
    end

    def get_product session
        begin
            result = session["result_item"]["product"].present? ? session["result_item"]["product"] : ""
            #### MOCK
            #if session["result"].split(" ").join() == "บัตรเครดิต"
            #    result = session["result"].split(" ").join()
            #end
        rescue StandardError
           result = ""
        end
        result
    end

    def get_intention session
        begin
            result = session["result_item"]["intention"].present? ? session["result_item"]["intention"] : ""
            #### MOCK 
            # if session["result"].split(" ").join() == "สอบถามยอด"
            #     result = session["result"].split(" ").join()
            # end
        rescue StandardError
           result = ""
        end
        result
    end

    def contain_intention session
        result = false
        if session["result_item"].present?
            result = true if session["result_item"]["intention"].present?
        end
        result
    end

    def has_one_intention session
        resutl = true
        resutl
    end

    def has_product session
        result = false
        if session["result_item"].present?
            result = true if session["result_item"]["product"].present?
        end
        result
    end

    def belong_to_single_product session
        resutl = true
        resutl
    end

    def get_nlu_result session
        begin
            result = {}
            result = session['nl_result']['nlu'] unless session['nl_result']['nlu'].nil?
        rescue StandardError
            result = {}
        end
        result
    end

    def get_identification session
        begin
            uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_ident")
            header = {'Content-Type': 'text/json'}
            if session["result_item"]["product"] == 'credit_card' # session["result_item"]["product"]
                data =  {
                            product: 'credit_card',
                            card_id: '4552123456780001' # session["card_id"]     
                        }
            elsif session["result_item"]["product"] == 'bank_account' # session["result_item"]["product"]
                data =  {
                            product: 'bank_account',
                            account_no: ''              # session["account_no"]
                        }
            else
                data =  {
                            product: 'loan',
                            citizen_id: ''              # session["citizen_id"]
                        }
            end
      
            # Create the HTTP objects
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = data.to_json
      
            # Send the request
            response = http.request(request)
        rescue StandardError
            response = ""
        end
        response
    end
      
    def get_announcement session
        begin
            uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
            header = {'Content-Type': 'text/json'}
            if session["result_item"]["product"] == 'credit_card'
                data =  {
                            product: 'credit_card', # session["result_item"]["product"]
                            card_id: '4552123456780001'      
                        }
            elsif session["result_item"]["product"] == 'bank_account'
                data =  {
                            product: 'bank_account', # session["result_item"]["product"]
                            account_no: ''      
                        }
            else
                data =  {
                            product: 'loan',
                            citizen_id: ''      
                        }
            end
      
            # Create the HTTP objects
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri.request_uri, header)
            request.body = data.to_json
      
            # Send the request
            response = http.request(request)
        rescue StandardError
            response = ""
        end
        response
    end

end
module AmiCallResult
    SUCCESS           = 'S'.freeze
    TOO_MANY_ERRORS   = 'T'.freeze
    EXIT              = 'X'.freeze
    HANGUP            = 'H'.freeze
    SYSTEM_ERROR      = 'E'.freeze
end