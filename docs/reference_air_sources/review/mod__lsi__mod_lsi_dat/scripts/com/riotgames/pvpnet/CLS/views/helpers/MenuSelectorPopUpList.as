package com.riotgames.pvpnet.CLS.views.helpers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import flash.geom.Rectangle;
   
   public class MenuSelectorPopUpList extends SpriteProxy
   {
      
      private var _verticalLayout:VerticalLayout;
      
      private var _layoutContainer:LayoutContainer;
      
      private var _listContainer:SpriteProxy;
      
      private var _listBackground:SpriteProxy;
      
      private var _listChild:Vector.<MenuSelectorButton>;
      
      private var _needsToUpdate:Boolean = false;
      
      private const LAYOUT_GAP:int = -8;
      
      public function MenuSelectorPopUpList(param1:IContext)
      {
         super(param1);
         setLinkage("SelectorList");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._listContainer = new SpriteProxy(this);
         setTimelineChildByName("listContainer",this._listContainer);
         this._listBackground = new SpriteProxy(this);
         setTimelineChildByName("background",this._listBackground);
         this._verticalLayout = new VerticalLayout();
         this._verticalLayout.setGap(this.LAYOUT_GAP);
         this._layoutContainer = new LayoutContainer(this._listContainer);
         this._layoutContainer.setLayoutAlgorithm(this._verticalLayout);
         this._layoutContainer.getLayoutInvalidated().add(invalidateLayout);
         this._listChild = new Vector.<MenuSelectorButton>();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._verticalLayout.setGap(this.LAYOUT_GAP);
         this._layoutContainer.invalidateLayout();
         return super.updateLayout(param1,param2);
      }
      
      public function addChildToList(param1:MenuSelectorButton) : void
      {
         this._listContainer.addChild(param1);
         this._layoutContainer.addElement(param1);
         this._listChild.push(param1);
      }
      
      public function setItemSelected(param1:uint) : void
      {
         if(this._listChild[param1])
         {
            this._listChild[param1].setSelected(true);
         }
      }
   }
}

