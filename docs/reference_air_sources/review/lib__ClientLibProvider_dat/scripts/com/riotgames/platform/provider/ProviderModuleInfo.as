package com.riotgames.platform.provider
{
   import com.riotgames.platform.module.RiotModuleInfo;
   import flash.utils.Dictionary;
   
   public class ProviderModuleInfo extends RiotModuleInfo
   {
      
      private var _name:String;
      
      private var _providerInterfaces:Vector.<String>;
      
      public function ProviderModuleInfo(param1:String, param2:String, param3:Dictionary, param4:Vector.<String>)
      {
         var _loc5_:String = null;
         super(param2,param3);
         this._name = param1;
         this._providerInterfaces = param4;
         for each(_loc5_ in this._providerInterfaces)
         {
            ProviderLookup.instance.getSpecificProviderRequested(_loc5_).add(this.providerRequestedHandler);
         }
      }
      
      private function providerRequestedHandler() : void
      {
         load();
      }
      
      override protected function moduleCompleted() : void
      {
         super.moduleCompleted();
         if(getModuleInstance() is IProviderModule)
         {
            (getModuleInstance() as IProviderModule).initializeModule(this);
         }
      }
      
      override public function setError(param1:Error) : void
      {
         var _loc2_:String = null;
         super.setError(param1);
         for each(_loc2_ in this._providerInterfaces)
         {
            ProviderLookup.instance.failProvider(_loc2_,param1);
         }
      }
      
      override public function toString() : String
      {
         return "[ProviderModuleInfo name=" + this._name + " url=" + getUrl() + "]";
      }
      
      public function getProviderInterfaces() : Vector.<String>
      {
         return this._providerInterfaces;
      }
   }
}

