package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ColorPickerEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const CHANGE:String = "change";
      
      public static const ENTER:String = "enter";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public var index:int;
      
      public var color:uint;
      
      public function ColorPickerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = -1, color:uint = 4294967295)
      {
         super(type,bubbles,cancelable);
         this.index = index;
         this.color = color;
      }
      
      override public function clone() : Event
      {
         return new ColorPickerEvent(type,bubbles,cancelable,index,color);
      }
   }
}

