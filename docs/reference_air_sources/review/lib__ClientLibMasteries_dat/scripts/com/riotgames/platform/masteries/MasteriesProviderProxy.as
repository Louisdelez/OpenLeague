package com.riotgames.platform.masteries
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import mx.collections.ArrayCollection;
   
   public class MasteriesProviderProxy extends ProviderProxyBase implements IMasteriesProvider
   {
      
      private static var _instance:MasteriesProviderProxy;
      
      public function MasteriesProviderProxy()
      {
         super(IMasteriesProvider,false);
      }
      
      public static function get instance() : MasteriesProviderProxy
      {
         if(_instance == null)
         {
            _instance = new MasteriesProviderProxy();
         }
         return _instance;
      }
      
      public function showMasteries(param1:Number, param2:DisplayAdapter, param3:Boolean = false) : void
      {
         _invoke("showMasteries",[param1,param2,param3]);
      }
      
      public function getPagesInfo() : ArrayCollection
      {
         throw new Error("use getProvider, this method is not available on the proxy.");
      }
      
      public function getPagesInfoUpdated() : ISignal
      {
         return _getSignal("getPagesInfoUpdated");
      }
      
      public function getSelectedPageID() : int
      {
         throw new Error("use getProvider, this method is not available on the proxy.");
      }
      
      public function setSelectedPageByID(param1:int) : void
      {
         _invoke("setSelectedPageByID",[param1]);
      }
      
      public function closeMasteries() : void
      {
         _invoke("closeMasteries");
      }
   }
}

