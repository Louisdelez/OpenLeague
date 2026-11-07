package spark.events
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   
   public class ElementExistenceEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const ELEMENT_ADD:String = "elementAdd";
      
      public static const ELEMENT_REMOVE:String = "elementRemove";
      
      public var index:int;
      
      public var element:IVisualElement;
      
      public function ElementExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, element:IVisualElement = null, index:int = -1)
      {
         super(type,bubbles,cancelable);
         this.element = element;
         this.index = index;
      }
      
      override public function clone() : Event
      {
         return new ElementExistenceEvent(type,bubbles,cancelable,this.element,this.index);
      }
   }
}

