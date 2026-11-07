package mx.graphics
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class LinearGradient extends GradientBase implements IFill
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var matrix:Matrix = new Matrix();
      
      private var _rotation:Number = 0;
      
      public function LinearGradient()
      {
         super();
      }
      
      public function begin(target:Graphics, rc:Rectangle) : void
      {
         matrix.createGradientBox(rc.width,rc.height,_rotation,rc.left,rc.top);
         target.beginGradientFill(GradientType.LINEAR,mx_internal::colors,mx_internal::alphas,mx_internal::ratios,matrix);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get angle() : Number
      {
         return _rotation / Math.PI * 180;
      }
      
      public function set angle(value:Number) : void
      {
         var oldValue:Number = _rotation;
         _rotation = value / 180 * Math.PI;
         mx_internal::dispatchGradientChangedEvent("angle",oldValue,_rotation);
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
   }
}

