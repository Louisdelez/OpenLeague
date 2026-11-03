package com.riotgames.platform.gameclient.module.login.event
{
   import flash.events.Event;
   
   public class LoginViewEvent extends Event
   {
      
      public static const UPDATE_LOGINNAME:String = "UPDATE_LOGINNAME";
      
      public static const UPDATE_REMEMBER_LOGINNAME:String = "UPDATE_REMEMBER_LOGINNAME";
      
      public static const UPDATE_MUTE_LOGIN_MUSIC:String = "UPDATE_MUTE_LOGIN_MUSIC";
      
      public static const UPDATE_ENABLE_ANIMATIONS:String = "UPDATE_ENABLE_ANIMATIONS";
      
      public static const RECONNECT_TO_GAME:String = "RECONECT_TO_GAME";
      
      private var _data:String;
      
      public function LoginViewEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         this._data = param2;
         super(param1,param3,param4);
      }
      
      public function get data() : String
      {
         return this._data;
      }
      
      override public function toString() : String
      {
         return formatToString("LoginViewEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new LoginViewEvent(type,this._data,bubbles,cancelable);
      }
   }
}

