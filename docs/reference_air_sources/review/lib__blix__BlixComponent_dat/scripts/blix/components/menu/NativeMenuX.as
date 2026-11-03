package blix.components.menu
{
   import blix.IDestructible;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   
   public class NativeMenuX extends NativeMenu implements IDestructible
   {
      
      public function NativeMenuX()
      {
         super();
      }
      
      public function destroy() : void
      {
         var _loc1_:NativeMenuItem = null;
         for each(_loc1_ in items)
         {
            if(_loc1_ is IDestructible)
            {
               (_loc1_ as IDestructible).destroy();
            }
         }
      }
   }
}

