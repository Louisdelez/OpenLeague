package com.riotgames.pvpnet.tracking.trackers.login
{
   import com.riotgames.pvpnet.tracker.ITracker;
   import com.riotgames.pvpnet.tracker.Tracker;
   
   public class LoginProcessTracker extends Tracker implements ILoginProcessTracker
   {
      
      private static const LOGIN:String = "login";
      
      private static const LOGIN_PAGE__TIME_ON_PAGE__BEFORE_SUBMIT:String = "login_page__time_on_page__before_submit";
      
      private static const PERCEIVED_LOGIN_TIME:String = "perceived_login";
      
      private static const ACTUAL_LOGIN_TIME:String = "actual_login";
      
      private static const QUEUE_TIME:String = "queue";
      
      private static const ERRORS:String = "errors";
      
      private static const AUTH_RETRY_ATTEMPTS:String = "auth_retry_attempts";
      
      private static const CANCELLED:String = "cancelled";
      
      private static const ESTIMATED_DURATION:String = "estimated_duration";
      
      private static const INITIAL_DEPTH:String = "initial_depth";
      
      private static const ERROR_COUNT:String = "error_count";
      
      private static const SUCCESS:String = "success";
      
      private static const TIME_STAMP:String = "time_stamp";
      
      private static const UNKNOWN_INSECURE:String = "unknown_insecure";
      
      private static const UNKNOWN:String = "unknown";
      
      private static const DESCRIPTION:String = "description";
      
      private static const CREDENTIALS:String = "credentials";
      
      private static const PASS:String = "pass";
      
      private static const MAX_RETRY_ERROR_REACHED:String = "max_retry_error_reached";
      
      private static const FAULT_EVENT_:String = "fault_event_";
      
      private static const LOGIN_ERROR_:String = "login_error_";
      
      private static const AUTH_RESULT_:String = "auth_result_";
      
      private static const FINAL_USER_FACING_ERROR:String = "final_user_facing_error";
      
      private var _weHaveDataFromAPreviousAttempt:Boolean = false;
      
      private var errorCount:int = 0;
      
      private var hasAuthenticationSuccess:Boolean = false;
      
      public function LoginProcessTracker()
      {
         super(LOGIN);
         isTimer = false;
      }
      
      public function cancelledQueue() : void
      {
         if(has(QUEUE_TIME))
         {
            get(QUEUE_TIME).setProperty(CANCELLED,true);
         }
         remove([ACTUAL_LOGIN_TIME,PERCEIVED_LOGIN_TIME]);
         this.sendAndReset();
         add(LOGIN_PAGE__TIME_ON_PAGE__BEFORE_SUBMIT).start();
      }
      
      public function reachedLoginScreen() : void
      {
         add(LOGIN_PAGE__TIME_ON_PAGE__BEFORE_SUBMIT).start();
      }
      
      public function joinedQueue(param1:int, param2:Number) : void
      {
         add(QUEUE_TIME).setProperty(INITIAL_DEPTH,param1).setProperty(ESTIMATED_DURATION,param2).start();
      }
      
      public function setLastUserFacingError(param1:String) : void
      {
         setProperty(FINAL_USER_FACING_ERROR,param1);
      }
      
      public function authenticationSucceeded() : void
      {
         setProperty(SUCCESS,true);
         this.hasAuthenticationSuccess = true;
         if(has(QUEUE_TIME))
         {
            get(QUEUE_TIME).stop();
         }
         if(has(ACTUAL_LOGIN_TIME))
         {
            get(ACTUAL_LOGIN_TIME).stop();
         }
         if(this.errorCount > 0)
         {
            get(ERRORS,true).setProperty(ERROR_COUNT,this.errorCount);
         }
      }
      
      public function loginInitiated() : void
      {
         if(this._weHaveDataFromAPreviousAttempt)
         {
            this.sendAndReset();
         }
         else
         {
            get(LOGIN_PAGE__TIME_ON_PAGE__BEFORE_SUBMIT).stop();
         }
         this.setLoginRetryAttempts(0);
         add(PERCEIVED_LOGIN_TIME).start();
         add(ACTUAL_LOGIN_TIME).start();
      }
      
      override public function send() : ITracker
      {
         return super.send();
      }
      
      public function loginFailedOnError(param1:String) : void
      {
         this.fail(LOGIN_ERROR_ + param1);
      }
      
      private function sendAndReset() : void
      {
         stopAndSendAll();
         resetAllToDefaults();
         this._weHaveDataFromAPreviousAttempt = false;
      }
      
      private function fail(param1:String) : void
      {
         ++this.errorCount;
         get(ERRORS,true).setProperty(DESCRIPTION,param1).setProperty(ERROR_COUNT,this.errorCount).addTimeStampedEvent(TIME_STAMP);
         setProperty(SUCCESS,false);
         remove([ACTUAL_LOGIN_TIME,PERCEIVED_LOGIN_TIME,QUEUE_TIME]);
         this._weHaveDataFromAPreviousAttempt = true;
      }
      
      public function setLoginRetryAttempts(param1:uint) : void
      {
         setProperty(AUTH_RETRY_ATTEMPTS,param1);
      }
      
      public function landingPageLoaded() : void
      {
         if(has(PERCEIVED_LOGIN_TIME))
         {
            get(PERCEIVED_LOGIN_TIME).stop();
         }
         if(!hasBeenSent)
         {
            this.sendAndReset();
         }
      }
      
      public function maxRetryAttemptsReached() : void
      {
         this.fail(MAX_RETRY_ERROR_REACHED);
      }
      
      public function loginFailedWithAuthResult(param1:String) : void
      {
         this.fail(AUTH_RESULT_ + param1);
      }
      
      public function loginFailedOnFaultEvent(param1:int) : void
      {
         this.fail(FAULT_EVENT_ + param1.toString());
      }
      
      public function loginFailedWithUnknown(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            _loc2_ = param1 as String;
         }
         else if(param1 as String)
         {
            _loc2_ = new String(param1);
         }
         if(_loc2_ != null)
         {
            if(_loc2_.indexOf(PASS) >= 0 || _loc2_.indexOf(CREDENTIALS) >= 0)
            {
               this.fail(UNKNOWN_INSECURE);
            }
            else
            {
               this.fail(_loc2_);
            }
         }
         else
         {
            this.fail(UNKNOWN);
         }
      }
   }
}

