package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class NewMatchHistoryChampionRenderer extends SpriteProxy
   {
      
      private var _champion:Champion;
      
      private var _icon:BitmapProxy;
      
      public function NewMatchHistoryChampionRenderer(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
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
      
      public function setChampion(param1:Champion) : void
      {
         var _loc2_:BitmapData = null;
         if(param1 == this._champion)
         {
            return;
         }
         this._champion = param1;
         if(this._champion)
         {
            _loc2_ = ChampionIconCacheUtil.instance.getIcon(this._champion.skinName);
            this._icon.setBitmapData(_loc2_);
         }
         else
         {
            this._icon.setBitmapData(null);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._icon.setExplicitSize(param1,param2);
         return super.updateLayout(param1,param2);
      }
   }
}

