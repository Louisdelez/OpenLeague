package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.pvpnet.system.cursor.FlexCursorManagerDelegate;
   import com.riotgames.pvpnet.system.cursor.NativeCursors;
   import flash.utils.getQualifiedClassName;
   import mx.core.Singleton;
   import mx.managers.ICursorManager;
   
   public class InitializeCursorManagerAction extends BasicAction implements IAction
   {
      
      public function InitializeCursorManagerAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         Singleton.registerClass(getQualifiedClassName(ICursorManager),FlexCursorManagerDelegate);
         NativeCursors.initialize();
         complete();
      }
   }
}

