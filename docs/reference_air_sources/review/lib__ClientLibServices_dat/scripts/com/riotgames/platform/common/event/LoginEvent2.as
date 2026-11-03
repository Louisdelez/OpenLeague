package com.riotgames.platform.common.event
{
   import flash.events.Event;
   
   public class LoginEvent2 extends Event
   {
      
      public static var LOGIN:String = "login2";
      
      public function LoginEvent2()
      {
         super(LoginEvent2.LOGIN,false,false);
      }
   }
}

