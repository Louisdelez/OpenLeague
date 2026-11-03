package mx.graphics
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   public class GradientEntry extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _alpha:Number = 1;
      
      private var _color:uint;
      
      private var _ratio:Number;
      
      public function GradientEntry(color:uint = 0, ratio:Number = NaN, alpha:Number = 1)
      {
         super();
         this.color = color;
         this.ratio = ratio;
         this.alpha = alpha;
      }
      
      [Inspectable(category="General",defaultValue="1",minValue="0.0",maxValue="1.0")]
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
            this.dispatchEntryChangedEvent("alpha",oldValue,value);
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
            this.dispatchEntryChangedEvent("color",oldValue,value);
         }
      }
      
      [Inspectable(category="General",minValue="0.0",maxValue="1.0")]
      [Bindable("propertyChange")]
      public function get ratio() : Number
      {
         return this._ratio;
      }
      
      public function set ratio(value:Number) : void
      {
         var oldValue:Number = this._ratio;
         if(value != oldValue)
         {
            this._ratio = value;
            this.dispatchEntryChangedEvent("ratio",oldValue,value);
         }
      }
      
      private function dispatchEntryChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         if(hasEventListener("propertyChange"))
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
         }
      }
   }
}

