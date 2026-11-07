package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public interface IGiftErrorData
   {
      
      function get errorID() : Number;
      
      function get errorTitleText() : String;
      
      function get errorText() : String;
      
      function get errorInfoText() : String;
      
      function get errorInfoLink() : String;
      
      function get doneButtonLabel() : String;
   }
}

