package com.riotgames.platform.gameclient.module.login.view
{
   import flash.events.Event;
   
   public class InitiateLoginEvent extends Event
   {
      
      public static const INITIATE_LOGIN:String = "INITIATE_LOGIN";
      
      private var _username:String;
      
      private var _password:String;
      
      public function InitiateLoginEvent(param1:String, param2:String)
      {
         super(INITIATE_LOGIN,false,true);
         this._username = param1;
         this._password = param2;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function get password() : String
      {
         return this._password;
      }
   }
}

