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

    def contain_intension session
        true
    end

    def intention_has_one session
        true
    end

    def has_product session
        true
    end

    def belong_to_product session
        true
    end

    def get_keyword_extraction session
        begin
            result = {}
            result = session['nl_result']['nlu']['keyword_extraction'] unless session['nl_result']['nlu']['keyword_extraction'].nil?
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