package com.riotgames.platform.provider
{
   public class ProviderError extends Error
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _originalError:Error;
      
      public function ProviderError(param1:ProviderModuleInfo, param2:Error)
      {
         super(param2.message,param2.errorID);
         this._moduleInfo = param1;
         this._originalError = param2;
      }
      
      public function getModuleInfo() : ProviderModuleInfo
      {
         return this._moduleInfo;
      }
      
      public function getOriginalError() : Error
      {
         return this._originalError;
      }
   }
}

