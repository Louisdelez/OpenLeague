package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import flash.display.DisplayObject;
   import mx.core.IToolTip;
   import mx.core.IUIComponent;
   import mx.managers.ISystemManager;
   import mx.managers.ToolTipManager;
   
   public class AdvancedToolTipManager extends ToolTipManager
   {
      
      private static var _currentToolTip:IToolTip;
      
      private static var _toolTipOpen:Boolean = false;
      
      public function AdvancedToolTipManager()
      {
         super();
      }
      
      private static function destroyToolTip(param1:IToolTip) : void
      {
         var _loc2_:ISystemManager = param1.systemManager;
         _loc2_.toolTipChildren.removeChild(DisplayObject(param1));
         _currentToolTip = null;
         _toolTipOpen = false;
      }
      
      public static function destroyCurrentToolTip() : void
      {
         if(Boolean(currentToolTip))
         {
            destroyToolTip(currentToolTip);
         }
      }
      
      public static function createCustomToolTip(param1:Number, param2:Number, param3:IToolTip, param4:IUIComponent = null) : void
      {
         if(!param3 is DisplayObject)
         {
            throw new Error("createCustomTooltip called and tooltip is not a DisplayObject!");
         }
         destroyCurrentToolTip();
         var _loc5_:ISystemManager = Boolean(param4) ? param4.systemManager : ApplicationUtil.application.systemManager;
         _loc5_.toolTipChildren.addChild(param3 as DisplayObject);
         _currentToolTip = param3;
         param3.move(param1,param2);
         _toolTipOpen = true;
      }
      
      public static function get currentToolTip() : IToolTip
      {
         return _currentToolTip;
      }
      
      public static function get toolTipOpen() : Boolean
      {
         return _toolTipOpen;
      }
   }
}

