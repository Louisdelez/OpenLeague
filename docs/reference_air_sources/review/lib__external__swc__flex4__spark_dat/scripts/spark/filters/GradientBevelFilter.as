package spark.filters
{
   import flash.filters.BitmapFilter;
   import flash.filters.GradientBevelFilter;
   import mx.filters.IBitmapFilter;
   
   [DefaultProperty("entries")]
   public class GradientBevelFilter extends GradientFilter implements IBitmapFilter
   {
      
      public function GradientBevelFilter(distance:Number = 4, angle:Number = 45, colors:Array = null, alphas:Array = null, ratios:Array = null, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false)
      {
         super(colors,alphas,ratios);
         this.distance = distance;
         this.angle = angle;
         this.blurX = blurX;
         this.blurY = blurY;
         this.strength = strength;
         this.quality = quality;
         this.type = type;
         this.knockout = knockout;
      }
      
      public function clone() : BitmapFilter
      {
         return new flash.filters.GradientBevelFilter(distance,angle,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout);
      }
   }
}

