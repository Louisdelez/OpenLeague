package com.riotgames.pvpnet.contextualeducation.services
{
   import com.riotgames.util.json.*;
   
   public class ContextualEducationTipRecord
   {
      
      public var id:String = "";
      
      public var timesAttemptedTip:uint = 0;
      
      public function ContextualEducationTipRecord(param1:String)
      {
         super();
         this.id = param1;
      }
      
      public static function fromJsonObject(param1:Object) : ContextualEducationTipRecord
      {
         var record:ContextualEducationTipRecord = null;
         var key:String = null;
         var jsonObject:Object = param1;
         try
         {
            if(jsonObject.id)
            {
               record = new ContextualEducationTipRecord(jsonObject.id);
               for(key in jsonObject)
               {
                  if(record.hasOwnProperty(key))
                  {
                     record[key] = jsonObject[key];
                  }
               }
            }
            return record;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public static function convertToJson(param1:ContextualEducationTipRecord) : String
      {
         var _loc2_:Object = {};
         _loc2_.id = param1.id;
         _loc2_.timesAttemptedTip = param1.timesAttemptedTip;
         return jsonEncode(_loc2_);
      }
   }
}

