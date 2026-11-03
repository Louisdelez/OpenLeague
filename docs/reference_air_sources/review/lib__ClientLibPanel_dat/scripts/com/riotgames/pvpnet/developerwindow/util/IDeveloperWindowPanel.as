package com.riotgames.pvpnet.developerwindow.util
{
   import flash.display.DisplayObject;
   
   public interface IDeveloperWindowPanel
   {
      
      function initializeDeveloperPanel(param1:Object) : void;
      
      function get view() : DisplayObject;
      
      function get displayName() : String;
   }
}

