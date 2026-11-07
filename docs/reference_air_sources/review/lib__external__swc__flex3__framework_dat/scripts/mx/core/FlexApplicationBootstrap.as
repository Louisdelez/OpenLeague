package mx.core
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class FlexApplicationBootstrap extends FlexModuleFactory
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function FlexApplicationBootstrap()
      {
         addEventListener("ready",readyHandler);
         super();
      }
      
      public function readyHandler(event:Event) : void
      {
         removeEventListener("ready",readyHandler);
         var o:Object = create();
         if(o is DisplayObject)
         {
            addChild(DisplayObject(o));
            o.dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
         }
      }
   }
}

