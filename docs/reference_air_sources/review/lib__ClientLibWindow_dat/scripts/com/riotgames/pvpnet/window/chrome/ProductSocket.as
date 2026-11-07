package com.riotgames.pvpnet.window.chrome
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   
   public class ProductSocket extends SpriteProxy
   {
      
      private var sizer:SpriteProxy;
      
      public function ProductSocket(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("productPickerHolder",this.sizer);
      }
      
      public function getProductPlacement() : SpriteProxy
      {
         return this.sizer;
      }
   }
}

