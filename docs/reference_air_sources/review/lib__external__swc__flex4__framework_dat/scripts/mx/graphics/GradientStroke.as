package mx.graphics
{
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsGradientFill;
   import flash.display.GraphicsStroke;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class GradientStroke extends GradientBase implements IStroke
   {
      
      private var _caps:String = "round";
      
      private var _joints:String = "round";
      
      private var _miterLimit:Number = 3;
      
      private var _pixelHinting:Boolean = false;
      
      private var _scaleMode:String = "normal";
      
      private var _weight:Number;
      
      public function GradientStroke(weight:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = "round", joints:String = "round", miterLimit:Number = 3)
      {
         super();
         this.weight = weight;
         this.pixelHinting = pixelHinting;
         this.scaleMode = scaleMode;
         this.caps = caps;
         this.joints = joints;
         this.miterLimit = miterLimit;
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
            dispatchGradientChangedEvent("caps",oldValue,value);
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
            dispatchGradientChangedEvent("joints",oldValue,value);
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
            dispatchGradientChangedEvent("miterLimit",oldValue,value);
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
            dispatchGradientChangedEvent("pixelHinting",oldValue,value);
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
            dispatchGradientChangedEvent("scaleMode",oldValue,value);
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
            dispatchGradientChangedEvent("weight",oldValue,value);
         }
      }
      
      public function apply(g:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
      }
      
      public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point) : GraphicsStroke
      {
         var graphicsStroke:GraphicsStroke = new GraphicsStroke();
         graphicsStroke.thickness = this.weight;
         graphicsStroke.miterLimit = this.miterLimit;
         graphicsStroke.pixelHinting = this.pixelHinting;
         graphicsStroke.scaleMode = this.scaleMode;
         graphicsStroke.caps = !this.caps ? CapsStyle.ROUND : this.caps;
         var graphicsGradientFill:GraphicsGradientFill = new GraphicsGradientFill();
         graphicsGradientFill.colors = colors;
         graphicsGradientFill.alphas = alphas;
         graphicsGradientFill.ratios = ratios;
         graphicsGradientFill.spreadMethod = spreadMethod;
         graphicsGradientFill.interpolationMethod = interpolationMethod;
         graphicsStroke.fill = graphicsGradientFill;
         return graphicsStroke;
      }
   }
}

