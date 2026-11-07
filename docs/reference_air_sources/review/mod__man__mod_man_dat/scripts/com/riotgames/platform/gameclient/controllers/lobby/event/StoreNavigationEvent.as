package com.riotgames.platform.gameclient.controllers.lobby.event
{
   import flash.events.Event;
   
   public class StoreNavigationEvent extends Event
   {
      
      public static const STORE_NAVIGATE:String = "storeNavigate";
      
      public static const STORE_REFRESH:String = "storeRefresh";
      
      public var storeQueryString:String;
      
      public var storeRelativeUrl:String;
      
      public function StoreNavigationEvent(param1:String, param2:String, param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.storeRelativeUrl = param2;
         this.storeQueryString = param3;
      }
      
      override public function clone() : Event
      {
         return new StoreNavigationEvent(type,this.storeRelativeUrl,this.storeQueryString,bubbles,cancelable);
      }
   }
}

