package cmodule.cson
{
   import flash.display.Stage;
   import flash.events.MouseEvent;
   
   function vgl_mouse_buttons() : int
   {
      var stage:Stage = null;
      if(cmodule.cson.vglMouseFirst)
      {
         stage = cmodule.cson.gsprite.stage;
         stage.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):*
         {
            cmodule.cson.vglMouseButtons = 1;
         });
         stage.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):*
         {
            cmodule.cson.vglMouseButtons = 0;
         });
         cmodule.cson.vglMouseFirst = false;
      }
      return cmodule.cson.vglMouseButtons;
   }
}

