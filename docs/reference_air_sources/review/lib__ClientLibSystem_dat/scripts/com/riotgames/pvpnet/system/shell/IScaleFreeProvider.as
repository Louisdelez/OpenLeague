package com.riotgames.pvpnet.system.shell
{
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   
   public interface IScaleFreeProvider extends IProvider
   {
      
      function setScaleFreeZone(param1:DisplayObjectContainer) : void;
      
      function getScaleFreeZone() : DisplayObjectContainer;
   }
}

