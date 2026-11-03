package mx.graphics
{
   import flash.display.Graphics;
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   public class Stroke extends EventDispatcher implements IStroke
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _caps:String = null;
      
      private var _scaleMode:String = "normal";
      
      private var _joints:String = null;
      
      private var _weight:Number;
      
      private var _miterLimit:Number = 0;
      
      private var _alpha:Number = 0;
      
      private var _color:uint = 0;
      
      private var _pixelHinting:Boolean = false;
      
      public function Stroke(color:uint = 0, weight:Number = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 0)
      {
         super();
         this.color = color;
         this._weight = weight;
         this.alpha = alpha;
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
            dispatchStrokeChangedEvent("caps",oldValue,value);
         }
      }
      
      public function set color(value:uint) : void
      {
         var oldValue:uint = _color;
         if(value != oldValue)
         {
            _color = value;
            dispatchStrokeChangedEvent("color",oldValue,value);
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
            dispatchStrokeChangedEvent("joints",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get pixelHinting() : Boolean
      {
         return _pixelHinting;
      }
      
      public function set scaleMode(value:String) : void
      {
         var oldValue:String = _scaleMode;
         if(value != oldValue)
         {
            _scaleMode = value;
            dispatchStrokeChangedEvent("scaleMode",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      [Inspectable(category="General",enumeration="round,square,none",defaultValue="round")]
      [Bindable("propertyChange")]
      public function get caps() : String
      {
         return _caps;
      }
      
      [Inspectable(category="General",format="Color")]
      [Bindable("propertyChange")]
      public function get color() : uint
      {
         return _color;
      }
      
      private function dispatchStrokeChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
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
            dispatchStrokeChangedEvent("miterLimit",oldValue,value);
         }
      }
      
      public function set weight(value:Number) : void
      {
         var oldValue:Number = _weight;
         if(value != oldValue)
         {
            _weight = value;
            dispatchStrokeChangedEvent("weight",oldValue,value);
         }
      }
      
      public function set pixelHinting(value:Boolean) : void
      {
         var oldValue:Boolean = _pixelHinting;
         if(value != oldValue)
         {
            _pixelHinting = value;
            dispatchStrokeChangedEvent("pixelHinting",oldValue,value);
         }
      }
      
      public function apply(g:Graphics) : void
      {
         g.lineStyle(weight,color,alpha,pixelHinting,scaleMode,caps,joints,miterLimit);
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
      
      public function set alpha(value:Number) : void
      {
         var oldValue:Number = _alpha;
         if(value != oldValue)
         {
            _alpha = value;
            dispatchStrokeChangedEvent("alpha",oldValue,value);
         }
      }
   }
}

