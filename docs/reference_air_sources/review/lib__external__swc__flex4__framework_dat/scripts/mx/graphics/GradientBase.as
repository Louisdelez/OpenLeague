package mx.graphics
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.geom.CompoundTransform;
   
   use namespace mx_internal;
   
   [DefaultProperty("entries")]
   public class GradientBase extends EventDispatcher
   {
      
      public static const GRADIENT_DIMENSION:Number = 1638.4;
      
      mx_internal var colors:Array = [];
      
      mx_internal var ratios:Array = [];
      
      mx_internal var alphas:Array = [];
      
      mx_internal var _angle:Number;
      
      protected var compoundTransform:CompoundTransform;
      
      private var _entries:Array = [];
      
      private var _interpolationMethod:String = "rgb";
      
      private var _matrix:Matrix;
      
      private var _rotation:Number = 0;
      
      private var _spreadMethod:String = "pad";
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function GradientBase()
      {
         super();
      }
      
      [Deprecated(replacement="rotation")]
      [Inspectable(category="General")]
      public function get angle() : Number
      {
         return this._angle / Math.PI * 180;
      }
      
      public function set angle(value:Number) : void
      {
         var oldValue:Number = this._angle;
         this._angle = value / 180 * Math.PI;
         this.dispatchGradientChangedEvent("angle",oldValue,this._angle);
      }
      
      [Inspectable(category="General",arrayType="mx.graphics.GradientEntry")]
      [Bindable("propertyChange")]
      public function get entries() : Array
      {
         return this._entries;
      }
      
      public function set entries(value:Array) : void
      {
         var oldValue:Array = this._entries;
         this._entries = value;
         this.processEntries();
         this.dispatchGradientChangedEvent("entries",oldValue,value);
      }
      
      [Inspectable(category="General",enumeration="rgb,linearRGB",defaultValue="rgb")]
      public function get interpolationMethod() : String
      {
         return this._interpolationMethod;
      }
      
      public function set interpolationMethod(value:String) : void
      {
         var oldValue:String = this._interpolationMethod;
         if(value != oldValue)
         {
            this._interpolationMethod = value;
            this.dispatchGradientChangedEvent("interpolationMethod",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      public function get matrix() : Matrix
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.matrix : null;
      }
      
      public function set matrix(value:Matrix) : void
      {
         var oldValue:Matrix = this.matrix;
         var oldX:Number = this.x;
         var oldY:Number = this.y;
         var oldRotation:Number = this.rotation;
         if(value == null)
         {
            this.compoundTransform = null;
            this.x = NaN;
            this.y = NaN;
            this.rotation = 0;
         }
         else
         {
            if(this.compoundTransform == null)
            {
               this.compoundTransform = new CompoundTransform();
            }
            this.compoundTransform.matrix = value;
            this.dispatchGradientChangedEvent("x",oldX,this.compoundTransform.x);
            this.dispatchGradientChangedEvent("y",oldY,this.compoundTransform.y);
            this.dispatchGradientChangedEvent("rotation",oldRotation,this.compoundTransform.rotationZ);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get rotation() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.rotationZ : this._rotation;
      }
      
      public function set rotation(value:Number) : void
      {
         var oldValue:Number = NaN;
         if(value != this.rotation)
         {
            oldValue = this.rotation;
            if(Boolean(this.compoundTransform))
            {
               this.compoundTransform.rotationZ = value;
            }
            else
            {
               this._rotation = value;
            }
            this.dispatchGradientChangedEvent("rotation",oldValue,value);
         }
      }
      
      [Inspectable(category="General",enumeration="pad,reflect,repeat",defaultValue="pad")]
      [Bindable("propertyChange")]
      public function get spreadMethod() : String
      {
         return this._spreadMethod;
      }
      
      public function set spreadMethod(value:String) : void
      {
         var oldValue:String = this._spreadMethod;
         if(value != oldValue)
         {
            this._spreadMethod = value;
            this.dispatchGradientChangedEvent("spreadMethod",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get x() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.x : this._x;
      }
      
      public function set x(value:Number) : void
      {
         var oldValue:Number = this.x;
         if(value != oldValue)
         {
            if(Boolean(this.compoundTransform))
            {
               if(!isNaN(value))
               {
                  this.compoundTransform.x = value;
               }
            }
            else
            {
               this._x = value;
            }
            this.dispatchGradientChangedEvent("x",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get y() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.y : this._y;
      }
      
      public function set y(value:Number) : void
      {
         var oldValue:Number = this.y;
         if(value != oldValue)
         {
            if(Boolean(this.compoundTransform))
            {
               if(!isNaN(value))
               {
                  this.compoundTransform.y = value;
               }
            }
            else
            {
               this._y = value;
            }
            this.dispatchGradientChangedEvent("y",oldValue,value);
         }
      }
      
      mx_internal function get rotationInRadians() : Number
      {
         return this.rotation / 180 * Math.PI;
      }
      
      private function processEntries() : void
      {
         var i:int = 0;
         var e:GradientEntry = null;
         var start:int = 0;
         var br:Number = NaN;
         var tr:Number = NaN;
         var j:int = 0;
         this.colors = [];
         this.ratios = [];
         this.alphas = [];
         if(!this._entries || this._entries.length == 0)
         {
            return;
         }
         var ratioConvert:Number = 255;
         var n:int = int(this._entries.length);
         for(i = 0; i < n; i++)
         {
            e = this._entries[i];
            e.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.entry_propertyChangeHandler,false,0,true);
            this.colors.push(e.color);
            this.alphas.push(e.alpha);
            this.ratios.push(e.ratio * ratioConvert);
         }
         if(isNaN(this.ratios[0]))
         {
            this.ratios[0] = 0;
         }
         if(isNaN(this.ratios[n - 1]))
         {
            this.ratios[n - 1] = 255;
         }
         i = 1;
         while(true)
         {
            while(i < n && !isNaN(this.ratios[i]))
            {
               i++;
            }
            if(i == n)
            {
               break;
            }
            start = i - 1;
            while(i < n && isNaN(this.ratios[i]))
            {
               i++;
            }
            br = Number(this.ratios[start]);
            tr = Number(this.ratios[i]);
            for(j = 1; j < i - start; j++)
            {
               this.ratios[j] = br + j * (tr - br) / (i - start);
            }
         }
      }
      
      mx_internal function dispatchGradientChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
      }
      
      private function entry_propertyChangeHandler(event:Event) : void
      {
         this.processEntries();
         this.dispatchGradientChangedEvent("entries",this.entries,this.entries);
      }
   }
}

