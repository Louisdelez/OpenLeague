package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.ItemCategory;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.itembrowser.ClientModuleItemBrowser;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ItemBrowserHeaderRenderer extends LabelButtonX
   {
      
      private var _clicked:Signal = new Signal();
      
      private var _model:ItemCategory;
      
      private var _sizer:SpriteProxy;
      
      private var _selectionBackground:StatefulView;
      
      public function ItemBrowserHeaderRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("ItemHeaderRenderer");
         addEventListener(MouseEvent.CLICK,this.handleMouseClick);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this._selectionBackground.setCurrentState(getCurrentState());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._selectionBackground = new StatefulView(this);
         setTimelineChildByName("selectionBackground",this._selectionBackground);
         this._selectionBackground.setTransformBehavior(new ScalingTransformBehavior());
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         this._clicked.dispatch(this);
      }
      
      public function setModel(param1:ItemCategory) : void
      {
         if(this._model != param1)
         {
            this._model = param1;
         }
         if(this._model != null)
         {
            setText(RiotResourceLoader.getResourceString(ClientModuleItemBrowser.ITEMBROWSER_RESOURCE_ID,"item_category_header_" + this._model.name.toLowerCase(),"**" + this._model.name.toUpperCase()));
         }
      }
      
      override public function destroy() : void
      {
         this._clicked.removeAll();
         removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         super.destroy();
      }
      
      public function getModel() : ItemCategory
      {
         return this._model;
      }
      
      public function getClicked() : ISignal
      {
         return this._clicked;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight());
      }
   }
}

