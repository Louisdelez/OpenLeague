package com.riotgames.rust.components.sidemenu
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class VerticalMenuBar extends SpriteProxy
   {
      
      private const ITEM_ASSET_LINKAGE:String = "SideTabButton";
      
      private const LIST_CONTAINER_INSTANCE:String = "listContainer";
      
      private const ARROW_INSTANCE:String = "arrow";
      
      private var _menuItemSelected:Signal = new Signal();
      
      private var _verticalLayoutContainer:LayoutContainer;
      
      private var _listContainer:SpriteProxy;
      
      private var _selectedMenuItem:MenuButton;
      
      private var _arrow:SpriteProxy;
      
      private var _categoryList:Vector.<MenuCategory> = new Vector.<MenuCategory>();
      
      private var _menuButtonByPath:Dictionary = new Dictionary();
      
      private var _verticalLayout:VerticalLayout;
      
      private var _tweenPercent:Number;
      
      private var _arrowAlphaTarget:Number;
      
      private var _arrowYTarget:Number;
      
      private var _arrowAlphaTweenStart:Number;
      
      private var _arrowYTweenStart:Number;
      
      public function VerticalMenuBar(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function createChildren() : void
      {
         this._listContainer = new SpriteProxy(this);
         this._listContainer.setMouseChildren(true);
         setTimelineChildByName(this.LIST_CONTAINER_INSTANCE,this._listContainer);
         this._verticalLayoutContainer = new LayoutContainer(this);
         this._verticalLayout = new VerticalLayout();
         this._verticalLayoutContainer.setLayoutAlgorithm(this._verticalLayout);
         this._verticalLayoutContainer.getLayoutInvalidated().add(invalidateLayout);
         this._arrow = new SpriteProxy(this);
         setTimelineChildByName(this.ARROW_INSTANCE,this._arrow);
         this._arrow.setMouseEnabled(false);
         this._arrow.setAlpha(0);
      }
      
      public function addCategory(param1:String) : int
      {
         var _loc2_:int = int(this._categoryList.length);
         var _loc3_:MenuCategory = new MenuCategory(this,_loc2_,param1);
         this._categoryList.push(_loc3_);
         _loc3_.menuNavItemSelected().add(this.onMenuItemSelected);
         this._listContainer.addChild(_loc3_);
         this._verticalLayoutContainer.addElement(_loc3_);
         return _loc2_;
      }
      
      public function addItemToCategory(param1:int, param2:String, param3:String, param4:Function, param5:Array) : void
      {
         var _loc6_:SideBarMenuItem = null;
         var _loc7_:MenuButton = null;
         if(param1 < this._categoryList.length)
         {
            _loc6_ = new SideBarMenuItem(0,"",param2,param3,param4,param5);
            _loc7_ = new MenuButton(this);
            _loc7_.setMenuItem(_loc6_);
            _loc7_.setLinkage(this.ITEM_ASSET_LINKAGE);
            _loc7_.setText(_loc6_.name);
            this._categoryList[param1].addItem(_loc7_);
            this._menuButtonByPath[param3] = _loc7_;
         }
      }
      
      public function setGapBetweenCategory(param1:Number) : void
      {
         this._verticalLayout.setGap(param1);
      }
      
      public function setGapBetweenHeaderAndItem(param1:Number) : void
      {
         var _loc2_:MenuCategory = null;
         for each(_loc2_ in this._categoryList)
         {
            _loc2_.setGapBetweenHeaderAndItem(param1);
         }
      }
      
      public function setGapBetweenItem(param1:Number) : void
      {
         var _loc2_:MenuCategory = null;
         for each(_loc2_ in this._categoryList)
         {
            _loc2_.setGapBetweenItem(param1);
         }
      }
      
      public function selectMenuItemByPath(param1:String) : void
      {
         var _loc2_:MenuButton = this._menuButtonByPath[param1];
         if(Boolean(_loc2_))
         {
            this.onMenuItemSelected(_loc2_);
         }
      }
      
      private function onMenuItemSelected(param1:MenuButton) : void
      {
         this.setSelectedChild(param1);
         this._menuItemSelected.dispatch(param1.getMenuItem());
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:MenuCategory = null;
         var _loc4_:Point = null;
         for each(_loc3_ in this._categoryList)
         {
            _loc3_.setExplicitSize(NaN,NaN);
         }
         _loc4_ = this._listContainer.setExplicitSize(NaN,NaN);
         return super.updateLayout(_loc4_.x,_loc4_.y);
      }
      
      public function getMenuItemSelected() : ISignal
      {
         return this._menuItemSelected;
      }
      
      private function setSelectedChild(param1:MenuButton) : void
      {
         if(this._selectedMenuItem != param1)
         {
            if(this._selectedMenuItem != null)
            {
               this._selectedMenuItem.setSelected(false);
               this._selectedMenuItem.getLayoutInvalidated().remove(invalidateLayout);
            }
            this._selectedMenuItem = param1;
            if(this._selectedMenuItem != null)
            {
               this._selectedMenuItem.setSelected(true);
               this._selectedMenuItem.getLayoutInvalidated().add(invalidateLayout);
            }
         }
         this.updateArrow();
      }
      
      private function updateArrow() : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = NaN;
         TweenLite.killTweensOf(this._arrow.getSetterProxy());
         var _loc1_:Boolean = false;
         if(this._selectedMenuItem == null)
         {
            if(this._arrow.getAlpha() >= 0)
            {
               this._arrowAlphaTarget = 0;
               this._arrowYTarget = this._arrow.getY();
               this._arrowAlphaTweenStart = this._arrow.getAlpha();
               this._arrowYTweenStart = this._arrow.getY();
               _loc1_ = true;
            }
         }
         else if(this._selectedMenuItem.getAsset() != null)
         {
            _loc2_ = this._selectedMenuItem.getBounds(this.getContainerAsset());
            _loc3_ = Math.round(_loc2_.y + _loc2_.height * 0.5);
            this._arrowAlphaTarget = 1;
            this._arrowYTarget = _loc3_;
            this._arrowAlphaTweenStart = this._arrow.getAlpha();
            this._arrowYTweenStart = this._arrow.getY();
            _loc1_ = true;
         }
         this._tweenPercent = 0;
         if(_loc1_)
         {
            TweenLite.to(this,0.3,{"tweenPercent":1});
         }
      }
      
      public function set tweenPercent(param1:Number) : void
      {
         this._tweenPercent = param1;
         var _loc2_:Number = this._arrowYTweenStart + (this._arrowYTarget - this._arrowYTweenStart) * this._tweenPercent;
         var _loc3_:Number = this._arrowAlphaTweenStart + (this._arrowAlphaTarget - this._arrowAlphaTweenStart) * this._tweenPercent;
         this._arrow.setY(_loc2_);
         this._arrow.setAlpha(_loc3_);
      }
      
      public function get tweenPercent() : Number
      {
         return this._tweenPercent;
      }
   }
}

