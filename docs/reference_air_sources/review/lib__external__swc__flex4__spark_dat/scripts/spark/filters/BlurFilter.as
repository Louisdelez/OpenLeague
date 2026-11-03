package spark.filters
{
   import flash.filters.BitmapFilter;
   import flash.filters.BlurFilter;
   import mx.filters.BaseFilter;
   import mx.filters.IBitmapFilter;
   
   public class BlurFilter extends BaseFilter implements IBitmapFilter
   {
      
      private var _blurX:Number = 4;
      
      private var _blurY:Number = 4;
      
      private var _quality:int = 1;
      
      public function BlurFilter(blurX:Number = 4, blurY:Number = 4, quality:int = 1)
      {
         super();
         this.blurX = blurX;
         this.blurY = blurY;
         this.quality = quality;
      }
      
      [Inspectable(minValue="0.0",maxValue="255.0")]
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function set blurX(value:Number) : void
      {
         if(value != this._blurX)
         {
            this._blurX = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(minValue="0.0",maxValue="255.0")]
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function set blurY(value:Number) : void
      {
         if(value != this._blurY)
         {
            this._blurY = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(minValue="1",maxValue="15")]
      public function get quality() : int
      {
         return this._quality;
      }
      
      public function set quality(value:int) : void
      {
         if(value != this._quality)
         {
            this._quality = value;
            notifyFilterChanged();
         }
      }
      
      public function clone() : BitmapFilter
      {
         return new flash.filters.BlurFilter(this.blurX,this.blurY,this.quality);
      }
   }
}

