class DDW.Components.Cursor extends DDW.Components.DisplayObjectContainer
{
   var addChild;
   var addEventListener;
   var children;
   var cursorMc;
   var graphics;
   var removeEventListener;
   function Cursor()
   {
      super("",null);
   }
   function addedToStage(event)
   {
      super.addedToStage();
      var _loc4_ = !DDW.Managers.GameManager.getInstance().isGfx ? "cursor" : "emptyMc";
      this.cursorMc = new DDW.Components.DisplayObject(_loc4_,null);
      this.addChild(this.cursorMc);
      this.cursorMc.graphics.enabled = false;
   }
   function removedFromStage(event)
   {
      super.removedFromStage();
      this.removeEventListener(DDW.Events.MouseEvent.MOUSE_MOVE,this.onCursorMove);
      this.graphics = null;
   }
   function addTo(parent)
   {
      super.addTo(parent);
      this.graphics.startDrag(true);
      if(DDW.Managers.GameManager.getInstance().isGfx)
      {
      }
      this.addEventListener(DDW.Events.MouseEvent.MOUSE_MOVE,this,this.onCursorMove);
   }
   function toString()
   {
      return "cursor: " + this.children;
   }
   function onCursorMove(parent)
   {
      _global.updateAfterEvent();
   }
}
