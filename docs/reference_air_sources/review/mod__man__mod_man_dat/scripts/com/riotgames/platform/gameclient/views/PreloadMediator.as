package com.riotgames.platform.gameclient.views
{
   import flash.utils.getQualifiedClassName;
   import mx.core.Container;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class PreloadMediator
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var champSelectLoader:Container;
      
      public var championGrid:Container;
      
      public function PreloadMediator()
      {
         super();
      }
      
      public function attachChampSelection(param1:Container) : Boolean
      {
         if(param1 == null)
         {
            this.logger.error("PreloadMediator: attachChampSelection failed, newContainer is null");
            return false;
         }
         param1.addChild(this.championGrid);
         return true;
      }
      
      public function registerChampionSelectionLoader(param1:Container, param2:Container) : void
      {
         this.champSelectLoader = param1;
         this.championGrid = param2;
      }
   }
}

