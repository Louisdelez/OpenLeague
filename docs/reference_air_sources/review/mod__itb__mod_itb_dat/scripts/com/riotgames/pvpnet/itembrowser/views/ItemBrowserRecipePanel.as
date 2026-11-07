package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.GameItem;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ItemBrowserRecipePanel extends StatefulView
   {
      
      private static const MIN_CHILD_SPACE_NEEDED:int = 57;
      
      private var _recipeTreeDictionary:Dictionary = new Dictionary(true);
      
      private var _recipeTreeSizer:SpriteProxy;
      
      private var _recipeTreeGraphicsContainer:SpriteProxy;
      
      private var _titleText:Text;
      
      private var _model:GameItem;
      
      private var _itemClicked:Signal = new Signal();
      
      private var _itemRightClicked:Signal = new Signal();
      
      public function ItemBrowserRecipePanel(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      public function setModel(param1:GameItem) : void
      {
         if(param1 != this._model)
         {
            this._model = param1;
            if(this._model != null)
            {
               this.createRecipeTreeRenderers();
            }
         }
      }
      
      private function createRecipeTreeRenderers() : void
      {
         var _loc1_:GameItemRenderer = null;
         for each(_loc1_ in this._recipeTreeDictionary)
         {
            this._recipeTreeGraphicsContainer.removeChild(_loc1_);
            _loc1_.destroy();
         }
         this._recipeTreeDictionary = new Dictionary();
         this.createRenderersForItem(this._model,"(root)",0);
      }
      
      private function handleItemRightClicked(param1:GameItem) : void
      {
         this._itemRightClicked.dispatch(param1);
      }
      
      private function createRenderersForItem(param1:GameItem, param2:String, param3:int) : void
      {
         var _loc7_:GameItem = null;
         var _loc4_:GameItemRenderer = new GameItemRenderer(this,"ItemWithPriceRenderer");
         _loc4_.setModel(param1);
         _loc4_.getRightClicked().add(this.handleItemRightClicked);
         _loc4_.getLayoutInvalidated().add(this._recipeTreeGraphicsContainer.invalidateLayout);
         this._recipeTreeGraphicsContainer.addChild(_loc4_);
         var _loc5_:String = param2 + "_" + param3;
         this._recipeTreeDictionary[_loc5_] = _loc4_;
         var _loc6_:int = 0;
         for each(_loc7_ in param1.recipeItems)
         {
            this.createRenderersForItem(_loc7_,_loc5_,_loc6_);
            _loc6_++;
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this._model)
         {
            if(this._recipeTreeGraphicsContainer.getGraphics())
            {
               this._recipeTreeGraphicsContainer.getGraphics().clear();
            }
            this.updateRecipeTreeLayout(this._model,0,0,0,this._recipeTreeSizer.getWidth(),null,"(root)");
         }
         this._recipeTreeGraphicsContainer.setExplicitSize(this._recipeTreeSizer.getWidth(),this._recipeTreeSizer.getHeight());
         this._recipeTreeGraphicsContainer.setExplicitPosition(0,0);
         return super.updateLayout(param1,param2);
      }
      
      public function getModel() : GameItem
      {
         return this._model;
      }
      
      override protected function createChildren() : void
      {
         this._recipeTreeSizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._recipeTreeSizer);
         this._recipeTreeGraphicsContainer = new SpriteProxy(this,new Sprite());
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         _loc1_.setVerticalAlign(VerticalAlign.MIDDLE);
         _loc1_.setScalePercentConstraints(new SizeConstraints(new MinMax(0.5,1),new MinMax(0.5,1)));
         _loc1_.setMaintainAspectRatio(true);
         this._recipeTreeGraphicsContainer.setTransformBehavior(_loc1_);
         addChild(this._recipeTreeGraphicsContainer);
         this._recipeTreeGraphicsContainer.getLayoutInvalidated().add(invalidateLayout);
         this._recipeTreeGraphicsContainer.setFilters([new DropShadowFilter(6,45,0,0.4,8,8)]);
      }
      
      public function getItemRightClick() : ISignal
      {
         return this._itemRightClicked;
      }
      
      public function getItemClicked() : ISignal
      {
         return this._itemClicked;
      }
      
      private function updateRecipeTreeLayout(param1:GameItem, param2:int, param3:int, param4:Number, param5:Number, param6:Point, param7:String) : void
      {
         var _loc17_:GameItem = null;
         var _loc18_:Graphics = null;
         var _loc19_:Number = NaN;
         var _loc8_:String = param7 + "_" + param2;
         var _loc9_:GameItemRenderer = this._recipeTreeDictionary[_loc8_];
         var _loc10_:int = param5 - param4;
         var _loc11_:Point = _loc9_.setExplicitSize(NaN,NaN);
         var _loc12_:Point = new Point(param4 + _loc10_ / 2 - _loc11_.x / 2,param3 * (_loc11_.y + 15));
         _loc9_.setExplicitPosition(_loc12_.x,_loc12_.y);
         var _loc13_:Point = new Point(_loc12_.x + _loc11_.x / 2,_loc12_.y + _loc11_.y / 2);
         if(param6)
         {
            _loc18_ = this._recipeTreeGraphicsContainer.getGraphics();
            if(_loc18_)
            {
               _loc18_.lineStyle(2,6052372);
               _loc18_.moveTo(_loc13_.x,_loc13_.y);
               _loc18_.lineTo(_loc13_.x,_loc13_.y - _loc11_.y / 2 - 10);
               _loc18_.lineTo(param6.x,_loc13_.y - _loc11_.y / 2 - 10);
               _loc18_.lineTo(param6.x,param6.y);
            }
         }
         var _loc14_:int = 0;
         var _loc15_:int = Boolean(param1) && Boolean(param1.recipeItems) ? int(param1.recipeItems.length) : 1;
         var _loc16_:int = _loc10_ / _loc15_;
         if(_loc16_ < MIN_CHILD_SPACE_NEEDED && _loc15_ != 0)
         {
            _loc19_ = (MIN_CHILD_SPACE_NEEDED - _loc16_) / 2;
            _loc16_ = MIN_CHILD_SPACE_NEEDED;
            param4 -= _loc19_ * _loc15_;
         }
         for each(_loc17_ in param1.recipeItems)
         {
            this.updateRecipeTreeLayout(_loc17_,_loc14_,param3 + 1,param4 + _loc16_ * _loc14_,param4 + _loc16_ * _loc14_ + _loc16_,_loc13_,_loc8_);
            _loc14_++;
         }
      }
   }
}

