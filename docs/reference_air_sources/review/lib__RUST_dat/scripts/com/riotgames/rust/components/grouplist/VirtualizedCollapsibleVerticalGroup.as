package com.riotgames.rust.components.grouplist
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class VirtualizedCollapsibleVerticalGroup extends SpriteProxy
   {
      
      private var _group:GroupModel;
      
      private var _visibility:VisibilityModel;
      
      private var _headerRendererFactory:IRendererPool;
      
      private var _itemRendererFactory:IRendererPool;
      
      private var _headerPadding:Number = 2;
      
      private var _itemPadding:Number = 2;
      
      private var _headerRenderer:DisplayObjectProxy;
      
      private var _itemRenderers:Array = [];
      
      private var _renderersInvalid:Boolean = true;
      
      private var _itemPositionCache:Array = [];
      
      private var _headerHeight:Number = 0;
      
      private var _totalHeight:Number = 10;
      
      private var _positionsValid:Boolean = false;
      
      private var _layoutHeight:Number = 10;
      
      public function VirtualizedCollapsibleVerticalGroup(param1:IContext, param2:GroupModel, param3:VisibilityModel, param4:IRendererPool, param5:IRendererPool)
      {
         this._group = param2;
         this._visibility = param3;
         this._visibility.visibleRectChanged.add(this.onVisibilityChanged);
         this._headerRendererFactory = param4;
         this._headerRendererFactory.getRendererBoundsChanged().add(this.onArtChanged);
         this._itemRendererFactory = param5;
         this._itemRendererFactory.getRendererBoundsChanged().add(this.onArtChanged);
         super(param1,new Sprite());
         this.onArtChanged();
      }
      
      override protected function createChildren() : void
      {
         this._group.itemsChanged.add(this.onItemsChanged);
         this._group.expandedChanged.add(this.onExpandedChanged);
         this.invalidateRenderers();
      }
      
      public function set headerPadding(param1:Number) : void
      {
         this._headerPadding = param1;
         this.calculatePositions();
         this.invalidateRenderers();
      }
      
      public function set itemPadding(param1:Number) : void
      {
         this._itemPadding = param1;
         this.calculatePositions();
         this.invalidateRenderers();
      }
      
      private function onArtChanged() : void
      {
         this.calculatePositions();
         this.invalidateRenderers();
      }
      
      private function onItemsChanged() : void
      {
         this.removeItems();
         this.calculatePositions();
         this.invalidateRenderers();
      }
      
      private function onExpandedChanged() : void
      {
         TweenLite.killTweensOf(this);
         if(this._group.expanded)
         {
            TweenLite.to(this,0.3,{
               "layoutHeight":this._totalHeight,
               "ease":Sine.easeIn
            });
         }
         else
         {
            TweenLite.to(this,0.3,{
               "layoutHeight":this._headerHeight,
               "ease":Sine.easeOut
            });
         }
      }
      
      public function getGroupModel() : GroupModel
      {
         return this._group;
      }
      
      public function get layoutHeight() : Number
      {
         return this._layoutHeight;
      }
      
      public function set layoutHeight(param1:Number) : void
      {
         this._layoutHeight = param1;
         this.invalidateRenderers();
      }
      
      private function invalidateRenderers() : void
      {
         this._renderersInvalid = true;
         invalidateLayout();
      }
      
      private function onVisibilityChanged() : void
      {
         this.invalidateRenderers();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this._renderersInvalid)
         {
            this.render();
         }
         var _loc3_:Rectangle = new Rectangle(0,0,param1,this._layoutHeight);
         this.setScrollRect(_loc3_);
         return _loc3_;
      }
      
      override protected function updatePosition(param1:Number, param2:Number) : Point
      {
         setX(param1);
         setY(param2);
         this.render();
         return new Point(param1,param2);
      }
      
      private function render() : void
      {
         if(!this._positionsValid)
         {
            return;
         }
         this.renderHeader();
         this.renderItems();
         this._renderersInvalid = false;
      }
      
      private function calculatePositions() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Rectangle = null;
         if(!this._group)
         {
            return;
         }
         var _loc1_:Rectangle = this._headerRendererFactory.getRendererBounds(this._group);
         if(_loc1_.width == 0 || _loc1_.height == 0)
         {
            return;
         }
         this._headerHeight = _loc1_.height;
         var _loc2_:Number = this._headerHeight;
         if(this._group.itemData.length > 0)
         {
            _loc2_ += this._headerPadding;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._group.itemData.length)
         {
            _loc4_ = this._group.itemData[_loc3_];
            _loc5_ = this._itemRendererFactory.getRendererBounds(_loc4_);
            if(_loc5_.width == 0 || _loc5_.height == 0)
            {
               return;
            }
            this._itemPositionCache[_loc3_] = {
               "y":_loc2_,
               "height":_loc5_.height
            };
            _loc2_ += _loc5_.height + this._itemPadding;
            _loc3_++;
         }
         if(this._group.itemData.length > 0)
         {
            _loc2_ -= this._itemPadding;
         }
         this._totalHeight = _loc2_;
         this._positionsValid = true;
         this._layoutHeight = this._group.expanded ? this._totalHeight : this._headerHeight;
      }
      
      private function renderHeader() : void
      {
         var _loc1_:IDataRenderer = null;
         if(this.isSpanVisible(0,this._headerHeight))
         {
            if(!this._headerRenderer)
            {
               this._headerRenderer = this._headerRendererFactory.getInstance();
               if(this._headerRenderer is IDataRenderer)
               {
                  _loc1_ = this._headerRenderer as IDataRenderer;
                  _loc1_.setData(this._group);
               }
               addChild(this._headerRenderer);
            }
            this._headerRenderer.setExplicitSize(_explicitSize.x,NaN);
            this._headerRenderer.setExplicitPosition(0,0);
         }
         else if(Boolean(this._headerRenderer))
         {
            removeChild(this._headerRenderer);
            this._headerRendererFactory.returnInstance(this._headerRenderer);
            this._headerRenderer = null;
         }
      }
      
      private function isSpanVisible(param1:Number, param2:Number) : Boolean
      {
         if(param1 > this._layoutHeight)
         {
            return false;
         }
         var _loc3_:Number = this.getY() + param1;
         return !(_loc3_ > this._visibility.visibleRect.bottom || _loc3_ + param2 < this._visibility.visibleRect.top);
      }
      
      private function renderItems() : void
      {
         var _loc1_:DisplayObjectProxy = null;
         var _loc3_:IDataRenderer = null;
         if(!this.isSpanVisible(0,this._totalHeight))
         {
            this.removeItems();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._group.itemData.length)
         {
            if(this.isSpanVisible(this._itemPositionCache[_loc2_].y,this._itemPositionCache[_loc2_].height))
            {
               if(!this._itemRenderers[_loc2_])
               {
                  _loc1_ = this._itemRendererFactory.getInstance();
                  if(_loc1_ is IDataRenderer)
                  {
                     _loc3_ = _loc1_ as IDataRenderer;
                     _loc3_.setData(this._group.itemData[_loc2_]);
                  }
                  this._itemRenderers[_loc2_] = _loc1_;
                  addChild(_loc1_);
               }
               this._itemRenderers[_loc2_].setExplicitSize(_explicitSize.x,NaN);
               this._itemRenderers[_loc2_].setExplicitPosition(0,this._itemPositionCache[_loc2_].y);
            }
            else if(Boolean(this._itemRenderers[_loc2_]))
            {
               removeChild(this._itemRenderers[_loc2_]);
               this._itemRendererFactory.returnInstance(this._itemRenderers[_loc2_]);
               delete this._itemRenderers[_loc2_];
            }
            _loc2_++;
         }
      }
      
      private function removeItems() : void
      {
         var _loc1_:DisplayObjectProxy = null;
         if(this._itemRenderers.length > 0)
         {
            for each(_loc1_ in this._itemRenderers)
            {
               this.removeChild(_loc1_);
               this._itemRendererFactory.returnInstance(_loc1_);
            }
            this._itemRenderers = [];
         }
      }
      
      override public function setExplicitSize(param1:Number, param2:Number) : Point
      {
         return super.setExplicitSize(param1,param2);
      }
   }
}

