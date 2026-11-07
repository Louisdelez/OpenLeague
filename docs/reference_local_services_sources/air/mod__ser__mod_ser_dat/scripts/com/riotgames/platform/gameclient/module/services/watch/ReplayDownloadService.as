package com.riotgames.platform.gameclient.module.services.watch
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.services.watch.IReplayDownloadAgent;
   import com.riotgames.platform.gameclient.services.watch.IReplayDownloadService;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ReplayDownloadService implements IReplayDownloadService
   {
      
      private var _downloadCache:Dictionary;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _downloadStateChange:Signal;
      
      private var _downloading:Boolean;
      
      public function ReplayDownloadService()
      {
         super();
         this._downloadCache = new Dictionary();
         this._downloadStateChange = new Signal();
         this._downloading = false;
      }
      
      public function getDownloadStateChange() : ISignal
      {
         return this._downloadStateChange;
      }
      
      public function getReplayDownloadAgent(param1:Number, param2:Boolean, param3:Boolean) : IReplayDownloadAgent
      {
         var _loc4_:ReplayDownloadAgent = this._downloadCache[param1];
         if(_loc4_ == null)
         {
            _loc4_ = new ReplayDownloadAgent(param1,param2,param3);
            this._downloadCache[param1] = _loc4_;
            _loc4_.getOnProgressChange().add(this.onAgentProgressChange);
         }
         return _loc4_;
      }
      
      private function onAgentProgressChange() : void
      {
         var _loc1_:Boolean = this.isDownloading();
         if(this._downloading != _loc1_)
         {
            this._downloading = _loc1_;
            this._downloadStateChange.dispatch();
            if(!this._downloading)
            {
               this.pruneAgents();
            }
         }
      }
      
      private function pruneAgents() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in this._downloadCache)
         {
            if(!this._downloadCache[_loc2_].inProgress)
            {
               _loc1_.push(_loc2_);
            }
         }
         for each(_loc3_ in _loc1_)
         {
            delete this._downloadCache[_loc3_];
         }
      }
      
      public function isDownloading() : Boolean
      {
         var _loc1_:ReplayDownloadAgent = null;
         for each(_loc1_ in this._downloadCache)
         {
            if(_loc1_ != null && _loc1_.inProgress)
            {
               return true;
            }
         }
         return false;
      }
   }
}

