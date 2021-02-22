#= Overview
#
# 'entry_point' method is called from main.vxml to determine first dialog module.  This
# method must return first dialog module name.  You can use DNIS (dialed number), ANI
# (caller number) and other information passed to dialog module by another telephony
# application.
#
#= Arguments
# params  ... Standard Input Parameters.  There are following four information.
#
#   params[:dnis]        ... Dialed number
#   params[:ani]         ... Caller number
#   params[:logging_tag] ... Logging tag
#   params[:request_parameters_key]  ... It's used for only internal. Please ignore.
#
# session ... Session Memory stored in redis.  You can pass information via this session
#             to other dialog modules as well.
#
#   session[:call_start_time] ... Call start time
#   session[:request]         ... Request data which passed by another telephny app.
#                                 The data depends on platform and application.
#
# env ... Rack environment variable. It will be 'development' or 'production'.
#
#= Example of session[:request]
#
# The information in 'request' depends on platform.  Here is an example of AVAYA,
# Genesys (GVP) and Aspect (Prophecy).
#
#== AVAYA Voice Platform (v6.0)
# request : {
#   session___sessionid   : aaep-1-2014178154329-15
#   __VPapploggingurl     : https://172.24.132.33/axis/services/VPReport4
#   __VPapplog            : /axis2/services/VPAppLogService
#   __VPvpms              : 172.24.132.33
#   __VPappvars           : /axis2/services/VPAppVarsService
#   __VPVarAppDate        : 0
#   __VPVarAppURL         : https://172.24.132.33/axis/services/VPAppRuntimeVars
#   __VPVarGlobalDate     : 1390201297432
#   __VPbreadcrumb        : disabled
#   __VPmaxbackuplogfiles : 10
#   __VPlogname           : root
#   __VPlogpassword       : yMDTVerA/luOJbnRlr62taa6ZdN5hnVgfQEQl6UKUGI=
#   __VPloglevel          : Info
#   __VPappname           : Thai Smile ItineraryDialog
# }
#
#== GVP
# request : {
#   session.connection.callidref    E9DB2322-8DA6-4918-9A46-D1AFF80CC913-319@10.21.16.172
#   session.connection.local.uri    sip:866666@10.21.16.172:5060
#   session.connection.originator   remote
#   session.connection.remote.uri   sip:*10043893@10.21.17.161;user
#   session.connection.uuid         UN8P4JO2297TNF65DGKO42HTNC00009S
# }
#
#== Prophecy
# request : {
#   session.accountid       : 1
#   session.calledid        : 100
#   session.virtualplatform : Default
#   session.parentsessionid : 2fcf834d5095f0d8bff2720053f5d62c
#   session.sessionid       : 6fe30b97509519124076128406235ab2
#   session.callerid        : 500
# }
#
#= Note
#== Diffrence between DialPlan and DialPlanV2
# If you do not use 1.1.0 or older version, please ignore this note.
#
# Version 1.1.0 or earlier version uses DialPlan.  The difference is first argument of
# entry_point method
#
#   entry_point dnis, session, env        DialPlan
#   entry_point params, session, env      DialPlanV2
#
# "DNIS" is in params[:dnis] for DialPlanV2.  Also, params[:ani] and params[:logging_tag]
# is available for DialPlanV2.
#
# Still DialPlan (config/dialplan.rb) is supported.  If 'config' directory contains both
# version, DialPlan and DialPlanV2 (config/dialplan_v2.rb), DialPlanV2 will be used and
# DialPlan will be ignored.
#
module AmiVoice::DialogModule
  module DialPlanV2
    class << self
      def entry_point params, session, env
        # Standard Input:
        session.logger.info "ANI: #{params[:ani]}"
        session.logger.info "DNIS: #{params[:dnis]}"
        session.logger.info "LoggingTag: #{params[:logging_tag]}"
        session.logger.info "Environment: #{env}"
        # Application Specific Input:
        session.logger.info "Request: #{session[:request]}"
        
        reset_counter(session)
        # Determine first dialog and return the name.  For exaple,
        MainMenuDialog
      end
    end
  end
end
