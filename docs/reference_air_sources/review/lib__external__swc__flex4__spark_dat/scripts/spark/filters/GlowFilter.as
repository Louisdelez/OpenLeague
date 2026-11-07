package spark.filters
{
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   import mx.filters.BaseDimensionFilter;
   import mx.filters.IBitmapFilter;
   
   public class GlowFilter extends BaseDimensionFilter implements IBitmapFilter
   {
      
      private var _alpha:Number = 1;
      
      private var _color:uint = 16711680;
      
      private var _inner:Boolean = false;
      
      public function GlowFilter(color:uint = 16711680, alpha:Number = 1, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:int = 1, inner:Boolean = false, knockout:Boolean = false)
      {
         super();
         this.color = color;
         this.alpha = alpha;
         this.blurX = blurX;
         this.blurY = blurY;
         this.strength = strength;
         this.quality = quality;
         this.inner = inner;
         this.knockout = knockout;
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
         return new flash.filters.GlowFilter(this.color,this.alpha,blurX,blurY,strength,quality,this.inner,knockout);
      }
   }
}

