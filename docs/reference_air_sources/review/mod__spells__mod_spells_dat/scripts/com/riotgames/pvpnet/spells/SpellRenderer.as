package com.riotgames.pvpnet.spells
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.core.BitmapAsset;
   
   public class SpellRenderer extends StatefulView implements ISelectableRenderer
   {
      
      private static const UNLOCKED:String = "unlocked";
      
      private static const LOCKED:String = "locked";
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _index:uint;
      
      private var image:BitmapProxy;
      
      private var spellImageSizer:SpriteProxy;
      
      private var _data:Spell;
      
      private var inner:LabelButtonX;
      
      private var _spellsController:SpellsController;
      
      public function SpellRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("SpellRenderer");
         addEventListener(MouseEvent.CLICK,this.clickHandler2);
         setCurrentState(UNLOCKED);
         this._spellsController = getDependency(SpellsController);
         this._spellsController.summonerLevelChanged.add(this.refreshLockedState);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.inner = new LabelButtonX(this);
         setTimelineChildByName("inner",this.inner);
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         this.inner.setTimelineChildByName("imageContainer",_loc1_);
         this.image = new BitmapProxy(this,new Bitmap());
         _loc1_.addChild(this.image);
         this.spellImageSizer = new SpriteProxy(this);
         this.inner.setTimelineChildByName("spellImageSizer",this.spellImageSizer);
      }
      
      private function clickHandler2(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,false,false);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      public function getSelected() : Boolean
      {
         return this.inner.getSelected();
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.inner.setSelected(param1);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      public function setData(param1:*) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.setModel(param1 as Spell);
      }
      
      private function setModel(param1:Spell) : void
      {
         var _loc2_:Class = null;
         var _loc3_:String = null;
         var _loc4_:BitmapAsset = null;
         if(param1 != null)
         {
            _loc2_ = ImagePackLookup.instance.getSpellSource(param1);
            if(_loc2_ == null)
            {
               setIncludeInLayout(false);
               return;
            }
            _loc3_ = RiotResourceLoader.getSpellResourceString("name",param1.name,param1.name + "*");
            this.inner.setText(_loc3_);
            _loc4_ = new _loc2_();
            this.image.setBitmapData(_loc4_.bitmapData);
            this.refreshLockedState();
         }
      }
      
      private function refreshLockedState() : void
      {
         if(this._data == null)
         {
            return;
         }
         if(Boolean(this._spellsController.summonerLevel) && this._data.minLevel > this._spellsController.summonerLevel.summonerLevel)
         {
            setCurrentState(LOCKED);
         }
         else
         {
            setCurrentState(UNLOCKED);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.image.setExplicitSize(this.spellImageSizer.getWidth(),this.spellImageSizer.getHeight());
         return _asset.getBounds(null);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._spellsController.summonerLevelChanged.remove(this.refreshLockedState);
      }
   }
}

