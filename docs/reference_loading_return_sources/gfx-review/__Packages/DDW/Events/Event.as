class DDW.Events.Event
{
   var type;
   static var ADDED_TO_STAGE = "onAddedToStage";
   static var REMOVED_FROM_STAGE = "onRemovedFromStage";
   static var ENTER_FRAME = "onEnterFrame";
   static var RENDER = "onRender";
   var relatedObject = null;
   var caller = null;
   var callback = null;
   function Event(type, relatedObject, caller, callback)
   {
      this.type = type;
      this.relatedObject = relatedObject;
      this.caller = caller;
      this.callback = callback;
   }
   function toString()
   {
      return "event:" + this.type + " caller:" + this.caller + " cb:" + this.callback + " ro:" + this.relatedObject;
   }
}
