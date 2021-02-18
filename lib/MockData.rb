module MockData
    class << self
      def no_utterance()
        {
          "nlu"=> {
            "version"=>"0.0.2",
            "semi_norm_text"=>"",
            "prediction"=> {
              "results"=> [{
                "product_tags"=>{
                  "from_keywords"=>[], 
                  "from_semantic"=>[]
                },
                "confirm_with_product"=>false,
                "intention_tag"=>"",
                "semantic_tag_rank"=>-1,
                "semantic_tag_en"=>"",
                "intention_code"=>"",
                "semantic_tag"=>"reject",
                "found_semantic_related_words"=>[],
                "audio_filename"=>nil,
                "semantic_id"=>nil
              }]
            },
            "norm_text"=>"",
            "keyword_extraction"=>{
              "payment_method"=>nil,
              "end_date_time"=>{
                "end_minute"=>0,
                "end_hour"=>0,
                "start_minute"=>0,
                "year"=>nil,
                "month"=>nil,
                "day"=>nil,
                "start_hour"=>0
              },
              "amount"=>[],
              "telephone_number"=>nil,
              "number_of_account"=>nil,
              "date_of_birth"=>nil,
              "start_date_time"=>{
                "end_minute"=>0,
                "end_hour"=>0,
                "start_minute"=>0,
                "year"=>nil,
                "month"=>nil,
                "day"=>nil,
                "start_hour"=>0
              },
              "account_number"=>nil,
              "credit_card_payment_method"=>nil,
              "card_name"=>nil,
              "day_of_birth"=>nil,
              "transaction_type"=>nil,
              "thai_citizen_id"=>nil,
              "expiration_date"=>nil,
              "card_number"=>nil
            }
          },
          "asr"=> nil
        }
      end
  
      def no_intention()
        {
          "nlu"=> {
            "version"=>"0.0.2",
            "semi_norm_text"=>"",
            "prediction"=> {
              "results"=> [{
                "product_tags"=>{
                  "from_keywords"=>[], 
                  "from_semantic"=>[]
                },
                "confirm_with_product"=>false,
                "intention_tag"=>"",
                "semantic_tag_rank"=>-1,
                "semantic_tag_en"=>"",
                "intention_code"=>"",
                "semantic_tag"=>"reject",
                "found_semantic_related_words"=>[],
                "audio_filename"=>nil,
                "semantic_id"=>nil
              }]
            },
            "norm_text"=>"",
            "keyword_extraction"=>{
              "payment_method"=>nil,
              "end_date_time"=>{
                "end_minute"=>0,
                "end_hour"=>0,
                "start_minute"=>0,
                "year"=>nil,
                "month"=>nil,
                "day"=>nil,
                "start_hour"=>0
              },
              "amount"=>[],
              "telephone_number"=>nil,
              "number_of_account"=>nil,
              "date_of_birth"=>nil,
              "start_date_time"=>{
                "end_minute"=>0,
                "end_hour"=>0,
                "start_minute"=>0,
                "year"=>nil,
                "month"=>nil,
                "day"=>nil,
                "start_hour"=>0
              },
              "account_number"=>nil,
              "credit_card_payment_method"=>nil,
              "card_name"=>nil,
              "day_of_birth"=>nil,
              "transaction_type"=>nil,
              "thai_citizen_id"=>nil,
              "expiration_date"=>nil,
              "card_number"=>nil
            }
          },
          "asr"=> {
            "utterance"=>"สวัสดี ครับ ผม",
            "confidence_score"=>0.956,
            "status"=>"A",
            "rule"=>""
          }
        }
      end
  
      def contained_intention_request_hello_cash()
        {"nlu"=>
          {"version"=>"0.0.2",
           "semi_norm_text"=>"ทำรายการ Hello Cash",
           "prediction"=>
            {"results"=>
              [{"product_tags"=>
                 {"from_keywords"=>[],
                  "from_semantic"=>
                   ["banking",
                    "credit_card",
                    "edc",
                    "gts",
                    "hire_purchase",
                    "home_loan",
                    "insurance",
                    "invesment",
                    "open_end_fund",
                    "pvd",
                    "securities",
                    "speedy_cash",
                    "speedy_loan"]},
                "confirm_with_product"=>true,
                "intention_tag"=>"request-hello-cash",
                "semantic_tag_rank"=>1,
                "semantic_tag_en"=>"hello cash",
                "intention_code"=>"007",
                "semantic_tag"=>"ทำรายการ Hello Cash",
                "found_semantic_related_words"=>[],
                "audio_filename"=>nil,
                "semantic_id"=>512}]},
           "norm_text"=>"ทำรายการ Hello Cash",
           "keyword_extraction"=>
            {"payment_method"=>nil,
             "end_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "amount"=>[],
             "telephone_number"=>nil,
             "number_of_account"=>nil,
             "date_of_birth"=>nil,
             "start_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "account_number"=>nil,
             "credit_card_payment_method"=>nil,
             "card_name"=>nil,
             "day_of_birth"=>nil,
             "transaction_type"=>nil,
             "thai_citizen_id"=>nil,
             "expiration_date"=>nil,
             "card_number"=>nil}},
         "asr"=>
          {"utterance"=>"ทำรายการ Hello Cash",
           "confidence_score"=>0.852,
           "status"=>"A",
           "rule"=>""}}
      end
  
      def contained_intention_enquire_balance()
        {"nlu"=>
          {"version"=>"0.0.2",
           "semi_norm_text"=>"ถาม ยอด",
           "prediction"=>
            {"results"=>
              [{"product_tags"=>
                 {"from_keywords"=>[],
                  "from_semantic"=>
                   ["banking",
                    "credit_card",
                    "edc",
                    "gts",
                    "hire_purchase",
                    "home_loan",
                    "insurance",
                    "invesment",
                    "open_end_fund",
                    "pvd",
                    "securities",
                    "speedy_cash",
                    "speedy_loan"]},
                "confirm_with_product"=>true,
                "intention_tag"=>"enquire-balance",
                "semantic_tag_rank"=>1,
                "semantic_tag_en"=>"balance inquiry",
                "intention_code"=>"007",
                "semantic_tag"=>"ยอด",
                "found_semantic_related_words"=>[],
                "audio_filename"=>nil,
                "semantic_id"=>512}]},
           "norm_text"=>"ถาม ยอด",
           "keyword_extraction"=>
            {"payment_method"=>nil,
             "end_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "amount"=>[],
             "telephone_number"=>nil,
             "number_of_account"=>nil,
             "date_of_birth"=>nil,
             "start_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "account_number"=>nil,
             "credit_card_payment_method"=>nil,
             "card_name"=>nil,
             "day_of_birth"=>nil,
             "transaction_type"=>nil,
             "thai_citizen_id"=>nil,
             "expiration_date"=>nil,
             "card_number"=>nil}},
         "asr"=>
          {"utterance"=>"สอบถาม ยอด",
           "confidence_score"=>0.852,
           "status"=>"A",
           "rule"=>""}}
      end
  
      def contained_intention_enquire_agent()
        {"nlu"=>
          {"version"=>"0.0.2",
           "semi_norm_text"=>"ติดต่อ เจ้าหน้าที่",
           "prediction"=>
            {"results"=>
              [{"product_tags"=>
                 {"from_keywords"=>[],
                  "from_semantic"=>
                   ["banking",
                    "credit_card",
                    "edc",
                    "electronics_service",
                    "gts",
                    "hire_purchase",
                    "home_loan",
                    "insurance",
                    "invesment",
                    "open_end_fund",
                    "pvd",
                    "securities",
                    "speedy_cash",
                    "speedy_loan"]},
                "confirm_with_product"=>true,
                "intention_tag"=>"enquire-agent",
                "semantic_tag_rank"=>1,
                "semantic_tag_en"=>"transfer to agent",
                "intention_code"=>"015",
                "semantic_tag"=>"โอนสายหาเจ้าหน้าที่",
                "found_semantic_related_words"=>[],
                "audio_filename"=>nil,
                "semantic_id"=>719}]},
           "norm_text"=>"ติดต่อ เจ้าหน้าที่",
           "keyword_extraction"=>
            {"payment_method"=>nil,
             "end_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "amount"=>[],
             "telephone_number"=>nil,
             "number_of_account"=>nil,
             "date_of_birth"=>nil,
             "start_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "account_number"=>nil,
             "credit_card_payment_method"=>nil,
             "card_name"=>nil,
             "day_of_birth"=>nil,
             "transaction_type"=>nil,
             "thai_citizen_id"=>nil,
             "expiration_date"=>nil,
             "card_number"=>nil}},
         "asr"=>
          {"utterance"=>"ติดต่อ เจ้าหน้าที่",
           "confidence_score"=>0.999,
           "status"=>"A",
           "rule"=>""}}
      end
  
      def contained_intention_loss_card()
        {"nlu"=>
          {"version"=>"0.0.2",
           "semi_norm_text"=>"แจ้ง บัตรหาย",
           "prediction"=>
            {"results"=>
              [{"product_tags"=>
                 {"from_keywords"=>[],
                  "from_semantic"=>
                   ["banking",
                    "credit_card",
                    "edc",
                    "gts",
                    "hire_purchase",
                    "home_loan",
                    "insurance",
                    "invesment",
                    "open_end_fund",
                    "pvd",
                    "securities",
                    "speedy_cash",
                    "speedy_loan"]},
                "confirm_with_product"=>true,
                "intention_tag"=>"loss-card",
                "semantic_tag_rank"=>1,
                "semantic_tag_en"=>"loss card",
                "intention_code"=>"007",
                "semantic_tag"=>"แจ้ง บัตรหาย",
                "found_semantic_related_words"=>[],
                "audio_filename"=>nil,
                "semantic_id"=>512}]},
           "norm_text"=>"แจ้ง บัตรหาย",
           "keyword_extraction"=>
            {"payment_method"=>nil,
             "end_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "amount"=>[],
             "telephone_number"=>nil,
             "number_of_account"=>nil,
             "date_of_birth"=>nil,
             "start_date_time"=>
              {"end_minute"=>0,
               "end_hour"=>0,
               "start_minute"=>0,
               "year"=>nil,
               "month"=>nil,
               "day"=>nil,
               "start_hour"=>0},
             "account_number"=>nil,
             "credit_card_payment_method"=>nil,
             "card_name"=>nil,
             "day_of_birth"=>nil,
             "transaction_type"=>nil,
             "thai_citizen_id"=>nil,
             "expiration_date"=>nil,
             "card_number"=>nil}},
         "asr"=>
          {"utterance"=>"แจ้ง บัตรหาย",
           "confidence_score"=>0.9,
           "status"=>"A",
           "rule"=>""}}
      end
  
    # end of class and module
    end
  end