package com.riotgames.platform.gameclient.controllers.game.event
{
   import flash.events.Event;
   
   public class BanEvent extends Event
   {
      
      public static const CHAMPION_BANNED:String = "banEvent";
      
      private var _bannedChampionId:int;
      
      public function BanEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._bannedChampionId = param2;
      }
      
      public function get bannedChampionId() : int
      {
         return this._bannedChampionId;
      }
      
      override public function clone() : Event
      {
         return new BanEvent(type,this.bannedChampionId,bubbles,cancelable);
      }
   }
}

