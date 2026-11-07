package mx.graphics
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RadialGradient extends GradientBase implements IFill
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var matrix:Matrix = new Matrix();
      
      private var _focalPointRatio:Number = 0;
      
      private var _rotation:Number = 0;
      
      public function RadialGradient()
      {
         super();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get focalPointRatio() : Number
      {
         return _focalPointRatio;
      }
      
      public function set angle(value:Number) : void
      {
         var oldValue:Number = _rotation;
         _rotation = value / 180 * Math.PI;
         mx_internal::dispatchGradientChangedEvent("angle",oldValue,_rotation);
      }
      
      public function set focalPointRatio(value:Number) : void
      {
         var oldValue:Number = _focalPointRatio;
         if(value != oldValue)
         {
            _focalPointRatio = value;
            mx_internal::dispatchGradientChangedEvent("focalPointRatio",oldValue,value);
         }
      }
      
      public function begin(target:Graphics, rc:Rectangle) : void
      {
         matrix.createGradientBox(rc.width,rc.height,_rotation,rc.left,rc.top);
         target.beginGradientFill(GradientType.RADIAL,mx_internal::colors,mx_internal::alphas,mx_internal::ratios,matrix,null,null,focalPointRatio);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get angle() : Number
      {
         return _rotation / Math.PI * 180;
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
   }
}

