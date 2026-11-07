package com.riotgames.pvpnet.system.config.cdc.testing
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.pvpnet.system.config.cdc.*;
   import com.riotgames.util.json.jsonDecode;
   import de.polygonal.math.PRNG;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class SplitTestingConfigController
   {
      
      private var _namespace:String;
      
      private var _nsObject:Object;
      
      protected var _keyToJSONEntry:Dictionary;
      
      protected var _cdcKeyValues:Dictionary;
      
      private var _prng:PRNG;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function SplitTestingConfigController(param1:String)
      {
         super();
         this._namespace = param1;
         this._prng = new PRNG();
         this._keyToJSONEntry = new Dictionary();
         this._cdcKeyValues = new Dictionary();
      }
      
      protected function init() : void
      {
         var _loc1_:ConfigurationModel = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:SplitTestingConfigEntry = null;
         this._nsObject = DynamicClientConfigManager.getNamespace(this._namespace);
         if(this._nsObject == null)
         {
            return;
         }
         for each(_loc1_ in this._nsObject)
         {
            _loc2_ = _loc1_.getValue() as String;
            _loc3_ = _loc1_.getKey().toLowerCase();
            if(_loc2_ == null)
            {
               return;
            }
            try
            {
               _loc4_ = SplitTestingConfigEntry.createEntryFromObject(_loc3_,jsonDecode(_loc2_));
            }
            catch(error:SyntaxError)
            {
            }
            if(_loc4_ != null)
            {
               this._keyToJSONEntry[_loc3_] = _loc4_;
            }
            else
            {
               this._cdcKeyValues[_loc3_] = _loc1_.getValue();
            }
         }
      }
      
      protected function getSettingByKey(param1:String, param2:*) : *
      {
         var _loc4_:* = undefined;
         var _loc3_:SplitTestingConfigEntry = this._keyToJSONEntry[param1.toLowerCase()];
         if(_loc3_ != null)
         {
            _loc4_ = this.getSettingByEntry(_loc3_);
         }
         else
         {
            _loc4_ = this._cdcKeyValues[param1];
         }
         if(_loc4_ == null)
         {
            _loc4_ = param2;
         }
         return _loc4_;
      }
      
      protected function getSettingByEntry(param1:SplitTestingConfigEntry) : *
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1.getType() == SplitTestingConfigEntry.SET_BY_CLIENT_PRNG)
         {
            return this.getRandomSetting(param1);
         }
         throw new Error("Misconfigured JSONConfigurationEntry: " + param1.getName());
      }
      
      private function getRandomSetting(param1:SplitTestingConfigEntry) : *
      {
         var _loc5_:SplitTestingOption = null;
         var _loc6_:Object = null;
         var _loc2_:uint = uint(Session.instance.accountSummary.accountId);
         this._prng.seed = _loc2_ * param1.getSettingId() % 1299841;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         for each(_loc5_ in param1.getOptions())
         {
            _loc3_.push(_loc5_.getWeight());
            _loc4_.push(_loc5_.getValue());
         }
         return _loc4_[this.randomIndexByWeights(_loc3_)];
      }
      
      protected function randomIndexByWeights(param1:Array) : int
      {
         var _loc2_:Number = this._prng.nextDouble() * 100;
         var _loc3_:int = 0;
         var _loc4_:int = param1.length - 1;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ += param1[_loc5_] * 100;
            if(_loc2_ < _loc3_)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
   }
}

