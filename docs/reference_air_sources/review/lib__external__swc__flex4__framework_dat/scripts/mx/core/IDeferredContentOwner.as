package mx.core
{
   [Event(name="contentCreationComplete",type="mx.events.FlexEvent")]
   public interface IDeferredContentOwner extends IUIComponent
   {
      
      [Inspectable(enumeration="auto, all, none",defaultValue="auto")]
      function get creationPolicy() : String;
      
      function set creationPolicy(param1:String) : void;
      
      function createDeferredContent() : void;
      
      function get deferredContentCreated() : Boolean;
   }
}

