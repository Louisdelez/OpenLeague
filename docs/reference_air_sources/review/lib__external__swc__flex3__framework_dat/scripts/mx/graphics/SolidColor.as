package mx.graphics
{
   import flash.display.Graphics;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   [DefaultProperty("color")]
   public class SolidColor extends EventDispatcher implements IFill
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _color:uint = 0;
      
      private var _alpha:Number = 1;
      
      public function SolidColor(color:uint = 0, alpha:Number = 1)
      {
         super();
         this.color = color;
         this.alpha = alpha;
      }
      
      [Inspectable(category="General",format="Color")]
      [Bindable("propertyChange")]
      public function get color() : uint
      {
         return _color;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set color(value:uint) : void
      {
         var oldValue:uint = _color;
         if(value != oldValue)
         {
            _color = value;
            dispatchFillChangedEvent("color",oldValue,value);
         }
      }
      
      private function dispatchFillChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
      }
      
      public function begin(target:Graphics, rc:Rectangle) : void
      {
         target.beginFill(color,alpha);
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
      
      public function set alpha(value:Number) : void
      {
         var oldValue:Number = _alpha;
         if(value != oldValue)
         {
            _alpha = value;
            dispatchFillChangedEvent("alpha",oldValue,value);
         }
      }
   }
}

