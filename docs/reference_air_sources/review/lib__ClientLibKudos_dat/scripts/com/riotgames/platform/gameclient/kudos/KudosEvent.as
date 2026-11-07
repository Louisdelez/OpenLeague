package com.riotgames.platform.gameclient.kudos
{
   import flash.events.Event;
   
   public class KudosEvent extends Event
   {
      
      public static const KUDOS_GIVEN:String = "kudosGiven";
      
      public static const OUT_OF_KUDOS:String = "outOfKudos";
      
      public var recipientID:Number;
      
      public var summonerID:Number;
      
      public var gameID:Number;
      
      public function KudosEvent(param1:String, param2:Number, param3:Number, param4:Number, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this.summonerID = param2;
         this.recipientID = param3;
         this.gameID = param4;
      }
      
      override public function clone() : Event
      {
         return new KudosEvent(type,this.summonerID,this.recipientID,this.gameID,bubbles,cancelable);
      }
   }
}

