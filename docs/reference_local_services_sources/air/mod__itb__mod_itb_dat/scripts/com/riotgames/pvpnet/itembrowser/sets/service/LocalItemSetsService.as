package com.riotgames.pvpnet.itembrowser.sets.service
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.Event;
   
   public class LocalItemSetsService implements IItemSetsService
   {
      
      private var prefs:UserPrefs;
      
      private var prefsLoaded:Boolean = false;
      
      private var session:Session;
      
      private var callPending:Function = null;
      
      private var preferencesManager:UserPreferencesManager;
      
      public function LocalItemSetsService(param1:UserPreferencesManager, param2:UserPrefs, param3:Session)
      {
         super();
         this.preferencesManager = param1;
         this.prefs = param2;
         this.session = param3;
         if(this.preferencesManager.hasLoadedUserPreferences)
         {
            this.userPrefsLoaded();
         }
         else
         {
            this.preferencesManager.addEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.userPrefsLoaded);
         }
      }
      
      public function saveItemSets(param1:String, param2:Function) : void
      {
         this.prefs.itemSets = param1;
         this.preferencesManager.saveUserPreferences(this.session.summoner.name);
         param2.apply(null);
      }
      
      private function userPrefsLoaded(param1:Event = null) : void
      {
         this.prefsLoaded = true;
         this.prefs = UserPreferencesManager.userPrefs;
         if(this.callPending != null)
         {
            this.getAllMyItemSets(this.callPending);
         }
      }
      
      public function getAllItemSetsForPlayer(param1:Number, param2:Function) : void
      {
         param2.apply(null,["{}"]);
      }
      
      public function getAllMyItemSets(param1:Function) : void
      {
         if(this.prefsLoaded)
         {
            param1.apply(null,[this.prefs.itemSets]);
            this.callPending = null;
         }
         else
         {
            this.callPending = param1;
            param1.apply(null,[""]);
         }
      }
   }
}

