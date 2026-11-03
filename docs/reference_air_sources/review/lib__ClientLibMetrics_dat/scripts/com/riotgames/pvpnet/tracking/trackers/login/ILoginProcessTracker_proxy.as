package com.riotgames.pvpnet.tracking.trackers.login
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class ILoginProcessTracker_proxy implements IProxyObject, ILoginProcessTracker
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ILoginProcessTracker_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function loginInitiated() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("loginInitiated",[],_loc1_);
      }
      
      public function landingPageLoaded() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("landingPageLoaded",[],_loc1_);
      }
      
      public function setLoginRetryAttempts(param1:uint) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("setLoginRetryAttempts",[param1],_loc2_);
      }
      
      public function maxRetryAttemptsReached() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("maxRetryAttemptsReached",[],_loc1_);
      }
      
      public function loginFailedOnError(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("loginFailedOnError",[param1],_loc2_);
      }
      
      public function loginFailedWithAuthResult(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("loginFailedWithAuthResult",[param1],_loc2_);
      }
      
      public function loginFailedOnFaultEvent(param1:int) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("loginFailedOnFaultEvent",[param1],_loc2_);
      }
      
      public function loginFailedWithUnknown(param1:Object) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("loginFailedWithUnknown",[param1],_loc2_);
      }
      
      public function authenticationSucceeded() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("authenticationSucceeded",[],_loc1_);
      }
      
      public function joinedQueue(param1:int, param2:Number) : void
      {
         var _loc3_:* = null;
         _loc3_ = this.__proxy.__methodInvoke("joinedQueue",[param1,param2],_loc3_);
      }
      
      public function cancelledQueue() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("cancelledQueue",[],_loc1_);
      }
      
      public function reachedLoginScreen() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("reachedLoginScreen",[],_loc1_);
      }
      
      public function setLastUserFacingError(param1:String) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("setLastUserFacingError",[param1],_loc2_);
      }
   }
}

