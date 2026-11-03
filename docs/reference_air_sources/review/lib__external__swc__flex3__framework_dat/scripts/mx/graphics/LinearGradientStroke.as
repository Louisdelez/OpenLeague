package mx.graphics
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class LinearGradientStroke extends GradientBase implements IStroke
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _caps:String = null;
      
      private var _joints:String = null;
      
      private var _scaleMode:String = "normal";
      
      private var _miterLimit:Number = 0;
      
      private var _weight:Number;
      
      private var _rotation:Number = 0;
      
      private var _spreadMethod:String = "pad";
      
      private var _interpolationMethod:String = "rgb";
      
      private var _pixelHinting:Boolean = false;
      
      public function LinearGradientStroke(weight:Number = 0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 0)
      {
         super();
         this.weight = weight;
         this.pixelHinting = pixelHinting;
         this.scaleMode = scaleMode;
         this.caps = caps;
         this.joints = joints;
         this.miterLimit = miterLimit;
      }
      
      public function set caps(value:String) : void
      {
         var oldValue:String = _caps;
         if(value != oldValue)
         {
            _caps = value;
            mx_internal::dispatchGradientChangedEvent("caps",oldValue,value);
         }
      }
      
      public function set interpolationMethod(value:String) : void
      {
         var oldValue:String = _interpolationMethod;
         if(value != oldValue)
         {
            _interpolationMethod = value;
            mx_internal::dispatchGradientChangedEvent("interpolationMethod",oldValue,value);
         }
      }
      
      [Inspectable(category="General",enumeration="normal,vertical,horizontal,none",defaultValue="normal")]
      [Bindable("propertyChange")]
      public function get scaleMode() : String
      {
         return _scaleMode;
      }
      
      public function set joints(value:String) : void
      {
         var oldValue:String = _joints;
         if(value != oldValue)
         {
            _joints = value;
            mx_internal::dispatchGradientChangedEvent("joints",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      public function get angle() : Number
      {
         return _rotation / Math.PI * 180;
      }
      
      public function set scaleMode(value:String) : void
      {
         var oldValue:String = _scaleMode;
         if(value != oldValue)
         {
            _scaleMode = value;
            mx_internal::dispatchGradientChangedEvent("scaleMode",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get pixelHinting() : Boolean
      {
         return _pixelHinting;
      }
      
      [Inspectable(category="General",enumeration="round,square,none",defaultValue="round")]
      [Bindable("propertyChange")]
      public function get caps() : String
      {
         return _caps;
      }
      
      [Inspectable(category="General",enumeration="rgb,linearRGB",defaultValue="rgb")]
      public function get interpolationMethod() : String
      {
         return _interpolationMethod;
      }
      
      [Inspectable(category="General",enumeration="round,bevel,miter",defaultValue="round")]
      [Bindable("propertyChange")]
      public function get joints() : String
      {
         return _joints;
      }
      
      public function set miterLimit(value:Number) : void
      {
         var oldValue:Number = _miterLimit;
         if(value != oldValue)
         {
            _miterLimit = value;
            mx_internal::dispatchGradientChangedEvent("miterLimit",oldValue,value);
         }
      }
      
      public function set angle(value:Number) : void
      {
         var oldValue:Number = _rotation;
         _rotation = value / 180 * Math.PI;
         mx_internal::dispatchGradientChangedEvent("angle",oldValue,_rotation);
      }
      
      public function set spreadMethod(value:String) : void
      {
         var oldValue:String = _spreadMethod;
         if(value != oldValue)
         {
            _spreadMethod = value;
            mx_internal::dispatchGradientChangedEvent("spreadMethod",oldValue,value);
         }
      }
      
      public function set weight(value:Number) : void
      {
         var oldValue:Number = _weight;
         if(value != oldValue)
         {
            _weight = value;
            mx_internal::dispatchGradientChangedEvent("weight",oldValue,value);
         }
      }
      
      public function set pixelHinting(value:Boolean) : void
      {
         var oldValue:Boolean = _pixelHinting;
         if(value != oldValue)
         {
            _pixelHinting = value;
            mx_internal::dispatchGradientChangedEvent("pixelHinting",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get miterLimit() : Number
      {
         return _miterLimit;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get weight() : Number
      {
         return _weight;
      }
      
      [Inspectable(category="General",enumeration="pad,reflect,repeat",defaultValue="pad")]
      [Bindable("propertyChange")]
      public function get spreadMethod() : String
      {
         return _spreadMethod;
      }
      
      public function apply(g:Graphics) : void
      {
         g.lineStyle(weight,0,1,pixelHinting,scaleMode,caps,joints,miterLimit);
         g.lineGradientStyle(GradientType.LINEAR,mx_internal::colors,mx_internal::alphas,mx_internal::ratios,null,spreadMethod,interpolationMethod);
      }
   }
}

