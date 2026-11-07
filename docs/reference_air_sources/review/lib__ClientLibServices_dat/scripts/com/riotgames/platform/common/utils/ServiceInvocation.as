package com.riotgames.platform.common.utils
{
   public class ServiceInvocation
   {
      
      public static const INFO:String = "INFO";
      
      public static const LCDS_REQUEST:String = "LCDS REQUEST";
      
      public static const REST_REQUEST:String = "REST REQUEST";
      
      public static const MAESTRO_REQUEST:String = "MAESTRO REQUEST";
      
      public static const RESPONSE:String = "LCDS RESPONSE";
      
      public static const REST_RESPONSE:String = "REST RESPONSE";
      
      public static const MAESTRO_RESPONSE:String = "MAESTRO RESPONSE";
      
      public static const FAULT:String = "FAULT";
      
      public static const REST_FAULT:String = "FAULT FROM REST";
      
      public static const ASYNC_GAME:String = "ASYNC GAME MESSAGE";
      
      public static const ASYNC_BROADCAST:String = "ASYNC BROADCAST MESSAGE";
      
      public static const ASYNC_CLIENT:String = "ASYNC CLIENT NOTIFICATION MESSAGE";
      
      public static const OUTGOING_XMPP:String = "XMPP OUTGOING MESSAGE";
      
      public static const INCOMING_XMPP:String = "XMPP INCOMING MESSAGE";
      
      public var method:String;
      
      public var service:String;
      
      private var _searchString:String;
      
      public var type:String;
      
      public var args:Array;
      
      public function ServiceInvocation()
      {
         super();
      }
      
      public function set searchString(param1:String) : void
      {
         this._searchString = param1;
      }
      
      public function get searchString() : String
      {
         if(this._searchString == null && this.type != null && this.service != null)
         {
            this._searchString = this.type + ": " + this.service + "." + this.method;
         }
         return this._searchString;
      }
   }
}

