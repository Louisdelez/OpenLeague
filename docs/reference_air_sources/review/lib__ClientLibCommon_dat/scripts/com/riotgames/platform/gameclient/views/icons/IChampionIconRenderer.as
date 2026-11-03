package com.riotgames.platform.gameclient.views.icons
{
   import com.riotgames.platform.gameclient.domain.Champion;
   
   public interface IChampionIconRenderer extends IIconRenderer
   {
      
      function loadChampionIcon(param1:Champion) : void;
      
      function loadChampionIconBySkinName(param1:String) : void;
   }
}

