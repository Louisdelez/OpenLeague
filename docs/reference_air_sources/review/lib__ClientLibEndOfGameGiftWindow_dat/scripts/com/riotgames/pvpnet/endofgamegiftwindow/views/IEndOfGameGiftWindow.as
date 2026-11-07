package com.riotgames.pvpnet.endofgamegiftwindow.views
{
   import blix.signals.ISignal;
   import blix.view.ILayoutElement;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import flash.display.DisplayObject;
   
   public interface IEndOfGameGiftWindow extends IMainScreen, ILayoutElement
   {
      
      function setGiftedPlayer(param1:IPlayerSummary) : void;
      
      function getGiftSent() : ISignal;
      
      function get display() : DisplayObject;
   }
}

