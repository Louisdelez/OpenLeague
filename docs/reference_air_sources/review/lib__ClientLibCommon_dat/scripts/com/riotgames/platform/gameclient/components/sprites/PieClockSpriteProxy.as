package com.riotgames.platform.gameclient.components.sprites
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.utils.PieClockGraphicsUtil;
   
   public class PieClockSpriteProxy extends SpriteProxy
   {
      
      private var _percentComplete:Number;
      
      public function PieClockSpriteProxy(param1:IContext)
      {
         super(param1);
      }
      
      private function update() : void
      {
         PieClockGraphicsUtil.drawPieClockGraphic(getGraphics(),this._percentComplete);
      }
      
      public function set percentComplete(param1:Number) : void
      {
         this._percentComplete = param1;
         this.update();
      }
   }
}

