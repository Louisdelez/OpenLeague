package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   
   public interface IMasteriesManager
   {
      
      function setMasteryPage(param1:MasteryPageInfoSummary) : void;
      
      function loadMasteries() : void;
   }
}

