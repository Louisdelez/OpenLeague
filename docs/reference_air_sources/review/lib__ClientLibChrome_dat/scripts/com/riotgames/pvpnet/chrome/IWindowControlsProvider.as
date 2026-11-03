package com.riotgames.pvpnet.chrome
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IWindowControlsProvider extends IProvider
   {
      
      function requestMinimize() : void;
      
      function beginResize(param1:String) : void;
      
      function beginDrag() : void;
      
      function setToDefaultSize() : void;
   }
}

