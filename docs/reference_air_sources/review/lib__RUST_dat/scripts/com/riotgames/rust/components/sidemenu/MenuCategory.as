package com.riotgames.rust.components.sidemenu
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MenuCategory extends SpriteProxy
   {
      
      private static const SIDEBAR_CATEGORY_HEADER:String = "SideTabCategory";
      
      private var _menuItemSelected:Signal = new Signal();
      
      private var _categoryLayoutContainer:LayoutContainer;
      
      private var _itemLayoutContainer:LayoutContainer;
      
      private var _categoryId:int;
      
      private var _categoryNameText:String;
      
      private var _categoryName:LabelButtonX;
      
      private var _categoryVerticalLayout:VerticalLayout;
      
      private var _itemVerticalLayout:VerticalLayout;
      
      public function MenuCategory(param1:IContext, param2:int, param3:String)
      {
         this._categoryId = param2;
         this._categoryNameText = param3;
         super(param1,new Sprite());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._categoryVerticalLayout = new VerticalLayout();
         this._itemVerticalLayout = new VerticalLayout();
         this._categoryLayoutContainer = new LayoutContainer(this);
         this._categoryLayoutContainer.setLayoutAlgorithm(this._categoryVerticalLayout);
         this._itemLayoutContainer = new LayoutContainer(this);
         this._itemLayoutContainer.setLayoutAlgorithm(this._itemVerticalLayout);
         this._categoryLayoutContainer.getLayoutInvalidated().add(invalidateLayout);
         this._categoryName = new LabelButtonX(this);
         this._categoryName.setMouseEnabled(false);
         this._categoryName.setButtonMode(false);
         this._categoryName.setLinkage(SIDEBAR_CATEGORY_HEADER);
         this._categoryName.setText(this._categoryNameText);
         addChild(this._categoryName);
         this._categoryLayoutContainer.addElement(this._categoryName);
         this._categoryLayoutContainer.addElement(this._itemLayoutContainer);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._categoryLayoutContainer.setExplicitSize(NaN,NaN);
         return super.updateLayout(_loc3_.x,_loc3_.y);
      }
      
      public function addItem(param1:MenuButton) : void
      {
         this._itemLayoutContainer.addElement(param1);
         addChild(param1);
         param1.getAssetChanged().add(this._itemLayoutContainer.invalidateLayout);
         param1.addEventListener(MouseEvent.CLICK,this.menuItemClickHandler);
      }
      
      private function menuItemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:MenuButton = param1.target as MenuButton;
         if(_loc2_ != null)
         {
            this._menuItemSelected.dispatch(_loc2_);
         }
      }
      
      public function menuNavItemSelected() : ISignal
      {
         return this._menuItemSelected;
      }
      
      public function setGapBetweenHeaderAndItem(param1:Number) : void
      {
         this._categoryVerticalLayout.setGap(param1);
      }
      
      public function setGapBetweenItem(param1:Number) : void
      {
         this._itemVerticalLayout.setGap(param1);
      }
   }
}

