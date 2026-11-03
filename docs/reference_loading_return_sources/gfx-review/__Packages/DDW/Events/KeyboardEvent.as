class DDW.Events.KeyboardEvent extends DDW.Events.Event
{
   var altKey;
   var charCode;
   var ctrlKey;
   var shiftKey;
   static var KEY_DOWN = "onKeyDown";
   static var KEY_UP = "onKeyUp";
   function KeyboardEvent(type, relatedObject, caller, callback)
   {
      super(type,relatedObject,caller,callback);
      this.charCode = Key.getCode();
      this.ctrlKey = Key.isDown(Key.CONTROL);
      this.altKey = Key.isDown(Key.ALT);
      this.shiftKey = Key.isDown(Key.SHIFT);
   }
}
