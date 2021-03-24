module ApplicationHelper
    CONFIG = YAML.load_file(AmiVoice::DialogModule::Settings.config_file)
    DIALOG_PROPERTY = CONFIG["dialog_property"] if CONFIG["dialog_property"].present?
    INTENTION_LIST = CONFIG["intention"] if CONFIG["intention"].present?
    #PRODUCT_LIST = CONFIG["product"] if CONFIG["product"].present?

    def transfer_to_destination session
        if is_transfer_ivr(session)
            #### Go to IVR
        else
            product = get_product(session)
            if product == "credit_card"
                set_initial_variable(session, CreditCardIdentificationDialog.name)
                CreditCardIdentificationDialog
            elsif product == "bank_account"
                set_initial_variable(session, BankAccountIdentificationDialog.name)
                BankAccountIdentificationDialog
            elsif product == "loan"
                set_initial_variable(session, LoanIdentificationDialog.name)
                LoanIdentificationDialog
            end
        end
    end

    def announce_self_service session
        product = session["result_item"]["product"]
        intention = session["result_item"]["intention"].last
        iden_id = session["result_item"]["iden_id"]
        if product == 'credit_card'
            ##### CALL CREDIT CARD ANNOUNCEMENT API #####
            uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
            response = Net::HTTP.post_form(uri, "product" => product, "card_id" => iden_id)
            session["announcement_info"] = JSON.parse(response.body)
            if session["announcement_info"]["card_info"][0]["card_status"] == "active" #session["announcement_info"]["status"] != "error" && session["announcement_info"]["card_status"] == "active"
              if intention.last == "002" #"remaining_balance"
                SelfServiceCreditCardRemainingBalanceDialog
              elsif intention.last == "003" #"outstanding_balance"
                SelfServiceCreditCardOutstandingBalanceDialog
              elsif intention.last == "004" #"usage_balance"
                SelfServiceCreditCardUsageBalanceDialog
              else # intention.last == "001" # "enquire_balance"
                SelfServiceCreditCardBalanceDialog
              end
            else
              AgentTransferBlock
            end
    
        elsif product == 'bank_account'
            ##### CALL BANK ACCOUNT ANNOUNCEMENT API #####
            uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
            response = Net::HTTP.post_form(uri, "product" => product, "account_no" => iden_id)
            session["announcement_info"] = JSON.parse(response.body)
            if session["announcement_info"]["account_info"][0]["account_status"] == "active"
              SelfServiceBankAccountBalanceDialog # intention.last == "001" || intention.last == "002"
            else
              AgentTransferBlock
            end
        else # PRODUCT = "Loan"
            AgentTransferBlock
        end
    end

    def go_confirmation session
        if is_intention_transfer_agent(session)
            ConfirmIntentionToAgentDialog
        else
            ConfirmIntentionDialog
        end
    end

    def get_dialog_property session, dialog_name=""
        begin
            dialog_name = dialog_name.present? ? dialog_name : session['dialog_name']
            dialog_property = DIALOG_PROPERTY
            result = dialog_property[dialog_name]
            result
        rescue
            result = {}
        end
    end

    def get_intention_list session
        begin
            result = INTENTION_LIST
            result
        rescue
            result = {}
        end
    end

    def get_product_prompt session, product_name=""
        begin
            product_list = PRODUCT_LIST
            product_name = session["result_item"]["product"] if product_name.blank?
            prompt = product_list[product_name]["prompt"]
        rescue
            prompt = ""
        end
        prompt
    end

    def get_confirmation_dialog dialog_name
        dialog = DIALOG_PROPERTY[dialog_name]
        confirmation_mode = dialog["confirmation_option"].parameterize.underscore.to_sym
        confirmation_mode
    end

    def get_intention_prompt session, intention_code=""
        begin
            intention_list = INTENTION_LIST
            intention_code = session["result_item"]["intention"] if intention_code.blank?
            prompt = intention_list["code_#{intention_code}"]["prompt"]
        rescue
            prompt = ""
        end
        prompt
    end

    def set_initial_variable session, dialog_name
        session['action_state'] = ""
        dialog_property = DIALOG_PROPERTY[dialog_name]
        if dialog_property['reset_initial_variable']['is_reset'] ### reset counter 
            session['retry'] = dialog_property['reset_initial_variable']['retry']
            session['reject'] = dialog_property['reset_initial_variable']['reject']
            session['timeout'] = dialog_property['reset_initial_variable']['timeout']
            session['max_retry'] = dialog_property['max_retry']
            session['max_reject'] = dialog_property['max_reject']
            session['max_timeout'] = dialog_property['max_timeout']
        end
    end

    def increase_timeout session
        session['action_state'] = 'timeout'
        session['timeout'] = 0 if session['timeout'].nil?
        session['timeout'] = session['timeout'] + 1
    end
    
    def increase_retry session
        session['action_state'] = 'retry'
        session['retry'] = 0 if session['retry'].nil?
        session['retry'] = session['retry'] + 1
    end
    
    def increase_reject session
        session['action_state'] = 'reject'
        session['reject'] = 0 if session['reject'].nil?
        session['reject'] = session['reject'] + 1
    end

    def timeout_exceeded? session
        session['timeout'] = 0 if session['timeout'].nil?
        session['max_timeout'] = DIALOG_PROPERTY[session['dialog_name']]['max_timeout'] if session['max_timeout'].nil?
    
        result = session['timeout'] > session['max_timeout']
        result
    end
    
    def retry_exceeded? session
        session['retry'] = 0 if session['retry'].nil?
        session['max_retry'] = DIALOG_PROPERTY[session['dialog_name']]['max_retry'] if session['max_retry'].nil?
    
        result = session['retry'] > session['max_retry']
        result
    end
    
    def reject_exceeded? session
        session['reject'] = 0 if session['reject'].nil?
        session['max_reject'] = DIALOG_PROPERTY[session['dialog_name']]['max_reject'] if session['max_reject'].nil?
    
        result = session['reject'] > session['max_reject']
        result
    end

    def total_retry session
        session['timeout'] = 0 if session['timeout'].nil?
        session['reject'] = 0 if session['reject'].nil?
        session['retry'] = 0 if session['retry'].nil?
        total = session['timeout'] + session['reject'] + session['retry']
        total
    end

    def total_exceeded? session
        session['timeout'] = 0 if session['timeout'].nil?
        session['retry'] = 0 if session['retry'].nil?
        session['reject'] = 0 if session['reject'].nil?
        session['max_retry'] = DIALOG_PROPERTY[session['dialog_name']]['max_retry'] if session['max_retry'].nil?

        result = (session['timeout'] + session['reject'] + session['retry']) > session['max_retry']
        result
    end

    def timeout? session
        is_no_speech = false
        is_no_speech = session['retry_count']['noinput'] == session['retry_count']['total'] unless session['retry_count'].nil?
        result = false
        result = true if session['result'] == 'failure' && is_no_speech
        result
    end

    def rejected? session, is_use_grammar = false
        is_no_speech = false
        begin
            is_no_speech = session['retry_count']['noinput'] == session['retry_count']['total'] unless session['retry_count'].nil?
            result = false
            result = true if session['result'] == 'failure' && !is_no_speech
        rescue StandardError => e
            result = true
        end
        if (!is_use_grammar && result == false)
          result = is_reject_by_nlu(session) 
        end
        result
    end

    def is_reject_by_nlu session
        is_reject = false
        begin
          prediction = session['nl_result']['nlu']['prediction']['results']
          is_reject = prediction['semantic_tag'].downcase == 'reject'
        rescue StandardError => e
          is_reject = false
        end
        is_reject
    end

    def save_result session
        result = session["result_item"].present? ? session["result_item"] : {}
        session["result_item"] = result if session["result_item"].blank?
        product = get_product(session)
        intention = get_intention(session)
        iden_id = get_iden_id(session)
        result["product"] = product
        result["intention"] = intention
        result["iden_id"] = iden_id
        session["result_item"] = result
    end

    def get_product session
        begin
            if session["result_item"]["product"].blank?
                result = session["nl_result"]["nlu"]['keyword_extraction']["product"].last
            else
                result = session["result_item"]["product"]
            end

            #### MOCK
            #speech = session["result"].split(" ").join()
            #if ["บัตรเครดิต","เครดิตการ์ด","เครดิต"].include?(speech)
            #    result = "credit_card" 
            #elsif ["บัญชี","บัญชีเงินฝาก","เงินฝาก","ธนาคาร"].include?(speech)
            #    result = "bank_account"
            #elsif ["สินเชื่อ"].include?(speech)
            #    result = "loan"
            #end
        rescue StandardError
           result = ""
        end
        result
    end

    def get_intention session
        begin
            if session["result_item"]["intention"].blank?
                result = []
                intention = session["nl_result"]["nlu"]["prediction"]["results"]
                intention.each do |i|
                    result << i["intention_code"] if i["intention_code"].present?
                end
            else
                result = session["result_item"]["intention"]
            end

            #### MOCK 
            # speech = session["result"].split(" ").join()
            # if speech == "สอบถามยอด"
            #     result = "001"
            # elsif ["สอบถามยอดคงเหลือ", "ยอดคงเหลือ"].include?(speech)
            #   result = "002"
            # elsif ["สอบถามยอดค้างชำระ", "ยอดค้างชำระ"].include?(speech)
            #   result = "003"
            # elsif ["สอบถามยอดที่ใช้ไป", "ยอดที่ใช้ไป", "ยอดที่ใช้"].include?(speech)
            #   result = "004"
            # end
        rescue StandardError
           result = Array.new
        end
        result
    end

    def get_iden_id session
        begin
            result = session["nl_result"]["nlu"]['keyword_extraction']["iden_id"]
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
        resutl = session["result_item"]["intention"].length == 1 ? true : false
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
        resutl = false
        resutl
    end

    def is_transfer_ivr session
        result = false
        result
    end

    def is_intention_transfer_agent session
        result = false
        result
    end

    def check_confidence session, threshold
        result = get_confidence_score(session) > threshold
        result
    end

    def get_confidence_score session
        confidence_score = 0.0
        begin
          confidence_score = session['nl_result']['asr']['confidence_score'].to_f unless session['nl_result']['asr']['confidence_score'].nil?
        rescue => e
          # TODO: save e.message to tracking log
          confidence_score = 0.0
        end
        confidence_score
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

end

module AmiCallResult
    SUCCESS           = 'S'.freeze
    TOO_MANY_ERRORS   = 'T'.freeze
    EXIT              = 'X'.freeze
    HANGUP            = 'H'.freeze
    SYSTEM_ERROR      = 'E'.freeze
end