package com.riotgames.platform.module
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.utils.Dictionary;
   
   public class RiotModuleManager
   {
      
      private static var _moduleCompleted:Signal = new Signal();
      
      private static var _moduleErred:Signal = new Signal();
      
      private static var modules:Vector.<RiotModuleInfo> = new Vector.<RiotModuleInfo>();
      
      public function RiotModuleManager()
      {
         super();
      }
      
      public static function addModuleInfo(param1:RiotModuleInfo) : void
      {
         modules[modules.length] = param1;
         param1.getCompleted().add(_moduleCompleted.dispatch,true);
         param1.getErred().add(_moduleErred.dispatch,true);
      }
      
      public static function getModuleCompleted() : ISignal
      {
         return _moduleCompleted;
      }
      
      public static function getModuleErred() : ISignal
      {
         return _moduleErred;
      }
      
      public static function getModuleInfoByUrl(param1:String) : RiotModuleInfo
      {
         var _loc2_:RiotModuleInfo = null;
         for each(_loc2_ in modules)
         {
            if(_loc2_.getUrl() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getModulesWithKey(param1:String) : Vector.<RiotModuleInfo>
      {
         var _loc3_:RiotModuleInfo = null;
         var _loc4_:Dictionary = null;
         var _loc2_:Vector.<RiotModuleInfo> = new Vector.<RiotModuleInfo>();
         for each(_loc3_ in modules)
         {
            _loc4_ = _loc3_.getExtraData();
            if(_loc4_ != null && _loc4_.hasOwnProperty(param1))
            {
               _loc2_[_loc2_.length] = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public static function getModulesWithKeyValue(param1:String, param2:*) : Vector.<RiotModuleInfo>
      {
         var _loc4_:RiotModuleInfo = null;
         var _loc5_:Dictionary = null;
         var _loc3_:Vector.<RiotModuleInfo> = new Vector.<RiotModuleInfo>();
         for each(_loc4_ in modules)
         {
            _loc5_ = _loc4_.getExtraData();
            if(_loc5_ != null && _loc5_.hasOwnProperty(param1) && _loc5_[param1] == param2)
            {
               _loc3_[_loc3_.length] = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public static function getModuleByCriteria(param1:Function) : RiotModuleInfo
      {
         var _loc2_:RiotModuleInfo = null;
         for each(_loc2_ in modules)
         {
            if(Boolean(param1(_loc2_)))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getModulesByCriteria(param1:Function) : Vector.<RiotModuleInfo>
      {
         return modules.filter(param1);
      }
      
      public static function getAllModules() : Vector.<RiotModuleInfo>
      {
         return modules.slice();
      }
   }
}

