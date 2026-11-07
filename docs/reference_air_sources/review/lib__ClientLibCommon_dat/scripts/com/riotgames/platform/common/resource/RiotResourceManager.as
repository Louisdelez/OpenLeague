package com.riotgames.platform.common.resource
{
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RiotResourceManager
   {
      
      private static var rm:IResourceManager;
      
      private static var instance:RiotResourceManager;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function RiotResourceManager()
      {
         super();
         rm = ResourceManager.getInstance();
      }
      
      public static function getInstance() : RiotResourceManager
      {
         if(!instance)
         {
            instance = new RiotResourceManager();
         }
         return instance;
      }
      
      public function getResourcesString(param1:String, param2:Array = null, param3:String = null) : String
      {
         var _loc5_:Boolean = false;
         var _loc6_:Error = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc4_:String = rm.getString("resources",param1,param2,param3);
         if(_loc4_ == null)
         {
            _loc5_ = false;
            _loc6_ = new Error();
            _loc7_ = _loc6_.getStackTrace();
            _loc8_ = _loc7_.indexOf("]") + 5;
            _loc7_ = _loc7_.substring(_loc8_,1000);
            if(_loc5_)
            {
               _loc4_ = "MISSING \'" + param1 + "\' could not be found in resource.properties, please add it, it was called from :\r" + _loc7_;
            }
            else
            {
               this.logger.error("RiotResourceManager.GEN-0009 resourceName:\'" + param1 + "\' could not be found in resource.properties, please add it, it was called from :\r" + _loc7_);
               _loc4_ = rm.getString("resources","GEN-0009");
               if(_loc4_ == null)
               {
                  _loc4_ = "GEN-0009, a suitable error message could not be found inside resource.properties";
               }
            }
         }
         return _loc4_;
      }
   }
}

