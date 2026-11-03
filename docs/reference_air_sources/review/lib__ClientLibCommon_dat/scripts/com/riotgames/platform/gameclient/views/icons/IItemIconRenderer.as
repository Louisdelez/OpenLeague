package com.riotgames.platform.gameclient.views.icons
{
   import com.riotgames.platform.gameclient.domain.GameItem;
   
   public interface IItemIconRenderer extends IIconRenderer
   {
      
      function loadItemVisual(param1:GameItem) : void;
      
      function loadItemVisualById(param1:int) : void;
      
      function loadIconEmptyVisual() : void;
   }
}

