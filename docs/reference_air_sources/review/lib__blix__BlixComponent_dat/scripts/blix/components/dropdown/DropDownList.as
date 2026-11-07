package blix.components.dropdown
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.IRendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import blix.util.display.isAncestor;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DropDownList extends SpriteProxy
   {
      
      protected var background:SpriteProxy;
      
      protected var _relativeTo:DisplayObjectProxy;
      
      protected var _gap:Number = 0;
      
      protected var _margin:Padding = new Padding();
      
      protected var _originalBounds:Rectangle;
      
      protected var _dataScroller:DataScroller;
      
      protected var _defaultScrollerLayout:VirtualizedVerticalLayout;
      
      public function DropDownList(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.background == null)
         {
            this.background = new SpriteProxy(this);
            this.background.setTransformBehavior(new ScalingTransformBehavior());
            setTimelineChildByName("background",this.background);
         }
         if(this._dataScroller == null)
         {
            this._dataScroller = new DataScroller(this);
            this._dataScroller.setScrollPolicy(ScrollPolicy.AUTO);
            this._dataScroller.getLayoutInvalidated().add(invalidateLayout);
            setTimelineChildByName("dataScroller",this._dataScroller);
         }
         if(this._defaultScrollerLayout == null)
         {
            this._defaultScrollerLayout = new VirtualizedVerticalLayout();
            this._dataScroller.setLayoutAlgorithm(this._defaultScrollerLayout);
         }
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            this._originalBounds = param1.getBounds(null);
         }
         super.configureAsset(param1);
      }
      
      public function getDataScroller() : DataScroller
      {
         return this._dataScroller;
      }
      
      public function getRendererFactory() : IRendererFactory
      {
         return this._dataScroller.getRendererFactory();
      }
      
      public function setRendererFactory(param1:IRendererFactory) : void
      {
         this._dataScroller.setRendererFactory(param1);
      }
      
      public function show(param1:DisplayObjectProxy) : void
      {
         this._relativeTo = param1;
         getEnterFrame().add(this.positionEnterFrameHandler);
         this.positionEnterFrameHandler();
      }
      
      public function hide() : void
      {
         this._relativeTo = null;
         getEnterFrame().remove(this.positionEnterFrameHandler);
      }
      
      protected function positionEnterFrameHandler() : void
      {
         var _loc4_:Point = null;
         if(_stage == null)
         {
            return;
         }
         var _loc1_:Rectangle = this._relativeTo.getUnscaledBounds();
         var _loc2_:Point = this._relativeTo.localToGlobal(new Point(_loc1_.left,_loc1_.bottom));
         validate();
         var _loc3_:Rectangle = getScaledBounds();
         if(_loc2_.y + this._gap + _loc3_.height > _stage.stageHeight)
         {
            _loc4_ = this._relativeTo.localToGlobal(_loc1_.topLeft);
            setExplicitPosition(_loc2_.x,Math.max(0,_loc4_.y - this._gap - _loc3_.height));
         }
         else
         {
            setExplicitPosition(_loc2_.x,_loc2_.y + this._gap);
         }
      }
      
      public function owns(param1:DisplayObject) : Boolean
      {
         return isAncestor(_asset,param1);
      }
      
      public function invalidateRendererCache() : void
      {
         this._dataScroller.invalidateCache();
      }
      
      public function getGap() : Number
      {
         return this._gap;
      }
      
      public function setGap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         invalidateLayout();
      }
      
      public function getPadding() : Padding
      {
         return this._margin;
      }
      
      public function setMargin(param1:Padding) : void
      {
         this._margin = param1;
      }
      
      public function getDefaultScrollerLayout() : VirtualizedVerticalLayout
      {
         return this._defaultScrollerLayout;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this._relativeTo == null)
         {
            return new Rectangle();
         }
         if(isNaN(param1))
         {
            param1 = this._originalBounds.width;
         }
         if(isNaN(param2))
         {
            param2 = this._originalBounds.height;
         }
         this._dataScroller.setExplicitSize(param1 - this._margin.left - this._margin.right,param2 - this._margin.top - this._margin.bottom);
         this._dataScroller.setExplicitPosition(this._margin.left,this._margin.top);
         var _loc3_:Rectangle = this._dataScroller.getDataGroup().getMeasuredBounds();
         var _loc4_:Rectangle = new Rectangle(0,0,param1,param2);
         if(this._dataScroller.getNumActiveEntries() == this.getDataScroller().getDataProvider().getLength())
         {
            _loc4_.height = Math.min(param2,_loc3_.bottom);
         }
         this.background.setExplicitSize(_loc4_.width,_loc4_.height);
         return _loc4_;
      }
      
      override public function destroy() : void
      {
         this.hide();
         super.destroy();
      }
   }
}

