package mx.events
{
   import flash.events.Event;
   
   public class ColorPickerEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGE:String = "change";
      
      public static const ENTER:String = "enter";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public var color:uint;
      
      public var index:int;
      
      public function ColorPickerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = -1, color:uint = 4294967295)
      {
         super(type,bubbles,cancelable);
         this.index = index;
         this.color = color;
      }
      
      override public function clone() : Event
      {
         return new ColorPickerEvent(type,bubbles,cancelable,this.index,this.color);
      }
   }
}

