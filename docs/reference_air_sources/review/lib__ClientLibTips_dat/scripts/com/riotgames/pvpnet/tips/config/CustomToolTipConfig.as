package com.riotgames.pvpnet.tips.config
{
   import blix.context.IContext;
   
   public class CustomToolTipConfig extends ToolTipConfig
   {
      
      private var _viewContext:IContext;
      
      public function CustomToolTipConfig()
      {
         super();
         this.cacheView = false;
      }
      
      public function get viewContext() : IContext
      {
         return this._viewContext;
      }
      
      public function set viewContext(param1:IContext) : void
      {
         this._viewContext = param1;
      }
   }
}

