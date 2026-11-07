package com.riotgames.platform.gameclient.kudos
{
   import flash.events.EventDispatcher;
   
   public class KudosButtonDisabled extends EventDispatcher implements IKudosButton
   {
      
      public function KudosButtonDisabled()
      {
         super();
      }
      
      public function get enabled() : Boolean
      {
         return false;
      }
      
      public function cleanup() : void
      {
      }
      
      public function set enabled(param1:Boolean) : void
      {
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
      }
   }
}

