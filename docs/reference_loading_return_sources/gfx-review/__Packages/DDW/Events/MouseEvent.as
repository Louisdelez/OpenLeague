class DDW.Events.MouseEvent extends DDW.Events.Event
{
   var button;
   var localX;
   var localY;
   var stageX;
   var stageY;
   var targetPath;
   static var MOUSE_DOWN = "onMouseDown";
   static var MOUSE_UP = "onMouseUp";
   static var MOUSE_MOVE = "onMouseMove";
   static var ROLL_OUT = "onRollOut";
   static var ROLL_OVER = "onRollOver";
   static var DRAG_OUT = "onDragOut";
   static var DRAG_OVER = "onDragOver";
   static var PRESS = "onPress";
   static var RELEASE = "onRelease";
   static var RELEASE_OUTSIDE = "onReleaseOutside";
   var ctrlKey = false;
   var altKey = false;
   var shiftKey = false;
   var buttonDown = false;
   var delta = 1;
   function MouseEvent(type, relatedObject, caller, callback, button, targetPath)
   {
      super(type,relatedObject,caller,callback);
      this.localX = relatedObject.graphics._xmouse;
      this.localY = relatedObject.graphics._ymouse;
      this.stageX = _root._xmouse;
      this.stageY = _root._ymouse;
      this.ctrlKey = Key.isDown(Key.CONTROL);
      this.altKey = Key.isDown(Key.ALT);
      this.shiftKey = Key.isDown(Key.SHIFT);
      this.buttonDown = DDW.Managers.MouseManager.mouseButtonDown() > 0;
      this.button = button;
      this.targetPath = targetPath;
   }
}
