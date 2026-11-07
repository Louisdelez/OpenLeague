package spark.filters
{
   import flash.filters.BevelFilter;
   import flash.filters.BitmapFilter;
   import mx.filters.BaseDimensionFilter;
   import mx.filters.IBitmapFilter;
   
   public class BevelFilter extends BaseDimensionFilter implements IBitmapFilter
   {
      
      private var _angle:Number = 45;
      
      private var _distance:Number = 4;
      
      private var _highlightAlpha:Number = 1;
      
      private var _highlightColor:uint = 16777215;
      
      private var _shadowAlpha:Number = 1;
      
      private var _shadowColor:uint = 0;
      
      private var _type:String = "inner";
      
      public function BevelFilter(distance:Number = 4, angle:Number = 45, highlightColor:uint = 16777215, highlightAlpha:Number = 1, shadowColor:uint = 0, shadowAlpha:Number = 1, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false)
      {
         super();
         this.distance = distance;
         this.angle = angle;
         this.highlightColor = highlightColor;
         this.highlightAlpha = highlightAlpha;
         this.shadowColor = shadowColor;
         this.shadowAlpha = shadowAlpha;
         this.blurX = blurX;
         this.blurY = blurY;
         this.strength = strength;
         this.quality = quality;
         this.type = type;
         this.knockout = knockout;
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
      
      [Inspectable(minValue="0.0",maxValue="1.0")]
      public function get highlightAlpha() : Number
      {
         return this._highlightAlpha;
      }
      
      public function set highlightAlpha(value:Number) : void
      {
         if(value != this._highlightAlpha)
         {
            this._highlightAlpha = value;
            notifyFilterChanged();
         }
      }
      
      public function get highlightColor() : uint
      {
         return this._highlightColor;
      }
      
      public function set highlightColor(value:uint) : void
      {
         if(value != this._highlightColor)
         {
            this._highlightColor = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(minValue="0.0",maxValue="1.0")]
      public function get shadowAlpha() : Number
      {
         return this._shadowAlpha;
      }
      
      public function set shadowAlpha(value:Number) : void
      {
         if(value != this._shadowAlpha)
         {
            this._shadowAlpha = value;
            notifyFilterChanged();
         }
      }
      
      public function get shadowColor() : uint
      {
         return this._shadowColor;
      }
      
      public function set shadowColor(value:uint) : void
      {
         if(value != this._shadowColor)
         {
            this._shadowColor = value;
            notifyFilterChanged();
         }
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(value:String) : void
      {
         if(value != this._type)
         {
            this._type = value;
            notifyFilterChanged();
         }
      }
      
      public function clone() : BitmapFilter
      {
         return new flash.filters.BevelFilter(this.distance,this.angle,this.highlightColor,this.highlightAlpha,this.shadowColor,this.shadowAlpha,blurX,blurY,strength,quality,this.type,knockout);
      }
   }
}

