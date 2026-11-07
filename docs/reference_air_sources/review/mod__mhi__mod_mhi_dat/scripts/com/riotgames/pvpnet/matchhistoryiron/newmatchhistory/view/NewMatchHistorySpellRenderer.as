package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class NewMatchHistorySpellRenderer extends SpriteProxy
   {
      
      private var _spell:Spell;
      
      private var _icon:BitmapProxy;
      
      public function NewMatchHistorySpellRenderer(param1:IContext)
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
      
      public function setSpell(param1:Spell) : void
      {
         var _loc2_:BitmapData = null;
         this._spell = param1;
         if(this._spell)
         {
            _loc2_ = ImagePackLookup.instance.getSpellBitmap(this._spell).bitmapData;
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

