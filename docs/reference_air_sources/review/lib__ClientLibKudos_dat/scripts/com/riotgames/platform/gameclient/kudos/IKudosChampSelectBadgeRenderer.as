package com.riotgames.platform.gameclient.kudos
{
   import flash.display.DisplayObjectContainer;
   
   public interface IKudosChampSelectBadgeRenderer
   {
      
      function addAsChildOf(param1:DisplayObjectContainer) : void;
      
      function updateLayout(param1:Number, param2:Number) : void;
      
      function displayAppropriateBadge(param1:int, param2:int, param3:Boolean) : Boolean;
   }
}

