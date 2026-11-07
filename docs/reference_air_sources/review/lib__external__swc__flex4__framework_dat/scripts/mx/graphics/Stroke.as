package mx.graphics
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Deprecated(replacement="SolidColorStroke",since="4.0")]
   public class Stroke extends SolidColorStroke
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function Stroke(color:uint = 0, weight:Number = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 1)
      {
         super(color,weight,alpha,pixelHinting,scaleMode,caps,joints,miterLimit);
      }
   }
}

