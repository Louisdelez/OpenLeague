package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.CheckBoxX;
   import blix.context.Context;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.gameItems.model.ItemTag;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.itembrowser.ClientModuleItemBrowser;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ItemBrowserCategoryRenderer extends CheckBoxX
   {
      
      private var _clicked:Signal = new Signal();
      
      private var _model:ItemTag;
      
      private var _sizer:SpriteProxy;
      
      public function ItemBrowserCategoryRenderer(param1:Context)
      {
         super(param1);
         toggleOnClick = false;
         setLinkage("ItemCategoryRenderer");
         addEventListener(MouseEvent.CLICK,this.handleMouseClick);
      }
      
      override public function destroy() : void
      {
         this._clicked.removeAll();
         removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         super.destroy();
      }
      
      public function getModel() : ItemTag
      {
         return this._model;
      }
      
      public function setModel(param1:ItemTag) : void
      {
         if(this._model != param1)
         {
            this._model = param1;
         }
         if(this._model != null)
         {
            setText(RiotResourceLoader.getResourceString(ClientModuleItemBrowser.ITEMBROWSER_RESOURCE_ID,"item_category_" + this._model.tag.toLowerCase(),"**" + this._model.tag.toLowerCase()));
         }
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         this._clicked.dispatch(this);
      }
      
      public function getClicked() : ISignal
      {
         return this._clicked;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
      }
   }
}

