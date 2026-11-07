package flexlib.scheduling.scheduleClasses.layout
{
   import flash.events.Event;
   
   public class LayoutUpdateEvent extends Event
   {
      
      public static var UPDATE:String = "update";
      
      public var layout:ILayout;
      
      public function LayoutUpdateEvent(layout:ILayout)
      {
         super(LayoutUpdateEvent.UPDATE);
         this.layout = layout;
      }
      
      override public function clone() : Event
      {
         return new LayoutUpdateEvent(layout);
      }
   }
}

