package com.riotgames.platform.gameclient.shell.modules.provider
{
   import com.riotgames.pvpnet.system.shell.IScaleFreeProvider;
   import flash.display.DisplayObjectContainer;
   
   public class ScaleFreeProviderImpl implements IScaleFreeProvider
   {
      
      private var _scaleFreeZone:DisplayObjectContainer;
      
      public function ScaleFreeProviderImpl()
      {
         super();
      }
      
      public function setScaleFreeZone(param1:DisplayObjectContainer) : void
      {
         this._scaleFreeZone = param1;
      }
      
      public function getScaleFreeZone() : DisplayObjectContainer
      {
         return this._scaleFreeZone;
      }
   }
}

