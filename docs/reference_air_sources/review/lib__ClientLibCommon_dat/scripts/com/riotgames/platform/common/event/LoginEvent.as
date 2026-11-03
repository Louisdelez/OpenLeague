package com.riotgames.platform.common.event
{
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   
   public class LoginEvent extends ShellEvent
   {
      
      public static const LOGIN:String = "SHELL_EVENT_LOGIN";
      
      public static const LOGOUT:String = "SHELL_EVENT_LOGOUT";
      
      private var _loginData:ServerSessionObject;
      
      public function LoginEvent(param1:String)
      {
         super(param1);
      }
      
      public function get loginData() : ServerSessionObject
      {
         return this._loginData;
      }
      
      public function set loginData(param1:ServerSessionObject) : void
      {
         this._loginData = param1;
      }
   }
}

