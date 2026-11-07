class DDW.Managers.MouseManager
{
   static var _mouseButtonDown = 0;
   function MouseManager()
   {
      Mouse.addListener(this);
   }
   static function mouseButtonDown()
   {
      return _mouseButtonDown;
   }
   function onMouseDown(button)
   {
      button = !DDW.Managers.GameManager.getInstance().isGfx ? 1 : button;
      _mouseButtonDown = button;
      if(button == 2 && DDW.Components.DefaultButton.currentHoveringButton != null)
      {
         DDW.Components.DefaultButton.currentHoveringButton.onRightClick.apply(DDW.Components.DefaultButton.currentHoveringButton,null);
      }
   }
   function onMouseUp()
   {
      _mouseButtonDown = 0;
   }
}
