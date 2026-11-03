package blix.components.scroll
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.Padding;
   import blix.layout.vo.SizeConstraints;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ScrollAreaBase extends SpriteProxy
   {
      
      public var mouseDelta:Number = 10;
      
      protected var _viewArea:DisplayObjectProxy;
      
      protected var _mouseWheelEnabled:Boolean = true;
      
      protected var _hScrollModel:ScrollModel;
      
      protected var _vScrollModel:ScrollModel;
      
      protected var _hScrollPolicy:uint = 2;
      
      protected var _vScrollPolicy:uint = 2;
      
      protected var _scrollBarsAutoPosition:Boolean = true;
      
      protected var _padding:Padding = new Padding();
      
      protected var _scrollAreaSize:Point;
      
      protected var hScrollBar:HScrollBarX;
      
      protected var vScrollBar:VScrollBarX;
      
      protected var kineticScroller:KineticScroller;
      
      private var scrollingIsValidFlag:Boolean;
      
      public function ScrollAreaBase(param1:IContext)
      {
         super(param1);
         if(this._viewArea == null)
         {
            throw new Error("Abstract property _viewArea has not been set.");
         }
         getIsOnStageChanged().add(this.isOnStageChangedHandler);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this._hScrollModel == null)
         {
            this._hScrollModel = new ScrollModel();
         }
         if(this._vScrollModel == null)
         {
            this._vScrollModel = new ScrollModel();
         }
         this._hScrollModel.getChanged().add(this.invalidateScrolling);
         this._vScrollModel.getChanged().add(this.invalidateScrolling);
      }
      
      protected function isOnStageChangedHandler() : void
      {
         this.refreshMouseWheelHandling();
      }
      
      protected function refreshMouseWheelHandling() : void
      {
         if(Boolean(getIsOnStage()) && this._mouseWheelEnabled)
         {
            _stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler,false,0,true);
         }
         else if(_stage != null)
         {
            _stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
      }
      
      protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         _loc2_ = globalToLocal(_loc2_);
         if(getUnscaledBounds().contains(_loc2_.x,_loc2_.y))
         {
            this._vScrollModel.setValue(this._vScrollModel.clampValue(this._vScrollModel.getValue() - param1.delta * this.mouseDelta));
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HScrollBarX = null;
         var _loc2_:VScrollBarX = null;
         super.createChildren();
         if(this.hScrollBar == null)
         {
            _loc1_ = new HScrollBarX(this);
            _loc1_.setScrollModel(this.getHScrollModel());
            setTimelineChildByName("hScrollBar",_loc1_);
            this.hScrollBar = _loc1_;
         }
         this.hScrollBar.getLayoutInvalidated().add(invalidateLayout);
         if(this.vScrollBar == null)
         {
            _loc2_ = new VScrollBarX(this);
            _loc2_.setScrollModel(this.getVScrollModel());
            setTimelineChildByName("vScrollBar",_loc2_);
            this.vScrollBar = _loc2_;
         }
         this.vScrollBar.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function getHScrollModel() : ScrollModel
      {
         return this._hScrollModel;
      }
      
      public function getVScrollModel() : ScrollModel
      {
         return this._vScrollModel;
      }
      
      public function getHScrollPolicy() : uint
      {
         return this._hScrollPolicy;
      }
      
      public function setHScrollPolicy(param1:uint) : void
      {
         if(this._hScrollPolicy == param1)
         {
            return;
         }
         this._hScrollPolicy = param1;
         invalidateLayout();
      }
      
      public function getVScrollPolicy() : uint
      {
         return this._vScrollPolicy;
      }
      
      public function setVScrollPolicy(param1:uint) : void
      {
         if(this._vScrollPolicy == param1)
         {
            return;
         }
         this._vScrollPolicy = param1;
         invalidateLayout();
      }
      
      public function getScrollBarsAutoPosition() : Boolean
      {
         return this._scrollBarsAutoPosition;
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
         this._mouseWheelEnabled = param1;
         this.refreshMouseWheelHandling();
      }
      
      public function setPadding(param1:Padding) : void
      {
         this._padding = param1;
         invalidateLayout();
      }
      
      public function setKineticScrolling(param1:Boolean) : void
      {
         if(param1)
         {
            this.kineticScroller = new KineticScroller(this._viewArea,this._hScrollModel,this._vScrollModel);
         }
         else if(Boolean(this.kineticScroller))
         {
            this.kineticScroller.destroy();
            this.kineticScroller = null;
         }
      }
      
      override public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         var _loc3_:MinMax = new MinMax();
         var _loc4_:MinMax = new MinMax();
         var _loc5_:SizeConstraints = this._viewArea.setAvailableSize(param1,param2);
         _loc3_.bound(_loc5_.width);
         _loc4_.bound(_loc5_.height);
         var _loc6_:SizeConstraints = this.hScrollBar.setAvailableSize(param1,param2);
         _loc3_.bound(_loc6_.width);
         var _loc7_:SizeConstraints = this.vScrollBar.setAvailableSize(param1,param2);
         _loc4_.bound(_loc7_.height);
         _loc4_.min += _loc6_.height.min;
         _loc3_.min += _loc7_.width.min;
         return new SizeConstraints(_loc3_,_loc4_);
      }
      
      override public function validate() : void
      {
         super.validate();
         if(!this.scrollingIsValidFlag)
         {
            this.validateScrolling();
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc13_:Point = null;
         this.scrollingIsValidFlag = false;
         var _loc9_:Number = param1 - this._padding.left - this._padding.right;
         var _loc10_:Number = param2 - this._padding.top - this._padding.bottom;
         this.hScrollBar.validate();
         this.vScrollBar.validate();
         var _loc11_:Rectangle = this.hScrollBar.getScaledBounds();
         var _loc12_:Rectangle = this.vScrollBar.getScaledBounds();
         if(Boolean(_loc11_.height))
         {
            _loc3_ = this._hScrollPolicy == ScrollPolicy.ON;
            _loc5_ = this._hScrollPolicy != ScrollPolicy.OFF;
         }
         if(Boolean(_loc12_.width))
         {
            _loc4_ = this._vScrollPolicy == ScrollPolicy.ON;
            _loc6_ = this._vScrollPolicy != ScrollPolicy.OFF;
         }
         if(!this._scrollBarsAutoPosition)
         {
            _loc11_ = new Rectangle();
            _loc12_ = new Rectangle();
         }
         if(_loc3_ || _loc4_)
         {
            _loc13_ = new Point(NaN,NaN);
         }
         else
         {
            this._scrollAreaSize = new Point(_loc9_,_loc10_);
            _loc13_ = this._viewArea.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
         }
         if(_loc3_ && _loc4_ || _loc5_ && this.getNeedsHScrollBar() && (_loc6_ && this.getNeedsVScrollBar()))
         {
            _loc7_ = true;
            _loc8_ = true;
            this._scrollAreaSize = new Point(_loc9_ - _loc12_.width,_loc10_ - _loc11_.height);
            _loc13_ = this._viewArea.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
         }
         else if(_loc3_ || _loc5_ && this.getNeedsHScrollBar())
         {
            _loc7_ = true;
            this._scrollAreaSize = new Point(_loc9_,_loc10_ - _loc11_.height);
            _loc13_ = this._viewArea.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
            if(_loc6_ && this.getNeedsVScrollBar())
            {
               _loc8_ = true;
               this._scrollAreaSize = new Point(_loc9_ - _loc12_.width,_loc10_ - _loc11_.height);
               _loc13_ = this._viewArea.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
            }
         }
         else if(_loc4_ || _loc6_ && this.getNeedsVScrollBar())
         {
            _loc8_ = true;
            this._scrollAreaSize = new Point(_loc9_ - _loc12_.width,_loc10_);
            _loc13_ = this._viewArea.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
            if(_loc5_ && this.getNeedsHScrollBar())
            {
               _loc7_ = true;
               this._scrollAreaSize = new Point(_loc9_ - _loc12_.width,_loc10_ - _loc11_.height);
               _loc13_ = this._viewArea.setExplicitSize(this._scrollAreaSize.x,this._scrollAreaSize.y);
            }
         }
         var _loc14_:Rectangle = new Rectangle();
         if(isNaN(param1))
         {
            _loc14_.width = _loc13_.x + this._padding.left + this._padding.right;
         }
         else
         {
            _loc14_.width = Math.min(param1,this._scrollAreaSize.x + this._padding.left + this._padding.right);
         }
         if(isNaN(param2))
         {
            _loc14_.height = _loc13_.y + this._padding.top + this._padding.bottom;
         }
         else
         {
            _loc14_.height = Math.min(param2,this._scrollAreaSize.y + this._padding.top + this._padding.bottom);
         }
         this.updateScrollModel(_loc7_,_loc8_);
         this.updateScrollBars(_loc7_,_loc8_,_loc14_);
         this._viewArea.setExplicitPosition(this._padding.left,this._padding.top);
         this.validateScrolling();
         return _loc14_;
      }
      
      protected function getNeedsHScrollBar() : Boolean
      {
         return this._viewArea.getScaledBounds().width > this._scrollAreaSize.x + 0.5;
      }
      
      protected function getNeedsVScrollBar() : Boolean
      {
         return this._viewArea.getScaledBounds().height > this._scrollAreaSize.y + 0.5;
      }
      
      protected function updateScrollModel(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            this._hScrollModel.setMax(this._viewArea.getScaledBounds().width - this._scrollAreaSize.x);
         }
         else
         {
            this._hScrollModel.setMax(0);
         }
         if(param2)
         {
            this._vScrollModel.setMax(this._viewArea.getScaledBounds().height - this._scrollAreaSize.y);
         }
         else
         {
            this._vScrollModel.setMax(0);
         }
      }
      
      protected function updateScrollBars(param1:Boolean, param2:Boolean, param3:Rectangle) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         this.hScrollBar.setVisible(param1);
         this.vScrollBar.setVisible(param2);
         if(param1 && param2)
         {
            _loc4_ = this.hScrollBar.setExplicitSize(param3.width,NaN);
            _loc5_ = this.vScrollBar.setExplicitSize(NaN,param3.height);
         }
         else if(param1)
         {
            _loc4_ = this.hScrollBar.setExplicitSize(param3.width,NaN);
         }
         else if(param2)
         {
            _loc5_ = this.vScrollBar.setExplicitSize(NaN,param3.height);
         }
         if(this._scrollBarsAutoPosition)
         {
            if(param1)
            {
               this.hScrollBar.setExplicitPosition(0,param3.height);
               param3.height += _loc4_.y;
            }
            if(param2)
            {
               this.vScrollBar.setExplicitPosition(param3.width,0);
               param3.width += _loc5_.x;
            }
         }
      }
      
      public function invalidateScrolling() : void
      {
         if(_isValidatingLayout)
         {
            return;
         }
         this.scrollingIsValidFlag = false;
         invalidate();
      }
      
      protected function validateScrolling() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Rectangle = null;
         if(this._scrollAreaSize != null)
         {
            _loc1_ = this._scrollAreaSize.x;
            _loc2_ = this._scrollAreaSize.y;
            _loc3_ = this._viewArea.getScaledBounds();
            if(isNaN(_loc1_))
            {
               _loc1_ = _loc3_.width;
            }
            if(isNaN(_loc2_))
            {
               _loc2_ = _loc3_.height;
            }
            this.setVisibleArea(new Rectangle(this._hScrollModel.getClampedValue() || 0,this._vScrollModel.getClampedValue() || 0,_loc1_,_loc2_));
         }
         this.scrollingIsValidFlag = true;
      }
      
      protected function setVisibleArea(param1:Rectangle) : void
      {
         this._viewArea.setScrollRect(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._hScrollModel.getChanged().remove(this.invalidateScrolling);
         this._vScrollModel.getChanged().remove(this.invalidateScrolling);
         this.setKineticScrolling(false);
      }
   }
}

