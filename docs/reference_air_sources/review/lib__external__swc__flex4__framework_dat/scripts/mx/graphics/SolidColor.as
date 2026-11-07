package mx.graphics
{
   import flash.display.Graphics;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   [DefaultProperty("color")]
   public class SolidColor extends EventDispatcher implements IFill
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _alpha:Number = 1;
      
      private var _color:uint = 0;
      
      public function SolidColor(color:uint = 0, alpha:Number = 1)
      {
         super();
         this.color = color;
         this.alpha = alpha;
      }
      
      [Inspectable(category="General",minValue="0.0",maxValue="1.0")]
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
            this.dispatchFillChangedEvent("alpha",oldValue,value);
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
            this.dispatchFillChangedEvent("color",oldValue,value);
         }
      }
      
      public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
         target.beginFill(this.color,this.alpha);
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
      
      private function dispatchFillChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         if(hasEventListener("propertyChange"))
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
         }
      }
   }
}

