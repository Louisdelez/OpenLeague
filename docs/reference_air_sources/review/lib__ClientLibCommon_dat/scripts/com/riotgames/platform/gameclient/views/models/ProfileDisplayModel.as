package com.riotgames.platform.gameclient.views.models
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ProfileDisplayModel extends EventDispatcher
   {
      
      public static const SUMMONER_VIEW:String = "SUMMONER";
      
      public static const RANKED_TEAMS_VIEW:String = "RANKED_TEAMS";
      
      public var activeView:String = "SUMMONER";
      
      public function ProfileDisplayModel()
      {
         super();
      }
      
      public function update() : void
      {
         dispatchEvent(new Event("changed"));
      }
   }
}

