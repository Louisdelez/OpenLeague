package blix.components.list
{
   import blix.IDestructible;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.components.shape.Rect;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListX;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.IVirtualizedLayoutAlgorithm;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.util.math.clamp;
   import blix.view.ILayoutElement;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class DataGroup extends SpriteProxy implements IDestructible
   {
      
      public var maxSkipped:uint = 15;
      
      protected var _activeEntries:Vector.<LayoutEntry>;
      
      protected var _bottomPosition:Number;
      
      protected var _dataProvider:IListX;
      
      protected var _layoutAlgorithm:IVirtualizedLayoutAlgorithm;
      
      protected var _measuredBounds:Rectangle;
      
      protected var _position:Number = 0;
      
      protected var _rendererFactory:IRendererFactory;
      
      protected var _visiblePosition:Number;
      
      protected var _visibleBottomPosition:Number;
      
      protected var hitArea:Rect;
      
      public function DataGroup(param1:IContext, param2:IListX = null, param3:IRendererFactory = null, param4:Sprite = null)
      {
         super(param1,param4 || new Sprite());
         this._activeEntries = new Vector.<LayoutEntry>();
         if(this._layoutAlgorithm == null)
         {
            this._layoutAlgorithm = new VirtualizedVerticalLayout();
         }
         if(param2 != null)
         {
            this.setDataProvider(param2);
         }
         if(this._dataProvider == null)
         {
            this.setDataProvider(new ListX());
         }
         if(param3 != null)
         {
            this.setRendererFactory(param3);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.hitArea == null)
         {
            this.hitArea = new Rect(this);
            this.hitArea.setAlpha(0);
            addChild(this.hitArea);
         }
         _explicitSize.x = 0;
         _explicitSize.y = 0;
      }
      
      public function getDataProvider() : IListX
      {
         return this._dataProvider;
      }
      
      public function setDataProvider(param1:IListX) : void
      {
         if(this._dataProvider != null)
         {
            this._dataProvider.getReset().remove(invalidateLayout);
            this._dataProvider.getItemsAdded().remove(invalidateLayout);
            this._dataProvider.getItemsRemoved().remove(invalidateLayout);
         }
         this._dataProvider = param1 || new ListX();
         this._dataProvider.getReset().add(invalidateLayout);
         this._dataProvider.getItemsAdded().add(invalidateLayout);
         this._dataProvider.getItemsRemoved().add(invalidateLayout);
         invalidateLayout();
      }
      
      public function getLayoutAlgorithm() : IVirtualizedLayoutAlgorithm
      {
         return this._layoutAlgorithm;
      }
      
      public function setLayoutAlgorithm(param1:IVirtualizedLayoutAlgorithm) : void
      {
         if(this._layoutAlgorithm != null)
         {
            this._layoutAlgorithm.getLayoutInvalidated().remove(invalidateLayout);
         }
         this._layoutAlgorithm = param1;
         if(this._layoutAlgorithm != null)
         {
            this._layoutAlgorithm.getLayoutInvalidated().add(invalidateLayout);
         }
      }
      
      public function getRendererFactory() : IRendererFactory
      {
         return this._rendererFactory;
      }
      
      public function setRendererFactory(param1:IRendererFactory) : void
      {
         if(this._rendererFactory != null)
         {
            this.invalidateCache();
         }
         this._rendererFactory = param1;
         invalidateLayout();
      }
      
      public function invalidateCache() : void
      {
         var _loc1_:LayoutEntry = null;
         for each(_loc1_ in this._activeEntries)
         {
            this.deactivateEntry(_loc1_);
            this._rendererFactory.returnEntry(_loc1_);
         }
         this._activeEntries.length = 0;
         invalidateLayout();
      }
      
      public function getPosition() : Number
      {
         return this._position;
      }
      
      public function setPosition(param1:Number) : void
      {
         if(this._position == param1)
         {
            return;
         }
         this._bottomPosition = NaN;
         this._position = param1;
         invalidateLayout();
      }
      
      public function getVisiblePosition() : Number
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:IItemRenderer = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Number = NaN;
         if(isNaN(this._visiblePosition))
         {
            _loc1_ = this.getDataProvider().getLength() - 1;
            _loc2_ = this._activeEntries.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._activeEntries[_loc3_].element as IItemRenderer;
               _loc5_ = _loc4_.getScaledBounds();
               _loc6_ = this._layoutAlgorithm.getOffset(_unscaledBounds,_loc5_,_loc4_.getIndex(),_loc1_,false);
               this._visiblePosition = _loc4_.getIndex() - _loc6_;
               if(_loc6_ > -1)
               {
                  break;
               }
               _loc3_++;
            }
         }
         return this._visiblePosition;
      }
      
      public function getBottomPosition() : Number
      {
         return this._bottomPosition;
      }
      
      public function setBottomPosition(param1:Number) : void
      {
         if(this._bottomPosition == param1)
         {
            return;
         }
         this._position = NaN;
         this._bottomPosition = param1;
         invalidateLayout();
      }
      
      public function getVisibleBottomPosition() : Number
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:IItemRenderer = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         if(isNaN(this._visibleBottomPosition))
         {
            _loc1_ = this.getDataProvider().getLength() - 1;
            _loc2_ = this._activeEntries.length;
            while(Boolean(_loc2_--))
            {
               _loc3_ = this._activeEntries[_loc2_].element as IItemRenderer;
               _loc4_ = _loc3_.getScaledBounds();
               _loc5_ = this._layoutAlgorithm.getOffset(_unscaledBounds,_loc4_,_loc3_.getIndex(),_loc1_,true);
               this._visibleBottomPosition = _loc3_.getIndex() + _loc5_;
               if(_loc5_ > -1)
               {
                  break;
               }
            }
         }
         return this._visibleBottomPosition;
      }
      
      public function getActiveEntries() : Vector.<LayoutEntry>
      {
         return this._activeEntries.slice();
      }
      
      public function getNumActiveEntries() : uint
      {
         return this._activeEntries.length;
      }
      
      public function getMeasuredBounds() : Rectangle
      {
         return this._measuredBounds;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc4_:LayoutEntry = null;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc9_:Rectangle = null;
         var _loc13_:Vector.<Rectangle> = null;
         var _loc14_:LayoutEntry = null;
         var _loc15_:Rectangle = null;
         this._visiblePosition = NaN;
         this._visibleBottomPosition = NaN;
         if(this._layoutAlgorithm == null || this._rendererFactory == null)
         {
            return new Rectangle();
         }
         var _loc3_:Vector.<LayoutEntry> = this._activeEntries.slice();
         for each(_loc4_ in _loc3_)
         {
            this._rendererFactory.returnEntry(_loc4_);
         }
         this._activeEntries.length = 0;
         _loc5_ = !isNaN(this._bottomPosition);
         _loc6_ = Number(_loc5_ ? this._bottomPosition : this._position || 0);
         _loc6_ = Number(clamp(_loc6_,0,this._dataProvider.getLength() - 1));
         var _loc7_:uint = _loc5_ ? uint(Math.ceil(_loc6_)) : uint(Math.floor(_loc6_));
         var _loc8_:Vector.<Rectangle> = this.renderItems(_loc7_,_loc6_,_loc5_,param1,param2,null);
         if(_loc8_.length > 0)
         {
            _loc9_ = _loc5_ ? _loc8_[_loc8_.length - 1] : _loc8_[0];
         }
         else
         {
            _loc9_ = null;
         }
         var _loc10_:Number = _loc5_ ? _loc7_ + 1 : _loc7_ - 1;
         var _loc11_:Vector.<Rectangle> = this.renderItems(_loc10_,_loc6_,!_loc5_,param1,param2,_loc9_);
         var _loc12_:uint = _loc5_ ? uint(_loc7_ - _loc8_.length) : uint(_loc7_ - _loc11_.length);
         if(_loc5_)
         {
            _loc13_ = _loc11_.concat(_loc8_);
         }
         else
         {
            _loc13_ = _loc8_.concat(_loc11_);
         }
         this._measuredBounds = this._layoutAlgorithm.calculateMeasuredBounds(_loc13_,_loc5_,_loc12_);
         for each(_loc14_ in _loc3_)
         {
            if(this._activeEntries.indexOf(_loc14_) == -1)
            {
               this.deactivateEntry(_loc14_);
            }
         }
         _loc15_ = new Rectangle(0,0,isNaN(param1) ? this._measuredBounds.width : param1,isNaN(param2) ? this._measuredBounds.height : param2);
         setScrollRect(_loc15_);
         this.hitArea.setExplicitSize(_loc15_.width,_loc15_.height);
         return _loc15_;
      }
      
      protected function renderItems(param1:uint, param2:Number, param3:Boolean, param4:Number, param5:Number, param6:Rectangle) : Vector.<Rectangle>
      {
         var _loc11_:* = undefined;
         var _loc12_:LayoutEntry = null;
         var _loc13_:IItemRenderer = null;
         var _loc7_:Vector.<Rectangle> = new Vector.<Rectangle>();
         var _loc8_:uint = uint(this._dataProvider.getLength());
         var _loc9_:uint = 0;
         var _loc10_:uint = param1;
         while(param1 >= 0 && param1 < _loc8_ && _loc9_ < this.maxSkipped)
         {
            _loc11_ = this._dataProvider.getItemAt(param1);
            _loc12_ = this._rendererFactory.createEntry(_loc11_);
            if(!(_loc12_.element is IItemRenderer))
            {
               throw new Error("Renderer must be of type " + getQualifiedClassName(IItemRenderer) + ".");
            }
            _loc13_ = _loc12_.element as IItemRenderer;
            if(param1 != _loc13_.getIndex())
            {
               _loc13_.setIndex(param1);
            }
            this.activateEntry(_loc12_);
            if(param3)
            {
               this._activeEntries.unshift(_loc12_);
            }
            else
            {
               this._activeEntries.push(_loc12_);
            }
            if(_loc13_.getIncludeInLayout())
            {
               param6 = this._layoutAlgorithm.updateLayoutEntry(param4,param5,_loc12_,_loc10_,param2,_loc8_ - 1,param6,param3);
               if(!this._layoutAlgorithm.getShouldShowRenderer(param6,param4,param5,param3))
               {
                  break;
               }
               _loc9_ = 0;
               if(param3)
               {
                  _loc7_.unshift(param6);
               }
               else
               {
                  _loc7_[_loc7_.length] = param6;
               }
               if(param3)
               {
                  _loc10_--;
               }
               else
               {
                  _loc10_++;
               }
            }
            else
            {
               _loc9_++;
               _loc13_.validate();
            }
            if(param3)
            {
               param1--;
            }
            else
            {
               param1++;
            }
         }
         return _loc7_;
      }
      
      protected function activateEntry(param1:LayoutEntry) : void
      {
         var _loc2_:IItemRenderer = param1.element as IItemRenderer;
         if(_loc2_.getParentDisplayContainer() != this)
         {
            if(param1.data != null)
            {
               param1.data.getLayoutDataChanged().add(this.rendererInvalidatedHandler);
            }
            param1.element.getLayoutInvalidated().add(this.rendererInvalidatedHandler);
            addChild(_loc2_);
         }
      }
      
      protected function deactivateEntry(param1:LayoutEntry) : void
      {
         var _loc2_:IItemRenderer = param1.element as IItemRenderer;
         if(_loc2_.getParentDisplayContainer() == this)
         {
            _loc2_.getLayoutInvalidated().remove(this.rendererInvalidatedHandler);
            if(param1.data != null)
            {
               param1.data.getLayoutDataChanged().remove(this.rendererInvalidatedHandler);
            }
            removeChild(_loc2_);
         }
      }
      
      protected function rendererInvalidatedHandler(param1:ILayoutElement) : void
      {
         invalidateLayout();
      }
      
      override public function destroy() : void
      {
         this.setRendererFactory(null);
         this.setLayoutAlgorithm(null);
         removeAllChildren();
         this.hitArea.destroy();
         super.destroy();
      }
   }
}

