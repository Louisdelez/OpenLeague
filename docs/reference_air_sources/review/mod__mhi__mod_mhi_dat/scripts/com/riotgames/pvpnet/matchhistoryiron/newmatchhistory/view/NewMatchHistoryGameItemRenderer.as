package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.ImagePackLookup;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class NewMatchHistoryGameItemRenderer extends SpriteProxy
   {
      
      private var _item:GameItem;
      
      private var _icon:BitmapProxy;
      
      public function NewMatchHistoryGameItemRenderer(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function createChildren() : void
      {
         this._icon = new BitmapProxy(this);
         this._icon.setSmoothing(true);
         this._icon.getLayoutInvalidated().add(invalidateLayout);
         this._icon.setTransformBehavior(new ScalingTransformBehavior());
         addChild(this._icon);
         super.createChildren();
      }
      
      public function setGameItem(param1:GameItem) : void
      {
         this._item = param1;
         if(this._item)
         {
            this._icon.setAlpha(1);
            this._icon.setBitmapData(ImagePackLookup.instance.getBitmapData("e_" + this._item.icon.substring(0,this._item.icon.length - 4)));
         }
         else
         {
            this._icon.setAlpha(0.75);
            this._icon.setBitmapData(ImagePackLookup.instance.getBitmapData("e_EmptyIcon"));
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._icon.setExplicitSize(param1,param2);
         return super.updateLayout(param1,param2);
      }
   }
}

