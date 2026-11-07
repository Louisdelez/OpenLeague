package com.riotgames.pvpnet.contextualeducation.services
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.util.json.*;
   import flash.utils.Dictionary;
   
   public class ContextualEducationLocalService implements IContextualEducationService
   {
      
      private var _preferencesManager:UserPreferencesManager;
      
      public function ContextualEducationLocalService()
      {
         super();
         this._preferencesManager = UserPreferencesManager.instance;
      }
      
      public static function stringifyRecords(param1:Dictionary) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         for(_loc3_ in param1)
         {
            _loc4_ = ContextualEducationTipRecord.convertToJson(param1[_loc3_] as ContextualEducationTipRecord);
            if(_loc4_ !== null)
            {
               _loc2_.push(_loc4_);
            }
         }
         return "[" + _loc2_.join() + "]";
      }
      
      public function saveRecords(param1:Dictionary) : void
      {
         var _loc2_:UserPrefs = UserPreferencesManager.userPrefs;
         _loc2_.contextualEducationTipRecords = stringifyRecords(param1);
         this._preferencesManager.saveUserPreferences(Session.instance.summoner.name);
      }
      
      private function getRecordsFromString(param1:String) : Dictionary
      {
         var recordsArr:Array = null;
         var recordObject:Object = null;
         var record:ContextualEducationTipRecord = null;
         var records:String = param1;
         var recordsDictionary:Dictionary = new Dictionary(true);
         try
         {
            recordsArr = jsonDecode(records) as Array;
            for each(recordObject in recordsArr)
            {
               record = ContextualEducationTipRecord.fromJsonObject(recordObject);
               if(record !== null)
               {
                  recordsDictionary[record.id] = record;
               }
            }
         }
         catch(e:Error)
         {
         }
         return recordsDictionary;
      }
      
      public function getRecords() : Dictionary
      {
         var _loc1_:UserPrefs = null;
         var _loc2_:String = null;
         if(this._preferencesManager.hasLoadedUserPreferences)
         {
            _loc1_ = UserPreferencesManager.userPrefs;
            _loc2_ = _loc1_.contextualEducationTipRecords;
            return this.getRecordsFromString(_loc2_);
         }
         return new Dictionary(true);
      }
   }
}

