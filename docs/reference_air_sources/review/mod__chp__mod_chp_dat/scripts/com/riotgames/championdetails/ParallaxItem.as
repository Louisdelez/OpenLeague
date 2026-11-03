package com.riotgames.championdetails
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.util.layout.MatrixUtils;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class ParallaxItem
   {
      
      public var originalPosition:Point;
      
      public var targetCoordSpace:DisplayObjectProxy;
      
      private var _depth:Number = 1;
      
      private var _offset:Point = new Point();
      
      private var isUpdating:Boolean;
      
      private var target:DisplayObjectProxy;
      
      public function ParallaxItem(param1:DisplayObjectProxy)
      {
         super();
         this.target = param1;
         param1.getActualPositionChanged().add(this.update);
         param1.getUnscaledBoundsChanged().add(this.update);
      }
      
      public function getDepth() : Number
      {
         return this._depth;
      }
      
      public function setDepth(param1:Number) : void
      {
         if(this._depth == param1)
         {
            return;
         }
         this._depth = param1;
      }
      
      public function shift(param1:Point) : void
      {
         this._offset = param1;
         this.update();
      }
      
      protected function update() : void
      {
         if(this.targetCoordSpace == null)
         {
            return;
         }
         var _loc1_:DisplayObject = this.targetCoordSpace.getAsset();
         if(_loc1_ == null || this.target.getAsset() == null || !this.target.getAsset().stage)
         {
            return;
         }
         this.isUpdating = true;
         var _loc2_:DisplayObject = this.target.getAsset();
         if(this.originalPosition == null)
         {
            this.originalPosition = new Point(_loc2_.x,_loc2_.y);
         }
         var _loc3_:Matrix = MatrixUtils.createConversionMatrix(_loc1_,_loc2_);
         _loc3_.tx = 0;
         _loc3_.ty = 0;
         var _loc4_:Point = _loc3_.transformPoint(new Point(this._offset.x * (this._depth - 1),this._offset.y * (this._depth - 1)));
         _loc2_.x = this.originalPosition.x + _loc4_.x;
         _loc2_.y = this.originalPosition.y + _loc4_.y;
         this.isUpdating = false;
      }
   }
}

