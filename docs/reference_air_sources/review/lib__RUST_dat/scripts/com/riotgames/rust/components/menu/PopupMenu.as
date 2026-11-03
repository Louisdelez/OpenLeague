package com.riotgames.rust.components.menu
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.factory.IPool;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.rust.components.button.ResizableButton;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PopupMenu extends SpriteProxy
   {
      
      protected var _listBackground:SpriteProxy;
      
      protected var _rendererFactory:IPool;
      
      protected var _contents:LayoutContainerView;
      
      protected var _padding:Padding = new Padding(5,5,5,5);
      
      protected var _layoutAlgorithm:VerticalLayout;
      
      protected var _hideCompleted:Signal = new Signal();
      
      public var minItemWidth:Number = 20;
      
      public var itemSelected:Signal = new Signal();
      
      public var lastSelectedItem:* = null;
      
      protected var _subMenu:PopupMenu;
      
      protected var _subMenuParent:SpriteProxy;
      
      public function PopupMenu(param1:IContext, param2:IPool)
      {
         this._rendererFactory = param2;
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._listBackground = new SpriteProxy(this);
         this._listBackground.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("listBackground",this._listBackground);
         super.createChildren();
         this._layoutAlgorithm = new VerticalLayout();
         this._layoutAlgorithm.setHorizontalAlign(HorizontalAlign.LEFT);
         this._layoutAlgorithm.setVerticalAlign(VerticalAlign.TOP);
         this._layoutAlgorithm.setGap(0);
         this._contents = new LayoutContainerView(this);
         setTimelineChildByName("contents",this._contents);
         this._contents.setLayoutAlgorithm(this._layoutAlgorithm);
         this._contents.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function setOptions(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:DisplayObjectProxy = null;
         var _loc4_:ResizableButton = null;
         var _loc5_:IDataRenderer = null;
         this.cleanup();
         for each(_loc2_ in param1)
         {
            _loc3_ = this._rendererFactory.getInstance();
            if(_loc3_ is ResizableButton)
            {
               _loc4_ = _loc3_ as ResizableButton;
               _loc4_.minWidth = this.minItemWidth;
            }
            if(_loc3_ is IDataRenderer)
            {
               _loc5_ = _loc3_ as IDataRenderer;
               _loc5_.setData(_loc2_);
            }
            this._contents.addElement(_loc3_);
            this._contents.addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.onItemOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_UP,this.onItemUp);
         }
      }
      
      private function cleanup() : void
      {
         var _loc2_:IDisplayChild = null;
         var _loc3_:IEventDispatcher = null;
         this.cleanupSubMenu();
         var _loc1_:Vector.<IDisplayChild> = this._contents.getChildren();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = _loc2_ as IEventDispatcher;
            _loc3_.removeEventListener(MouseEvent.ROLL_OVER,this.onItemOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_UP,this.onItemUp);
            this._rendererFactory.returnInstance(_loc2_);
         }
         this._contents.removeAllElements();
         this._contents.removeAllChildren();
      }
      
      public function get layoutAlgorithm() : VerticalLayout
      {
         return this._layoutAlgorithm;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc5_:IDisplayChild = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:ResizableButton = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Number = NaN;
         var _loc3_:Point = this._contents.setExplicitSize(Number.NaN,Number.NaN);
         var _loc4_:Vector.<IDisplayChild> = this._contents.getChildren();
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_ is ResizableButton)
            {
               _loc8_ = _loc5_ as ResizableButton;
               _loc8_.minWidth = _loc3_.x;
            }
         }
         this._contents.setExplicitPosition(this.padding.left,this.padding.top);
         _loc6_ = _loc3_.x + this._padding.left + this._padding.right;
         _loc7_ = _loc3_.y + this._padding.top + this._padding.bottom;
         this._listBackground.setExplicitSize(_loc6_,_loc7_);
         if(Boolean(this._subMenu))
         {
            _loc9_ = this._subMenu.setExplicitSize(NaN,NaN);
            _loc10_ = new Point(_loc6_ - this.padding.right,this._subMenuParent.getY());
            _loc11_ = new Point(_loc10_.x + _loc9_.x,_loc10_.y + _loc9_.y);
            _loc12_ = localToGlobal(_loc11_);
            _loc13_ = _loc12_.x > getStage().stageWidth;
            _loc14_ = _loc12_.y > getStage().stageHeight;
            if(_loc13_)
            {
               _loc10_.x = this.padding.left - _loc9_.x;
            }
            if(_loc14_)
            {
               _loc15_ = _loc12_.y - getStage().stageHeight;
               _loc10_.y -= _loc15_;
            }
            this._subMenu.setExplicitPosition(_loc10_.x,_loc10_.y);
         }
         return new Rectangle(0,0,_loc6_,_loc7_);
      }
      
      public function get padding() : Padding
      {
         return this._padding;
      }
      
      public function getHideCompleted() : Signal
      {
         return this._hideCompleted;
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
         this.cleanup();
         this._hideCompleted.dispatch(this);
      }
      
      protected function onItemOver(param1:MouseEvent) : void
      {
         var _loc3_:IDataRenderer = null;
         var _loc4_:* = undefined;
         var _loc5_:MenuNode = null;
         var _loc2_:SpriteProxy = param1.currentTarget as SpriteProxy;
         if(_loc2_ != this._subMenuParent)
         {
            this.cleanupSubMenu();
         }
         if(_loc2_ is IDataRenderer)
         {
            _loc3_ = param1.currentTarget as IDataRenderer;
            _loc4_ = _loc3_.getData();
            if(_loc4_ is MenuNode && _loc2_ != this._subMenuParent)
            {
               _loc5_ = _loc4_ as MenuNode;
               this.setupSubMenu(_loc2_ as SpriteProxy,_loc5_.children);
            }
         }
      }
      
      protected function onItemUp(param1:MouseEvent) : void
      {
         var _loc2_:IDataRenderer = null;
         var _loc3_:* = undefined;
         if(param1.currentTarget is IDataRenderer)
         {
            _loc2_ = param1.currentTarget as IDataRenderer;
            _loc3_ = _loc2_.getData();
            if(!(_loc3_ is MenuNode))
            {
               if(_loc3_ != null)
               {
                  this.select(_loc3_);
               }
            }
         }
         else
         {
            this.select(param1.currentTarget);
         }
      }
      
      protected function select(param1:*) : void
      {
         this.lastSelectedItem = param1;
         this.itemSelected.dispatch(this,this.lastSelectedItem);
      }
      
      protected function setupSubMenu(param1:SpriteProxy, param2:Array) : void
      {
         this._subMenuParent = param1;
         this._subMenu = new PopupMenu(this,this._rendererFactory);
         this._subMenu.setLinkage(this._linkage);
         this._subMenu.padding.left = this.padding.left;
         this._subMenu.padding.top = this.padding.top;
         this._subMenu.padding.bottom = this.padding.bottom;
         this._subMenu.padding.right = this.padding.right;
         this._subMenu.minItemWidth = this.minItemWidth;
         this._subMenu.layoutAlgorithm.setGap(this._layoutAlgorithm.getGap());
         this._subMenu.setOptions(param2);
         this.addChild(this._subMenu);
         this._subMenu.itemSelected.add(this.onSubMenuSelection);
         this._subMenu.show();
         this._subMenu.getLayoutInvalidated().add(invalidateLayout);
         invalidateLayout();
      }
      
      protected function cleanupSubMenu() : void
      {
         if(Boolean(this._subMenu))
         {
            this._subMenu.getHideCompleted().add(this.onSubMenuHideComplete);
            this._subMenu.itemSelected.remove(this.onSubMenuSelection);
            this._subMenu.getLayoutInvalidated().remove(invalidateLayout);
            this._subMenu.hide();
            this._subMenu = null;
            this._subMenuParent = null;
         }
      }
      
      protected function onSubMenuHideComplete(param1:PopupMenu) : void
      {
         this.removeChild(param1);
         param1.destroy();
      }
      
      protected function onSubMenuSelection(param1:PopupMenu, param2:*) : void
      {
         this.cleanupSubMenu();
         this.select(param2);
      }
      
      override public function destroy() : void
      {
         this.cleanup();
         super.destroy();
      }
   }
}

