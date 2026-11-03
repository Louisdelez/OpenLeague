package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import flash.events.IEventDispatcher;
   
   [Event(name="outOfKudos",type="com.riotgames.platform.gameclient.kudos.KudosEvent")]
   public interface IKudosService extends IEventDispatcher
   {
      
      function sendKudosAcknowledgement(param1:PendingKudos, param2:Function) : void;
      
      function getPendingKudos(param1:Function) : void;
      
      function getTotals(param1:Number, param2:Function) : void;
      
      function giveKudo(param1:Number, param2:Number, param3:Number, param4:Number) : void;
   }
}

