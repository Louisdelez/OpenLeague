package com.riotgames.platform.gameclient.controllers.game.views.popup
{
   import flash.display.DisplayObject;
   
   public interface ITipPopupManager
   {
      
      function removePopup(param1:*) : void;
      
      function removeAllPopups() : void;
      
      function createTipPopup(param1:DisplayObject, param2:String, param3:String, param4:String, param5:Number = -1, param6:Number = -1, param7:Number = -1, param8:Number = -1) : void;
   }
}

