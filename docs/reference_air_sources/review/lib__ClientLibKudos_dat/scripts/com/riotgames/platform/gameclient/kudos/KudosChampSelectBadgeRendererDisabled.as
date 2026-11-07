package com.riotgames.platform.gameclient.kudos
{
   import flash.display.DisplayObjectContainer;
   
   public class KudosChampSelectBadgeRendererDisabled implements IKudosChampSelectBadgeRenderer
   {
      
      public function KudosChampSelectBadgeRendererDisabled()
      {
         super();
      }
      
      public function addAsChildOf(param1:DisplayObjectContainer) : void
      {
      }
      
      public function updateLayout(param1:Number, param2:Number) : void
      {
      }
      
      public function displayAppropriateBadge(param1:int, param2:int, param3:Boolean) : Boolean
      {
         return false;
      }
   }
}

