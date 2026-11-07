package com.riotgames.platform.common.components
{
   import com.greensock.OverwriteManager;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.controls.VScrollBar;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ClassFactory;
   import mx.core.Container;
   import mx.core.IDataRenderer;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.effects.DefaultTileListEffect;
   import mx.effects.Fade;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.events.ScrollEvent;
   
   [Effect(name="itemsChangeEffect",event="itemsChange")]
   [Style(name="scrollBarStyle",type="String",format="String",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",format="Length",inherit="no")]
   [Style(name="backgroundColor",type="Number",format="Color",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Event(name="itemRollOut",type="com.riotgames.platform.gameclient.event.ItemSelectEvent")]
   [Event(name="itemRollOver",type="com.riotgames.platform.gameclient.event.ItemSelectEvent")]
   [Event(name="itemSelect",type="com.riotgames.platform.gameclient.event.ItemSelectEvent")]
   public class AnimatedTileList extends UIComponent
   {
      
      public static const DEFAULT_TILE_WIDTH:Number = 100;
      
      public static const DEFAULT_TILE_HEIGHT:Number = 100;
      
      public static const MOUSE_WHEEL_MULTIPLIER:Number = 5;
      
      private static var tweenLiteInit:int = OverwriteManager.init();
      
      protected var listContent:UIComponent;
      
      protected var interactiveRenderersChanged:Boolean = false;
      
      protected var _tileHeight:Number = 100;
      
      protected var _dataProvider:ArrayCollection;
      
      protected var verticalScrollBar:VScrollBar;
      
      protected var _interactiveRenderers:Boolean = true;
      
      protected var _tileWidth:Number = 100;
      
      protected var collectionChanged:Boolean = false;
      
      protected var scrollMask:UIComponent;
      
      protected var itemRendererChanged:Boolean = false;
      
      protected var rendererDelegate:RendererDelegate = new RendererDelegate();
      
      protected var tweens:Dictionary = new Dictionary();
      
      protected var dataProviderChanged:Boolean = false;
      
      protected var cachedDataProvider:ArrayCollection;
      
      public function AnimatedTileList()
      {
         super();
      }
      
      protected function createScrollMask() : UIComponent
      {
         var _loc1_:Container = new Container();
         _loc1_.setStyle("backgroundColor","black");
         return _loc1_;
      }
      
      public function get itemRenderer() : ClassFactory
      {
         return this.rendererDelegate.itemRenderer;
      }
      
      protected function handleMoveEnd(param1:DisplayObject) : void
      {
         delete this.tweens[param1];
      }
      
      protected function createFadeOutContainer() : UIComponent
      {
         return new UIComponent();
      }
      
      protected function getPositionForRenderer(param1:int, param2:Number) : Point
      {
         var _loc3_:Number = Number(getStyle("paddingLeft"));
         var _loc4_:Number = Number(getStyle("paddingRight"));
         var _loc5_:Number = Number(getStyle("paddingTop"));
         var _loc6_:Number = param2 - _loc3_ - _loc4_;
         var _loc7_:int = _loc6_ / this.tileWidth;
         var _loc8_:int = param1 / _loc7_;
         var _loc9_:int = param1 % _loc7_;
         var _loc10_:Number = _loc9_ * this.tileWidth + _loc3_;
         var _loc11_:Number = _loc8_ * this.tileHeight + _loc5_;
         return new Point(_loc10_,_loc11_);
      }
      
      protected function handleFadeOutEnd(param1:DisplayObject) : void
      {
         param1.visible = false;
         this.rendererDelegate.recycleRenderer(param1 as IDataRenderer);
      }
      
      protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = uint(getStyle("backgroundColor"));
         var _loc4_:Number = Number(getStyle("backgroundAlpha"));
         graphics.clear();
         graphics.beginFill(_loc3_,_loc4_);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
      
      protected function animateMovedItems(param1:Array, param2:DefaultTileListEffect) : void
      {
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:TweenLite = null;
         var _loc8_:TweenLite = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = this.rendererDelegate.getRendererForItem(_loc3_) as DisplayObject;
            if(Boolean(this.tweens[_loc4_]))
            {
               _loc8_ = this.tweens[_loc4_];
               _loc8_.killVars({
                  "x":true,
                  "y":true
               });
            }
            _loc6_ = int(this.dataProvider.getItemIndex(_loc3_));
            _loc5_ = this.getPositionForRenderer(_loc6_,width);
            _loc7_ = TweenLite.to(_loc4_,param2.moveDuration / 1000,{
               "x":_loc5_.x,
               "y":_loc5_.y,
               "onComplete":this.handleMoveEnd,
               "onCompleteParams":[_loc4_]
            });
            this.tweens[_loc4_] = _loc7_;
         }
      }
      
      protected function getAddedItems(param1:ArrayCollection, param2:ArrayCollection) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            if(!param1.contains(_loc4_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      protected function createVerticalScrollBar() : VScrollBar
      {
         var _loc1_:VScrollBar = new VScrollBar();
         _loc1_.setStyle("styleName",getStyle("scrollBarStyle"));
         return _loc1_;
      }
      
      public function set interactiveRenderers(param1:Boolean) : void
      {
         this._interactiveRenderers = param1;
         this.interactiveRenderersChanged = true;
         invalidateProperties();
      }
      
      protected function animateAddItems(param1:Array, param2:DefaultTileListEffect) : void
      {
         var _loc3_:Object = null;
         var _loc4_:IDataRenderer = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         for each(_loc3_ in param1)
         {
            _loc6_ = int(this.dataProvider.getItemIndex(_loc3_));
            _loc4_ = this.rendererDelegate.createRenderer();
            if(!this.listContent.contains(_loc4_ as DisplayObject))
            {
               this.listContent.addChildAt(_loc4_ as DisplayObject,_loc6_);
            }
            (_loc4_ as DisplayObject).visible = true;
            _loc4_.data = _loc3_;
            (_loc4_ as DisplayObject).alpha = 0;
            _loc5_ = this.getPositionForRenderer(_loc6_,width);
            (_loc4_ as IUIComponent).setActualSize(this.tileWidth,this.tileHeight);
            (_loc4_ as IUIComponent).move(_loc5_.x,_loc5_.y);
            this.rendererDelegate.associateDataWithRenderer(_loc3_,_loc4_);
            TweenLite.to(_loc4_,param2.fadeInDuration / 1000,{"alpha":1});
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.listContent = this.createListContent();
         if(Boolean(this.listContent))
         {
            addChild(this.listContent);
         }
         this.verticalScrollBar = this.createVerticalScrollBar();
         if(Boolean(this.verticalScrollBar))
         {
            addChild(this.verticalScrollBar);
         }
         this.scrollMask = this.createScrollMask();
         if(Boolean(this.scrollMask))
         {
            addChild(this.scrollMask);
            this.mask = this.scrollMask;
         }
      }
      
      protected function createFadeInContainer() : UIComponent
      {
         return new UIComponent();
      }
      
      protected function handleScrollChange(param1:ScrollEvent) : void
      {
         this.commitScrollPosition();
      }
      
      protected function commitScrollPosition() : void
      {
         if(this.verticalScrollBar.scrollPosition > this.verticalScrollBar.maxScrollPosition)
         {
            this.verticalScrollBar.scrollPosition = this.verticalScrollBar.maxScrollPosition;
         }
         if(this.verticalScrollBar.scrollPosition < this.verticalScrollBar.minScrollPosition)
         {
            this.verticalScrollBar.scrollPosition = this.verticalScrollBar.minScrollPosition;
         }
         this.listContent.y = -this.verticalScrollBar.scrollPosition;
      }
      
      protected function getRemovedItems(param1:ArrayCollection, param2:ArrayCollection) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            if(!param2.contains(_loc4_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public function get tileWidth() : Number
      {
         return this._tileWidth;
      }
      
      public function get dataProvider() : ArrayCollection
      {
         return this._dataProvider;
      }
      
      protected function updateScrollBar(param1:VScrollBar) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         if(Boolean(param1))
         {
            _loc2_ = Number(width);
            _loc3_ = this.getPositionForRenderer(this.dataProvider.length - 1,_loc2_);
            _loc4_ = _loc3_.y + this.tileHeight + getStyle("paddingBottom");
            _loc5_ = Number(ScrollBar.THICKNESS);
            _loc6_ = Number(unscaledHeight);
            _loc7_ = _loc4_ > unscaledHeight;
            if(!this.dataProvider || this.dataProvider.length == 0)
            {
               _loc7_ = false;
            }
            param1.setActualSize(_loc5_,_loc6_);
            param1.move(unscaledWidth - _loc5_,0);
            param1.visible = _loc7_;
            param1.setScrollProperties(unscaledHeight,0,_loc4_ - unscaledHeight,this.tileHeight);
            if(!_loc7_)
            {
               param1.scrollPosition = param1.minScrollPosition;
            }
            this.commitScrollPosition();
         }
      }
      
      protected function animateRemovedItems(param1:Array, param2:DefaultTileListEffect) : void
      {
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Fade = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = this.rendererDelegate.getRendererForItem(_loc3_) as DisplayObject;
            TweenLite.to(_loc4_,param2.fadeOutDuration / 1000,{
               "alpha":0,
               "onComplete":this.handleFadeOutEnd,
               "onCompleteParams":[_loc4_]
            });
            this.rendererDelegate.deleteRendererForItem(_loc3_);
         }
      }
      
      protected function getMovedItems(param1:ArrayCollection, param2:ArrayCollection) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            if(Boolean(param1.contains(_loc4_)) && param1.getItemIndex(_loc4_) != param2.getItemIndex(_loc4_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      protected function updateCollection() : void
      {
         var _loc1_:Array = this.getRemovedItems(this.cachedDataProvider,this.dataProvider);
         var _loc2_:Array = this.getAddedItems(this.cachedDataProvider,this.dataProvider);
         var _loc3_:Array = this.getMovedItems(this.cachedDataProvider,this.dataProvider);
         this.cachedDataProvider = this.copyCollection(this.dataProvider);
         var _loc4_:DefaultTileListEffect = getStyle("itemsChangeEffect") as DefaultTileListEffect;
         if(!_loc4_)
         {
            this.rendererDelegate.rebuildRenderers(this.dataProvider,this.listContent);
            invalidateDisplayList();
         }
         else
         {
            this.animateRemovedItems(_loc1_,_loc4_);
            this.animateAddItems(_loc2_,_loc4_);
            this.animateMovedItems(_loc3_,_loc4_);
            this.updateScrollBar(this.verticalScrollBar);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.dataProviderChanged || this.itemRendererChanged)
         {
            this.rendererDelegate.rebuildRenderers(this.dataProvider,this.listContent);
            if(this.itemRendererChanged)
            {
               invalidateDisplayList();
            }
            this.collectionChanged = this.itemRendererChanged = this.dataProviderChanged = false;
            this.cachedDataProvider = this.copyCollection(this.dataProvider);
         }
         if(this.collectionChanged)
         {
            this.updateCollection();
            this.collectionChanged = false;
         }
         if(this.interactiveRenderersChanged)
         {
            if(Boolean(this.listContent))
            {
               this.listContent.mouseChildren = this.interactiveRenderers;
            }
            this.interactiveRenderersChanged = false;
         }
      }
      
      public function get interactiveRenderers() : Boolean
      {
         return this._interactiveRenderers;
      }
      
      protected function initScrollBar(param1:VScrollBar) : void
      {
         param1.addEventListener(ScrollEvent.SCROLL,this.handleScrollChange,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
      }
      
      protected function handleCollectionChange(param1:CollectionEvent) : void
      {
         var _loc2_:IDataRenderer = null;
         var _loc3_:Object = null;
         var _loc4_:PropertyChangeEvent = null;
         if(param1.kind == CollectionEventKind.UPDATE)
         {
            for each(_loc4_ in param1.items)
            {
               _loc3_ = _loc4_.source;
               _loc2_ = this.rendererDelegate.getRendererForItem(_loc3_);
               if(Boolean(_loc2_))
               {
                  _loc2_.data = _loc3_;
               }
            }
            return;
         }
         if(param1.kind == CollectionEventKind.REFRESH)
         {
            for each(_loc3_ in this.dataProvider)
            {
               _loc2_ = this.rendererDelegate.getRendererForItem(_loc3_);
               if(Boolean(_loc2_))
               {
                  _loc2_.data = _loc3_;
               }
            }
         }
         this.collectionChanged = true;
         invalidateProperties();
      }
      
      protected function createListContent() : UIComponent
      {
         return new UIComponent();
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         addEventListener(ResizeEvent.RESIZE,this.handleResize,false,0,true);
         if(Boolean(this.verticalScrollBar))
         {
            this.initScrollBar(this.verticalScrollBar);
         }
      }
      
      public function set tileHeight(param1:Number) : void
      {
         if(this._tileHeight == param1)
         {
            return;
         }
         this._tileHeight = param1;
         invalidateDisplayList();
      }
      
      public function set tileWidth(param1:Number) : void
      {
         if(this._tileWidth == param1)
         {
            return;
         }
         this._tileWidth = param1;
         invalidateDisplayList();
      }
      
      protected function copyCollection(param1:ArrayCollection) : ArrayCollection
      {
         var _loc3_:Object = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in param1)
         {
            _loc2_.addItem(_loc3_);
         }
         return _loc2_;
      }
      
      public function get tileHeight() : Number
      {
         return this._tileHeight;
      }
      
      public function set dataProvider(param1:ArrayCollection) : void
      {
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleCollectionChange);
         }
         this._dataProvider = param1;
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.handleCollectionChange,false,0,true);
         }
         this.dataProviderChanged = true;
         invalidateProperties();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Object = null;
         var _loc4_:IUIComponent = null;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         super.updateDisplayList(param1,param2);
         this.drawBackground(param1,param2);
         if(Boolean(this.scrollMask))
         {
            this.scrollMask.setActualSize(param1,param2);
            this.scrollMask.move(0,0);
         }
         if(!this.listContent || this.listContent.numChildren == 0)
         {
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < this.dataProvider.length)
         {
            _loc3_ = this.dataProvider.getItemAt(_loc5_);
            _loc4_ = this.rendererDelegate.getRendererForItem(_loc3_) as IUIComponent;
            if(Boolean(_loc4_))
            {
               _loc4_.setActualSize(this.tileWidth,this.tileHeight);
               _loc6_ = this.getPositionForRenderer(_loc5_,param1);
               _loc4_.move(_loc6_.x,_loc6_.y);
            }
            _loc5_++;
         }
         this.updateScrollBar(this.verticalScrollBar);
      }
      
      public function set itemRenderer(param1:ClassFactory) : void
      {
         if(param1 == this.itemRenderer)
         {
            return;
         }
         this.rendererDelegate.itemRenderer = param1;
         this.itemRendererChanged = true;
         invalidateProperties();
      }
      
      protected function handleResize(param1:ResizeEvent) : void
      {
         invalidateDisplayList();
      }
      
      protected function handleMouseWheel(param1:MouseEvent) : void
      {
         this.verticalScrollBar.scrollPosition -= param1.delta * MOUSE_WHEEL_MULTIPLIER;
         this.commitScrollPosition();
      }
   }
}

