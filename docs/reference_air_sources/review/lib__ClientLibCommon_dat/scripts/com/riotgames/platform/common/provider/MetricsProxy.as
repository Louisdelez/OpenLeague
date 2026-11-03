package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import com.riotgames.pvpnet.tracker.ITreeOfTrackers;
   
   public class MetricsProxy extends ProviderProxyBase implements IMetricsProvider
   {
      
      private static var _instance:MetricsProxy;
      
      private var implSwap:*;
      
      public function MetricsProxy()
      {
         super(IMetricsProvider);
      }
      
      public static function get instance() : MetricsProxy
      {
         if(_instance == null)
         {
            _instance = new MetricsProxy();
         }
         return _instance;
      }
      
      public function willTrack() : Boolean
      {
         if(!impl)
         {
            return false;
         }
         return _invoke("willTrack");
      }
      
      public function track(param1:String, param2:Object = null, param3:Boolean = false, param4:Number = 1) : void
      {
         _invoke("track",[param1,param2,param4]);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function overrideImpl(param1:IMetricsProvider) : void
      {
         this.implSwap = impl;
         impl = param1;
      }
      
      public function createNewTrackerByName(param1:String) : ITreeOfTrackers
      {
         return _invoke("createNewTrackerByName",[param1]);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function restoreImpl() : void
      {
         if(this.implSwap != null)
         {
            impl = this.implSwap;
         }
      }
   }
}

