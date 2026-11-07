package com.riotgames.pvpnet.system.config.actions
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.Event;
   
   public class UserPreferencesLoadedAction extends BasicAction implements IAction
   {
      
      public function UserPreferencesLoadedAction(param1:Boolean = false)
      {
         super(param1);
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:UserPreferencesManager = UserPreferencesManager.instance;
         if(_loc1_.hasLoadedUserPreferences)
         {
            this.completePassThrough();
         }
         else
         {
            _loc1_.addEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.completePassThrough,false,0,true);
         }
      }
      
      private function completePassThrough(param1:Event = null) : *
      {
         UserPreferencesManager.instance.removeEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.completePassThrough);
         complete();
      }
   }
}

