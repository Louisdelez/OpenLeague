package mx.graphics
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   public class GradientEntry extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _color:uint;
      
      private var _ratio:Number;
      
      private var _alpha:Number = 1;
      
      public function GradientEntry(color:uint = 0, ratio:Number = -1, alpha:Number = 1)
      {
         super();
         this.color = color;
         if(ratio >= 0)
         {
            this.ratio = ratio;
         }
         this.alpha = alpha;
      }
      
      [Inspectable(category="General",format="Color")]
      [Bindable("propertyChange")]
      public function get color() : uint
      {
         return _color;
      }
      
      [Inspectable(category="General",defaultValue="1")]
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
            dispatchEntryChangedEvent("color",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get ratio() : Number
      {
         return _ratio;
      }
      
      private function dispatchEntryChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
      }
      
      public function set ratio(value:Number) : void
      {
         var oldValue:Number = _ratio;
         if(value != oldValue)
         {
            _ratio = value;
            dispatchEntryChangedEvent("ratio",oldValue,value);
         }
      }
      
      public function set alpha(value:Number) : void
      {
         var oldValue:Number = _alpha;
         if(value != oldValue)
         {
            _alpha = value;
            dispatchEntryChangedEvent("alpha",oldValue,value);
         }
      }
   }
}

