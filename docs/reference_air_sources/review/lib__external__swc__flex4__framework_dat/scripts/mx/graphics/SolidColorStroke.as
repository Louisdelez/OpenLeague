package mx.graphics
{
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   public class SolidColorStroke extends EventDispatcher implements IStroke
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _alpha:Number = 0;
      
      private var _caps:String = "round";
      
      private var _color:uint = 0;
      
      private var _joints:String = "round";
      
      private var _miterLimit:Number = 3;
      
      private var _pixelHinting:Boolean = false;
      
      private var _scaleMode:String = "normal";
      
      private var _weight:Number;
      
      public function SolidColorStroke(color:uint = 0, weight:Number = 1, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = "round", joints:String = "round", miterLimit:Number = 3)
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
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(value:Number) : void
      {
         var oldValue:Number = this._alpha;
         if(value != oldValue)
         {
            this._alpha = value;
            this.dispatchStrokeChangedEvent("alpha",oldValue,value);
         }
      }
      
      [Inspectable(category="General",enumeration="round,square,none",defaultValue="round")]
      [Bindable("propertyChange")]
      public function get caps() : String
      {
         return this._caps;
      }
      
      public function set caps(value:String) : void
      {
         var oldValue:String = this._caps;
         if(value != oldValue)
         {
            this._caps = value;
            this.dispatchStrokeChangedEvent("caps",oldValue,value);
         }
      }
      
      [Inspectable(category="General",format="Color")]
      [Bindable("propertyChange")]
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(value:uint) : void
      {
         var oldValue:uint = this._color;
         if(value != oldValue)
         {
            this._color = value;
            this.dispatchStrokeChangedEvent("color",oldValue,value);
         }
      }
      
      [Inspectable(category="General",enumeration="round,bevel,miter",defaultValue="round")]
      [Bindable("propertyChange")]
      public function get joints() : String
      {
         return this._joints;
      }
      
      public function set joints(value:String) : void
      {
         var oldValue:String = this._joints;
         if(value != oldValue)
         {
            this._joints = value;
            this.dispatchStrokeChangedEvent("joints",oldValue,value);
         }
      }
      
      [Inspectable(category="General",minValue="1.0",maxValue="255.0")]
      [Bindable("propertyChange")]
      public function get miterLimit() : Number
      {
         return this._miterLimit;
      }
      
      public function set miterLimit(value:Number) : void
      {
         var oldValue:Number = this._miterLimit;
         if(value != oldValue)
         {
            this._miterLimit = value;
            this.dispatchStrokeChangedEvent("miterLimit",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get pixelHinting() : Boolean
      {
         return this._pixelHinting;
      }
      
      public function set pixelHinting(value:Boolean) : void
      {
         var oldValue:Boolean = this._pixelHinting;
         if(value != oldValue)
         {
            this._pixelHinting = value;
            this.dispatchStrokeChangedEvent("pixelHinting",oldValue,value);
         }
      }
      
      [Inspectable(category="General",enumeration="normal,vertical,horizontal,none",defaultValue="normal")]
      [Bindable("propertyChange")]
      public function get scaleMode() : String
      {
         return this._scaleMode;
      }
      
      public function set scaleMode(value:String) : void
      {
         var oldValue:String = this._scaleMode;
         if(value != oldValue)
         {
            this._scaleMode = value;
            this.dispatchStrokeChangedEvent("scaleMode",oldValue,value);
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get weight() : Number
      {
         return this._weight;
      }
      
      public function set weight(value:Number) : void
      {
         var oldValue:Number = this._weight;
         if(value != oldValue)
         {
            this._weight = value;
            this.dispatchStrokeChangedEvent("weight",oldValue,value);
         }
      }
      
      public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
         graphics.lineStyle(this.weight,this.color,this.alpha,this.pixelHinting,this.scaleMode,this.caps,this.joints,this.miterLimit);
      }
      
      public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point) : GraphicsStroke
      {
         var graphicsStroke:GraphicsStroke = new GraphicsStroke();
         graphicsStroke.thickness = this.weight;
         graphicsStroke.miterLimit = this.miterLimit;
         graphicsStroke.pixelHinting = this.pixelHinting;
         graphicsStroke.scaleMode = this.scaleMode;
         graphicsStroke.caps = !this.caps ? CapsStyle.ROUND : this.caps;
         var graphicsSolidFill:GraphicsSolidFill = new GraphicsSolidFill();
         graphicsSolidFill.color = this.color;
         graphicsSolidFill.alpha = this.alpha;
         graphicsStroke.fill = graphicsSolidFill;
         return graphicsStroke;
      }
      
      private function dispatchStrokeChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         if(hasEventListener("propertyChange"))
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
         }
      }
   }
}

