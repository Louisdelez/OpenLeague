package com.riotgames.platform.gameclient.module.services.watch
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.services.watch.IReplayDownloadAgent;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.json.jsonDecode;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ReplayDownloadAgent implements IReplayDownloadAgent
   {
      
      private var _replayProgressPercent:Number;
      
      private var _fileName:String;
      
      private var _metadataTriesRemaining:int;
      
      private var _onReplayDownloadComplete:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _isMetadataDownloading:Boolean;
      
      private var _metadataRetryTime:int = 1000;
      
      private var _isReplayDownloading:Boolean;
      
      private var _onReplayMetadataComplete:Signal = new Signal();
      
      private var _onReplayMetadataIOError:Signal = new Signal();
      
      private var _onReplayMetadataSecurityError:Signal = new Signal();
      
      private var _replayLoader:URLStream;
      
      private var _onReplayDownloadUnauthorized:Signal = new Signal();
      
      private var _gameId:Number;
      
      private var _israndomizingDownloadRequests:Boolean;
      
      private var _onReplayDownloadError:Signal = new Signal();
      
      private var _onReplayDownloadProgressUpdate:Signal = new Signal();
      
      private var _onProgressChanged:Signal = new Signal();
      
      public function ReplayDownloadAgent(param1:Number, param2:Boolean, param3:Boolean)
      {
         super();
         this._gameId = param1;
         this._metadataTriesRemaining = param2 ? 4 : 1;
         this._israndomizingDownloadRequests = param3;
         this._fileName = ClientConfig.instance.platformId + this._gameId.toString() + ".rofl";
      }
      
      private function parseMetadata(param1:String) : Object
      {
         var jsonResult:String = param1;
         var parsedResult:Object = null;
         try
         {
            parsedResult = jsonDecode(jsonResult);
            if(parsedResult != null && parsedResult["gameId"] != null && parsedResult["platformId"] != null && parsedResult["fileSize"] != null)
            {
               return parsedResult;
            }
         }
         catch(error:Error)
         {
         }
         return null;
      }
      
      public function get inProgress() : Boolean
      {
         return this._isMetadataDownloading || this._isReplayDownloading;
      }
      
      public function downloadReplay() : void
      {
         var _loc1_:String = null;
         var _loc2_:URLRequest = null;
         if(!this._isReplayDownloading)
         {
            this._isReplayDownloading = true;
            _loc1_ = ClientConfig.instance.replayServiceURL + "/replayFile/" + ClientConfig.instance.platformId + "/" + this._gameId;
            if(this._israndomizingDownloadRequests)
            {
               _loc1_ += "?" + String(Session.instance.getSummonerId());
            }
            _loc2_ = new URLRequest(_loc1_);
            _loc2_.requestHeaders = [new URLRequestHeader("Authorization",Session.instance.userToken != null ? Session.instance.userToken : "token")];
            this._replayLoader = new URLStream();
            this._replayLoader.addEventListener(Event.COMPLETE,this.writeFile);
            this._replayLoader.addEventListener(ProgressEvent.PROGRESS,this.downloadProgressUpdate);
            this._replayLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
            this._replayLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
            this._replayLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.httpResponseStatusHandler);
            this._replayLoader.load(_loc2_);
            this._onProgressChanged.dispatch();
         }
      }
      
      private function onGetReplayMetaDataComplete(param1:Event) : void
      {
         this._isMetadataDownloading = false;
         var _loc2_:Object = this.parseMetadata(param1.currentTarget.data as String);
         if(_loc2_ != null)
         {
            ServiceProxy.instance.replayFileManagerService.setCachedMetaData(this.replayId,_loc2_);
            this._onReplayMetadataComplete.dispatch(_loc2_);
         }
         else
         {
            --this._metadataTriesRemaining;
            if(this._metadataTriesRemaining > 0)
            {
               setTimeout(this.downloadMetadata,this._metadataRetryTime);
               this._metadataRetryTime *= 2;
            }
            else
            {
               this._onReplayMetadataIOError.dispatch();
            }
         }
         this._onProgressChanged.dispatch();
      }
      
      public function getOnReplayDownloadComplete() : ISignal
      {
         return this._onReplayDownloadComplete;
      }
      
      public function getOnReplayDownloadError() : ISignal
      {
         return this._onReplayDownloadError;
      }
      
      private function onGetReplayMetaDataSecurityError(param1:Event) : void
      {
         this._isMetadataDownloading = false;
         this._onReplayMetadataSecurityError.dispatch();
         this._onProgressChanged.dispatch();
      }
      
      private function get metadata() : Object
      {
         return ServiceProxy.instance.replayFileManagerService.getCachedMetaData(this.replayId);
      }
      
      private function httpResponseStatusHandler(param1:HTTPStatusEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:URLRequestHeader = null;
         var _loc5_:Number = NaN;
         if(param1.status == 200)
         {
            _loc2_ = param1.responseHeaders;
            if(_loc2_ != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = URLRequestHeader(_loc2_[_loc3_]);
                  if(_loc4_ != null && _loc4_.name != null && _loc4_.name == "Content-Disposition")
                  {
                     _loc5_ = -1;
                     if(_loc4_.value != null)
                     {
                        _loc5_ = _loc4_.value.indexOf("=");
                        if(_loc5_ > 0 && _loc5_ < _loc4_.value.length - 1)
                        {
                           this._fileName = _loc4_.value.substring(_loc5_ + 1);
                        }
                     }
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function onGetReplayMetaDataIOError(param1:Event) : void
      {
         this._isMetadataDownloading = false;
         this._onReplayMetadataIOError.dispatch();
         this._onProgressChanged.dispatch();
      }
      
      public function getOnReplayMetadataIOError() : ISignal
      {
         return this._onReplayMetadataIOError;
      }
      
      public function getOnReplayDownloadProgressUpdate() : ISignal
      {
         return this._onReplayDownloadProgressUpdate;
      }
      
      public function getOnReplayMetadataComplete() : ISignal
      {
         return this._onReplayMetadataComplete;
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
         this._isReplayDownloading = false;
         if(param1.status == 401)
         {
            if(this.metadata != null)
            {
               this.metadata["isAuthorized"] = false;
            }
            this._onReplayDownloadUnauthorized.dispatch();
         }
         else if(param1.status > 200)
         {
            this._onReplayDownloadError.dispatch();
         }
         this._onProgressChanged.dispatch();
      }
      
      public function downloadMetadata() : void
      {
         var _loc1_:String = null;
         var _loc2_:URLLoader = null;
         if(!this._isMetadataDownloading && this.metadata == null)
         {
            this._isMetadataDownloading = true;
            _loc1_ = ClientConfig.instance.replayServiceURL + "/replayFileMetaData/" + ClientConfig.instance.platformId + "/" + this._gameId;
            if(this._israndomizingDownloadRequests)
            {
               _loc1_ += "?" + String(Session.instance.getSummonerId());
            }
            _loc2_ = new URLLoader();
            _loc2_.addEventListener(Event.COMPLETE,this.onGetReplayMetaDataComplete);
            _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onGetReplayMetaDataIOError);
            _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onGetReplayMetaDataSecurityError);
            _loc2_.load(new URLRequest(_loc1_));
            this._onProgressChanged.dispatch();
         }
      }
      
      public function getOnReplayDownloadUnauthorized() : ISignal
      {
         return this._onReplayDownloadUnauthorized;
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         this._isReplayDownloading = false;
         trace("ReplayDownloadService IDErrorEvent: " + param1.toString());
         this._onReplayDownloadError.dispatch();
         this._onProgressChanged.dispatch();
      }
      
      private function get replayId() : String
      {
         return ServiceProxy.instance.replayFileManagerService.generateReplayId(this._gameId.toString(),ClientConfig.instance.platformId);
      }
      
      public function get isReplayDownloading() : Boolean
      {
         return this._isReplayDownloading;
      }
      
      public function getOnProgressChange() : ISignal
      {
         return this._onProgressChanged;
      }
      
      private function writeFile(param1:Event) : void
      {
         this._isReplayDownloading = false;
         var _loc2_:ByteArray = new ByteArray();
         param1.target.readBytes(_loc2_);
         ServiceProxy.instance.replayFileManagerService.addDownloadedReplayFile(_loc2_,this._fileName);
         this._onReplayDownloadComplete.dispatch();
         this._onProgressChanged.dispatch();
      }
      
      public function getOnReplayMetadataSecurityError() : ISignal
      {
         return this._onReplayMetadataSecurityError;
      }
      
      private function downloadProgressUpdate(param1:ProgressEvent) : void
      {
         this._onReplayDownloadProgressUpdate.dispatch(param1.bytesLoaded,param1.bytesTotal);
      }
   }
}

