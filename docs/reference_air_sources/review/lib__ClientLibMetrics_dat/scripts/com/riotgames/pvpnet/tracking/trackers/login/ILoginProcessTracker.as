package com.riotgames.pvpnet.tracking.trackers.login
{
   [GenerateProxy]
   public interface ILoginProcessTracker
   {
      
      function loginInitiated() : void;
      
      function landingPageLoaded() : void;
      
      function setLoginRetryAttempts(param1:uint) : void;
      
      function maxRetryAttemptsReached() : void;
      
      function loginFailedOnError(param1:String) : void;
      
      function loginFailedWithAuthResult(param1:String) : void;
      
      function loginFailedOnFaultEvent(param1:int) : void;
      
      function loginFailedWithUnknown(param1:Object) : void;
      
      function authenticationSucceeded() : void;
      
      function joinedQueue(param1:int, param2:Number) : void;
      
      function cancelledQueue() : void;
      
      function reachedLoginScreen() : void;
      
      function setLastUserFacingError(param1:String) : void;
   }
}

