package com.riotgames.pvpnet.system.config.cdc.testing
{
   public class SplitTestingConfigEntry
   {
      
      public static const SET_BY_CLIENT_PRNG:String = "setByClientPRNG";
      
      private var _name:String;
      
      private var _type:String;
      
      private var _settingId:uint;
      
      private var _options:Vector.<SplitTestingOption>;
      
      private var _value:Object;
      
      public function SplitTestingConfigEntry(param1:String, param2:String, param3:uint, param4:Object, param5:Vector.<SplitTestingOption>)
      {
         super();
         this._name = param1;
         this._type = param2;
         this._settingId = param3;
         this._value = param4;
         this._options = param5;
      }
      
      public static function createEntryFromObject(param1:String, param2:Object) : SplitTestingConfigEntry
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:Vector.<SplitTestingOption> = null;
         var _loc7_:Object = null;
         if(param2.hasOwnProperty("type"))
         {
            _loc3_ = param2.type;
            if(param2.hasOwnProperty("settingId"))
            {
               _loc4_ = uint(param2.settingId);
            }
            if(param2.hasOwnProperty("value"))
            {
               _loc5_ = param2.value;
            }
            if(param2.hasOwnProperty("options"))
            {
               _loc6_ = new Vector.<SplitTestingOption>();
               for each(_loc7_ in param2.options)
               {
                  _loc6_.push(new SplitTestingOption(_loc7_.value,_loc7_.weight));
               }
            }
            return new SplitTestingConfigEntry(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         }
         return null;
      }
      
      public function getValue() : Object
      {
         return this._value;
      }
      
      public function getOptions() : Vector.<SplitTestingOption>
      {
         return this._options;
      }
      
      public function getType() : String
      {
         return this._type;
      }
      
      public function getSettingId() : uint
      {
         return this._settingId;
      }
      
      public function getName() : String
      {
         return this._name;
      }
   }
}

