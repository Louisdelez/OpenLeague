package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   
   public class XIFFErrorEvent extends Event
   {
      
      public static var XIFF_ERROR:String = "error";
      
      public static var XIFF_ERROR_AUTHENTICATION:Number = 401;
      
      public static var IO_ERROR_CODE:Number = 1001;
      
      private var _errorCondition:String;
      
      private var _errorMessage:String;
      
      private var _errorType:String;
      
      private var _errorCode:Number;
      
      private var _errorExt:Extension;
      
      private var _errorFrom:EscapedJID;
      
      private var _userInfo:String;
      
      public function XIFFErrorEvent()
      {
         super(XIFFErrorEvent.XIFF_ERROR,false,false);
      }
      
      public function set errorCondition(param1:String) : void
      {
         this._errorCondition = param1;
      }
      
      public function get errorCondition() : String
      {
         return this._errorCondition;
      }
      
      public function set errorMessage(param1:String) : void
      {
         this._errorMessage = param1;
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
      
      public function set errorType(param1:String) : void
      {
         this._errorType = param1;
      }
      
      public function get errorType() : String
      {
         return this._errorType;
      }
      
      public function set errorCode(param1:Number) : void
      {
         this._errorCode = param1;
      }
      
      public function get errorCode() : Number
      {
         return this._errorCode;
      }
      
      public function set errorExt(param1:Extension) : void
      {
         this._errorExt = param1;
      }
      
      public function get errorExt() : Extension
      {
         return this._errorExt;
      }
      
      public function set errorFrom(param1:EscapedJID) : void
      {
         this._errorFrom = param1;
      }
      
      public function get errorFrom() : EscapedJID
      {
         return this._errorFrom;
      }
      
      public function get userInfo() : String
      {
         return this._userInfo;
      }
      
      public function set userInfo(param1:String) : void
      {
         this._userInfo = param1;
      }
   }
}

