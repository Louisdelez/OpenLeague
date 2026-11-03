package blix.components.list
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.scroll.HScrollBarX;
   import blix.components.scroll.KineticScroller;
   import blix.components.scroll.ScrollBarBase;
   import blix.components.scroll.ScrollModel;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.scroll.VScrollBarX;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.IVirtualizedLayoutAlgorithm;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.Padding;
   import blix.layout.vo.SizeConstraints;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DataScroller extends SpriteProxy
   {
      
      public var mouseDelta:Number = 1;
      
      protected var _mouseWheelEnabled:Boolean;
      
      protected var _scrollModel:ScrollModel;
      
      protected var _scrollPolicy:uint = 1;
      
      protected var _scrollBarsAutoPosition:Boolean = true;
      
      protected var _padding:Padding = new Padding();
      
      protected var _scrollAreaSize:Point;
      
      protected var _selectionEnabled:Boolean = true;
      
      protected var dataGroup:DataGroup;
      
      protected var dataGroupBottom:DataGroup;
      
      protected var hScrollBar:ScrollBarBase;
      
      protected var vScrollBar:ScrollBarBase;
      
      protected var _kineticScroller:KineticScroller;
      
      protected var _selectionBehavior:SelectionBehavior;
      
      protected var _snappingBehavior:SnappingBehavior;
      
      protected var modelToPixels:Number = 1;
      
      public function DataScroller(param1:IContext, param2:IListX = null, param3:IRendererFactory = null, param4:Sprite = null)
      {
         super(param1,param4);
         this.setMouseWheelEnabled(true);
         this.setDataProvider(param2);
         this.setRendererFactory(param3);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this._scrollModel == null)
         {
            this._scrollModel = new ScrollModel();
         }
         this._scrollModel.getChanged().add(this.scrollModelChangedHandler);
      }
      
      protected function scrollModelChangedHandler() : void
      {
         if(_isValidatingLayout)
         {
            return;
         }
         this.dataGroup.setPosition(this._scrollModel.getValue());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.hScrollBar == null)
         {
            this.hScrollBar = new HScrollBarX(this);
            this.hScrollBar.setScrollModel(this.getScrollModel());
            this.hScrollBar.stepDelta = 1;
            this.hScrollBar.getLayoutInvalidated().add(invalidateLayout);
            setTimelineChildByName("hScrollBar",this.hScrollBar);
         }
         if(this.vScrollBar == null)
         {
            this.vScrollBar = new VScrollBarX(this);
            this.vScrollBar.setScrollModel(this.getScrollModel());
            this.vScrollBar.stepDelta = 1;
            this.vScrollBar.getLayoutInvalidated().add(invalidateLayout);
            setTimelineChildByName("vScrollBar",this.vScrollBar);
         }
         if(this.dataGroup == null)
         {
            this.dataGroup = new DataGroup(this);
            addChild(this.dataGroup);
         }
         if(this.dataGroupBottom == null)
         {
            this.dataGroupBottom = new DataGroup(this);
            this.dataGroupBottom.setVisible(false);
            addChild(this.dataGroupBottom);
         }
         this.dataGroupBottom.getLayoutInvalidated().add(invalidateLayout);
         this.dataGroup.getLayoutInvalidated().add(invalidateLayout);
         if(this._selectionBehavior == null)
         {
            this._selectionBehavior = new SelectionBehavior();
         }
         if(this._kineticScroller == null)
         {
            this._kineticScroller = new KineticScroller(this.dataGroup,null,this._scrollModel);
            this._kineticScroller.setEnabled(false);
         }
         if(this._snappingBehavior == null)
         {
            this._snappingBehavior = new SnappingBehavior(this.dataGroup);
            this._kineticScroller.getTossStart().add(this._snappingBehavior.tossStartHandler);
            this._kineticScroller.getTossEnd().add(this._snappingBehavior.tossEndHandler);
            this.vScrollBar.getIsDraggingChanged().add(this._snappingBehavior.scrollDraggingChangedHandler);
            this.hScrollBar.getIsDraggingChanged().add(this._snappingBehavior.scrollDraggingChangedHandler);
         }
         _explicitSize.x = 0;
         _explicitSize.y = 0;
      }
      
      public function getDataProvider() : IListX
      {
         return this.dataGroup.getDataProvider();
      }
      
      public function setDataProvider(param1:IListX) : void
      {
         this.dataGroup.setDataProvider(param1);
         this.dataGroupBottom.setDataProvider(param1);
         this._selectionBehavior.setDataProvider(param1);
      }
      
      public function getLayoutAlgorithm() : IVirtualizedLayoutAlgorithm
      {
         return this.dataGroup.getLayoutAlgorithm();
      }
      
      public function setLayoutAlgorithm(param1:IVirtualizedLayoutAlgorithm) : void
      {
         this.dataGroup.setLayoutAlgorithm(param1);
         this.dataGroupBottom.setLayoutAlgorithm(param1);
      }
      
      public function getRendererFactory() : IRendererFactory
      {
         return this.dataGroup.getRendererFactory();
      }
      
      public function setRendererFactory(param1:IRendererFactory) : void
      {
         this.dataGroup.setRendererFactory(param1);
         this.dataGroupBottom.setRendererFactory(param1);
         if(this._selectionEnabled)
         {
            this._selectionBehavior.setRendererFactory(param1);
         }
      }
      
      public function invalidateCache() : void
      {
         this.dataGroup.invalidateCache();
         this.dataGroupBottom.invalidateCache();
      }
      
      public function getDataGroup() : DataGroup
      {
         return this.dataGroup;
      }
      
      public function getHScrollBar() : ScrollBarBase
      {
         return this.hScrollBar;
      }
      
      public function getVScrollBar() : ScrollBarBase
      {
         return this.vScrollBar;
      }
      
      public function getPosition() : Number
      {
         return this.dataGroup.getPosition();
      }
      
      public function setPosition(param1:Number) : void
      {
         this.dataGroup.setPosition(param1);
      }
      
      public function getVisiblePosition() : Number
      {
         return this.dataGroup.getVisiblePosition();
      }
      
      public function getBottomPosition() : Number
      {
         return this.dataGroup.getBottomPosition();
      }
      
      public function setBottomPosition(param1:Number) : void
      {
         this.dataGroup.setBottomPosition(param1);
      }
      
      public function getVisibleBottomPosition() : Number
      {
         return this.dataGroup.getVisibleBottomPosition();
      }
      
      public function getActiveEntries() : Vector.<LayoutEntry>
      {
         return this.dataGroup.getActiveEntries();
      }
      
      public function getNumActiveEntries() : uint
      {
         return this.dataGroup.getNumActiveEntries();
      }
      
      public function getScrollModel() : ScrollModel
      {
         return this._scrollModel;
      }
      
      public function getScrollPolicy() : uint
      {
         return this._scrollPolicy;
      }
      
      public function getScrollBarsAutoPosition() : Boolean
      {
         return this._scrollBarsAutoPosition;
      }
      
      public function getKineticScroller() : KineticScroller
      {
         return this._kineticScroller;
      }
      
      public function getSelectionBehavior() : SelectionBehavior
      {
         return this._selectionBehavior;
      }
      
      public function getSnappingBehavior() : SnappingBehavior
      {
         return this._snappingBehavior;
      }
      
      public function setScrollPolicy(param1:uint) : void
      {
         if(this._scrollPolicy == param1)
         {
            return;
         }
         this._scrollPolicy = param1;
         invalidateLayout();
      }
      
      public function setScrollBarsAutoPosition(param1:Boolean) : void
      {
         if(this._scrollBarsAutoPosition == param1)
         {
            return;
         }
         this._scrollBarsAutoPosition = param1;
         invalidateLayout();
      }
      
      public function getMouseWheelEnabled() : Boolean
      {
         return this._mouseWheelEnabled;
      }
      
      public function setMouseWheelEnabled(param1:Boolean) : void
      {
         if(this._mouseWheelEnabled == param1)
         {
            return;
         }
         if(this._mouseWheelEnabled)
         {
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
         this._mouseWheelEnabled = param1;
         if(this._mouseWheelEnabled)
         {
            addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
      }
      
      protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         this._scrollModel.setValue(this._scrollModel.clampValue(this._scrollModel.getValue() - param1.delta * this.mouseDelta));
         this._snappingBehavior.mouseWheelHandler(param1);
      }
      
      public function setPadding(param1:Padding) : void
      {
         this._padding = param1;
         invalidateLayout();
      }
      
      public function setKineticScrolling(param1:Boolean) : void
      {
         this._kineticScroller.setEnabled(param1);
      }
      
      public function scrollToBottom() : void
      {
         this.setBottomPosition(this.getDataProvider().getLength() - 1);
      }
      
      public function getSelectionEnabled() : Boolean
      {
         return this._selectionEnabled;
      }
      
      public function setSelectionEnabled(param1:Boolean) : void
      {
         if(this._selectionEnabled == param1)
         {
            return;
         }
         this._selectionEnabled = param1;
         if(this._selectionEnabled)
         {
            this._selectionBehavior.setRendererFactory(this.dataGroup.getRendererFactory());
         }
         else
         {
            this._selectionBehavior.setRendererFactory(null);
         }
      }
      
      override public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         var _loc3_:MinMax = new MinMax();
         var _loc4_:MinMax = new MinMax();
         var _loc5_:SizeConstraints = this.dataGroup.setAvailableSize(param1,param2);
         _loc3_.bound(_loc5_.width);
         _loc4_.bound(_loc5_.height);
         var _loc6_:SizeConstraints = this.vScrollBar.setAvailableSize(param1,param2);
         _loc4_.bound(_loc6_.height);
         _loc3_.min += _loc6_.width.min;
         return new SizeConstraints(_loc3_,_loc4_);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc8_:Rectangle = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc6_:Number = param1 - this._padding.left - this._padding.right;
         var _loc7_:Number = param2 - this._padding.top - this._padding.bottom;
         this.vScrollBar.setVisible(true);
         this.hScrollBar.setVisible(true);
         if(Boolean(this.vScrollBar.getIncludeInLayout()) || Boolean(this.hScrollBar.getIncludeInLayout()))
         {
            _loc3_ = this._scrollPolicy == ScrollPolicy.ON;
            _loc4_ = this._scrollPolicy != ScrollPolicy.OFF;
         }
         if(_loc4_ && Boolean(this.vScrollBar.getIncludeInLayout()))
         {
            this.vScrollBar.setExplicitSize(NaN,NaN);
            _loc8_ = this.vScrollBar.getScaledBounds();
         }
         else
         {
            _loc8_ = new Rectangle();
         }
         if(_loc4_ && Boolean(this.hScrollBar.getIncludeInLayout()))
         {
            this.hScrollBar.setExplicitSize(NaN,NaN);
            _loc9_ = this.hScrollBar.getScaledBounds();
         }
         else
         {
            _loc9_ = new Rectangle();
         }
         _loc12_ = this.dataGroup.getDataProvider().getLength() - 1;
         this.dataGroupBottom.setBottomPosition(_loc12_);
         if(!_loc3_)
         {
            this._scrollAreaSize = new Point(_loc6_,_loc7_);
            this.dataGroupBottom.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
            _loc11_ = this.dataGroupBottom.getVisiblePosition();
         }
         if(_loc3_ || _loc4_ && _loc11_ > 0)
         {
            _loc5_ = true;
            if(this._scrollBarsAutoPosition)
            {
               this._scrollAreaSize = new Point(_loc6_ - _loc8_.width,_loc7_ - _loc9_.height);
            }
            else
            {
               this._scrollAreaSize = new Point(_loc6_,_loc7_);
            }
            this.dataGroupBottom.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
            _loc11_ = this.dataGroupBottom.getVisiblePosition();
         }
         if(this.dataGroup.getPosition() > _loc11_)
         {
            this.dataGroup.setPosition(_loc11_);
         }
         var _loc13_:Point = this.dataGroup.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
         _loc10_ = this.dataGroup.getVisiblePosition();
         this._scrollModel.setMax(_loc11_);
         var _loc14_:Rectangle = new Rectangle(0,0,_loc13_.x + this._padding.left + this._padding.right,_loc13_.y + this._padding.top + this._padding.bottom);
         if(!isNaN(param1))
         {
            _loc14_.width = Math.min(param1,_loc14_.width);
         }
         if(!isNaN(param2))
         {
            _loc14_.height = Math.min(param2,_loc14_.height);
         }
         this.vScrollBar.setVisible(_loc5_);
         this.hScrollBar.setVisible(_loc5_);
         if(_loc5_)
         {
            this._scrollModel.setValue(_loc10_);
            this.modelToPixels = _loc14_.height / (_loc12_ - _loc11_);
            if(this.vScrollBar.getIncludeInLayout())
            {
               this.vScrollBar.modelToPixels = this.modelToPixels;
               this.vScrollBar.setExplicitSize(NaN,_loc14_.height);
               if(this._scrollBarsAutoPosition)
               {
                  this.vScrollBar.setExplicitPosition(_loc14_.width,0);
                  _loc14_.width += _loc8_.width;
               }
            }
            else if(this.hScrollBar.getIncludeInLayout())
            {
               this.hScrollBar.modelToPixels = this.modelToPixels;
               this.hScrollBar.setExplicitSize(_loc14_.width,NaN);
               if(this._scrollBarsAutoPosition)
               {
                  this.hScrollBar.setExplicitPosition(0,_loc14_.height);
                  _loc14_.height += _loc9_.height;
               }
            }
            this._kineticScroller.modelToPixels = this.modelToPixels;
         }
         this.dataGroup.setExplicitPosition(this._padding.left,this._padding.top);
         return _loc14_;
      }
      
      override public function destroy() : void
      {
         this.setDataProvider(null);
         this._snappingBehavior.destroy();
         this._selectionBehavior.destroy();
         this._scrollModel.getChanged().remove(this.scrollModelChangedHandler);
         this._kineticScroller.destroy();
         super.destroy();
      }
   }
}

