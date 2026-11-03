package spark.filters
{
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   import mx.filters.BaseDimensionFilter;
   import mx.filters.IBitmapFilter;
   
   public class DropShadowFilter extends BaseDimensionFilter implements IBitmapFilter
   {
      
      private var _alpha:Number = 1;
      
      private var _angle:Number = 45;
      
      private var _color:uint = 0;
      
      private var _distance:Number = 4;
      
      private var _hideObject:Boolean = false;
      
      private var _inner:Boolean = false;
      
      public function DropShadowFilter(distance:Number = 4, angle:Number = 45, color:uint = 0, alpha:Number = 1, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false)
      {
         super();
         this.distance = distance;
         this.angle = angle;
         this.color = color;
         this.alpha = alpha;
         this.blurX = blurX;
         this.blurY = blurY;
         this.strength = strength;
         this.quality = quality;
         this.inner = inner;
         this.knockout = knockout;
         this.hideObject = hideObject;
      }
      
      [Inspectable(minValue="0.0",maxValue="1.0")]
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(value:Number) : void
      {
         if(value != this._alpha)
         {
            this._alpha = value;
            notifyFilterChanged();
         }
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set angle(value:Number) : void
      {
         if(value != this._angle)
         {
            this._angle = value;
            notifyFilterChanged();
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(value:uint) : void
      {
         if(value != this._color)
         {
            this._color = value;
            notifyFilterChanged();
         }
      }
      
      public function get distance() : Number
      {
         return this._distance;
      }
      
      public function set distance(value:Number) : void
      {
         if(value != this._distance)
         {
            this._distance = value;
            notifyFilterChanged();
         }
      }
      
      public function get hideObject() : Boolean
      {
         return this._hideObject;
      }
      
      public function set hideObject(value:Boolean) : void
      {
         if(value != this._hideObject)
         {
            this._hideObject = value;
            notifyFilterChanged();
         }
      }
      
      public function get inner() : Boolean
      {
         return this._inner;
      }
      
      public function set inner(value:Boolean) : void
      {
         if(value != this._inner)
         {
            this._inner = value;
            notifyFilterChanged();
         }
      }
      
      public function clone() : BitmapFilter
      {
         return new flash.filters.DropShadowFilter(this.distance,this.angle,this.color,this.alpha,blurX,blurY,strength,quality,this.inner,knockout,this.hideObject);
      }
   }
}

