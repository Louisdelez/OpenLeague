package com.riotgames.rust.components.sidebar
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import com.greensock.data.TweenLiteVars;
   import com.greensock.easing.Circ;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Sidebar extends SpriteProxy
   {
      
      private var listContainer:SpriteProxy;
      
      private var listSizer:SpriteProxy;
      
      private var _renderers:Vector.<DisplayObjectProxy> = new Vector.<DisplayObjectProxy>();
      
      private var _navItemSelected:Signal = new Signal();
      
      private var _path:String;
      
      private var selectedRenderer:NavButton;
      
      private var arrow:SpriteProxy;
      
      private var _headerLinkageAsset:String = "SideTabCategory";
      
      private var _itemLinkageAsset:String = "SideTabButton";
      
      private var _listContainerAsset:String = "listContainer";
      
      private var _listSizerAsset:String = "listSizer";
      
      private var _arrowAsset:String = "arrow";
      
      private var _headers:Vector.<String> = new Vector.<String>();
      
      private var _items:Vector.<SidebarItem> = new Vector.<SidebarItem>(50);
      
      public function Sidebar(param1:IContext)
      {
         super(param1);
      }
      
      public function addNavigation(param1:Number, param2:String, param3:String, param4:String, param5:Function) : void
      {
         this.addHeader(param2);
         this._items[param1] = new SidebarItem(param1,param2,param3,param4,param5);
      }
      
      public function addHeader(param1:String) : void
      {
         if(this._headers.indexOf(param1) == -1)
         {
            this._headers.push(param1);
         }
      }
      
      public function activate() : void
      {
         this.updateChildren();
      }
      
      public function lookupByPath(param1:String) : SidebarItem
      {
         var _loc2_:SidebarItem = null;
         for each(_loc2_ in this._items)
         {
            if(_loc2_ != null && _loc2_.path == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getNavItemSelected() : ISignal
      {
         return this._navItemSelected;
      }
      
      public function setPath(param1:String) : void
      {
         this._path = param1;
         this.setSelectedChild();
         this.updateArrow();
      }
      
      public function set arrowAlpha(param1:Number) : void
      {
         this.arrow.setAlpha(param1);
      }
      
      public function get arrowAlpha() : Number
      {
         return this.arrow.getAlpha();
      }
      
      public function set arrowY(param1:Number) : void
      {
         this.arrow.setY(param1);
      }
      
      public function get arrowY() : Number
      {
         return this.arrow.getY();
      }
      
      public function get headerLinkageAsset() : String
      {
         return this._headerLinkageAsset;
      }
      
      public function set headerLinkageAsset(param1:String) : void
      {
         this._headerLinkageAsset = param1;
      }
      
      public function get itemLinkageAsset() : String
      {
         return this._itemLinkageAsset;
      }
      
      public function set itemLinkageAsset(param1:String) : void
      {
         this._itemLinkageAsset = param1;
      }
      
      public function get listContainerAsset() : String
      {
         return this._listContainerAsset;
      }
      
      public function set listContainerAsset(param1:String) : void
      {
         this._listContainerAsset = param1;
      }
      
      public function get listSizerAsset() : String
      {
         return this._listSizerAsset;
      }
      
      public function set listSizerAsset(param1:String) : void
      {
         this._listSizerAsset = param1;
      }
      
      public function get arrowAsset() : String
      {
         return this._arrowAsset;
      }
      
      public function set arrowAsset(param1:String) : void
      {
         this._arrowAsset = param1;
      }
      
      override protected function createChildren() : void
      {
         this.listContainer = new SpriteProxy(this);
         this.listContainer.setMouseChildren(true);
         setTimelineChildByName(this._listContainerAsset,this.listContainer);
         this.listSizer = new SpriteProxy(this);
         setTimelineChildByName(this._listSizerAsset,this.listSizer);
         this.listSizer.setMouseEnabled(false);
         this.arrow = new SpriteProxy(this);
         setTimelineChildByName(this._arrowAsset,this.arrow);
         this.arrow.setAlpha(0);
      }
      
      private function updateChildren() : void
      {
         var _loc1_:DisplayObjectProxy = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:LabelButtonX = null;
         var _loc5_:SidebarItem = null;
         var _loc6_:NavButton = null;
         for each(_loc1_ in this._renderers)
         {
            if(_loc1_.hasEventListener(MouseEvent.CLICK))
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.navItemClickHandler);
            }
            if(_loc1_ is NavButton)
            {
               (_loc1_ as NavButton).setNavItem(null);
            }
            removeChild(_loc1_);
         }
         this._renderers.length = 0;
         _loc2_ = 0;
         for each(_loc3_ in this._headers)
         {
            _loc4_ = new LabelButtonX(this);
            _loc4_.setMouseEnabled(false);
            _loc4_.setButtonMode(false);
            _loc4_.setLinkage(this._headerLinkageAsset);
            _loc4_.setText(_loc3_);
            this.listContainer.addChild(_loc4_);
            _loc4_.setExplicitPosition(0,_loc2_);
            _loc2_ += 36;
            for each(_loc5_ in this._items)
            {
               if(_loc5_ != null && _loc5_.header == _loc3_ && _loc5_.added == false)
               {
                  _loc6_ = new NavButton(this);
                  _loc6_.setNavItem(_loc5_);
                  _loc6_.addEventListener(MouseEvent.CLICK,this.navItemClickHandler);
                  _loc6_.setLinkage(this._itemLinkageAsset);
                  _loc6_.setText(_loc5_.name);
                  this.listContainer.addChild(_loc6_);
                  _loc6_.setExplicitPosition(0,_loc2_);
                  _loc5_.added = true;
                  this._renderers.push(_loc6_);
                  _loc2_ += 36;
               }
            }
         }
         this.setSelectedChild();
      }
      
      private function navItemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:NavButton = param1.target as NavButton;
         if(_loc2_ != null)
         {
            this._navItemSelected.dispatch(_loc2_.getNavItem());
         }
      }
      
      private function setSelectedChild() : void
      {
         var _loc1_:NavButton = null;
         var _loc2_:DisplayObjectProxy = null;
         for each(_loc2_ in this._renderers)
         {
            if(_loc2_ is NavButton)
            {
               if((_loc2_ as NavButton).path == this._path)
               {
                  _loc1_ = _loc2_ as NavButton;
                  break;
               }
            }
         }
         if(this.selectedRenderer != _loc1_)
         {
            if(this.selectedRenderer != null)
            {
               this.selectedRenderer.setSelected(false);
               this.selectedRenderer.getLayoutInvalidated().remove(this.updateArrowOnInvalidate);
               this.selectedRenderer.getUnscaledBoundsChanged().remove(this.updateArrowOnInvalidate);
            }
            this.selectedRenderer = _loc1_;
            if(this.selectedRenderer != null)
            {
               this.selectedRenderer.setSelected(true);
               this.selectedRenderer.getLayoutInvalidated().add(this.updateArrowOnInvalidate);
               this.selectedRenderer.getUnscaledBoundsChanged().add(this.updateArrowOnInvalidate);
            }
         }
      }
      
      private function updateArrow() : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         TweenLite.killTweensOf(this.arrow);
         var _loc1_:TweenLiteVars = new TweenLiteVars();
         _loc1_.ease(Circ.easeOut);
         var _loc2_:Boolean = false;
         if(this.selectedRenderer == null)
         {
            if(this.arrow.getAlpha() >= 0)
            {
               _loc1_.prop("arrowAlpha",0);
               _loc2_ = true;
            }
         }
         else if(this.selectedRenderer.getAsset() != null)
         {
            _loc3_ = this.selectedRenderer.getUnscaledBounds();
            _loc4_ = Math.round(this.selectedRenderer.getExplicitPosition().y + this.listContainer.getY() + 25);
            if(this.arrow.getAlpha() == 0)
            {
               this.arrow.setExplicitPosition(NaN,_loc4_ - 35);
               _loc1_.prop("arrowAlpha",1);
               _loc2_ = true;
            }
            else
            {
               _loc1_.prop("arrowAlpha",1);
               _loc1_.prop("arrowY",_loc4_);
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            TweenLite.to(this,0.3,_loc1_);
         }
      }
      
      private function updateArrowOnInvalidate() : void
      {
         this.updateArrow();
      }
   }
}

