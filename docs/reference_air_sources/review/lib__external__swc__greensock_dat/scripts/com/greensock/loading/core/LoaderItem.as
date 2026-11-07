package com.greensock.loading.core
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.LoaderStatus;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.net.URLVariables;
   
   [Event(name="ioError",type="com.greensock.events.LoaderEvent")]
   public class LoaderItem extends LoaderCore
   {
      
      protected static var _cacheID:Number = new Date().getTime();
      
      protected var _auditStream:URLStream;
      
      protected var _request:URLRequest;
      
      protected var _skipAlternateURL:Boolean;
      
      protected var _scriptAccessDenied:Boolean;
      
      protected var _url:String;
      
      protected var _preferEstimatedBytesInAudit:Boolean;
      
      protected var _httpStatus:int;
      
      public function LoaderItem(urlOrRequest:*, vars:Object = null)
      {
         super(vars);
         _request = urlOrRequest is URLRequest ? urlOrRequest as URLRequest : new URLRequest(urlOrRequest);
         _url = _request.url;
         _setRequestURL(_request,_url);
      }
      
      public function get scriptAccessDenied() : Boolean
      {
         return _scriptAccessDenied;
      }
      
      override protected function _failHandler(event:Event, dispatchError:Boolean = true) : void
      {
         if(this.vars.alternateURL != undefined && this.vars.alternateURL != "" && !_skipAlternateURL)
         {
            _errorHandler(event);
            _skipAlternateURL = true;
            _url = "temp" + Math.random();
            this.url = this.vars.alternateURL;
         }
         else
         {
            super._failHandler(event,dispatchError);
         }
      }
      
      public function get request() : URLRequest
      {
         return _request;
      }
      
      protected function _httpStatusHandler(event:Event) : void
      {
         _httpStatus = (event as Object).status;
         dispatchEvent(new LoaderEvent(LoaderEvent.HTTP_STATUS,this));
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         _closeStream();
         super._dump(scrubLevel,newStatus,suppressEvents);
      }
      
      protected function _closeStream() : void
      {
         if(_auditStream != null)
         {
            _auditStream.removeEventListener(ProgressEvent.PROGRESS,_auditStreamHandler);
            _auditStream.removeEventListener(Event.COMPLETE,_auditStreamHandler);
            _auditStream.removeEventListener("ioError",_auditStreamHandler);
            _auditStream.removeEventListener("securityError",_auditStreamHandler);
            try
            {
               _auditStream.close();
            }
            catch(error:Error)
            {
            }
            _auditStream = null;
         }
      }
      
      public function set url(value:String) : void
      {
         var isLoading:Boolean = false;
         if(_url != value)
         {
            _url = value;
            _setRequestURL(_request,_url);
            isLoading = Boolean(_status == LoaderStatus.LOADING);
            _dump(1,LoaderStatus.READY,true);
            if(isLoading)
            {
               _load();
            }
         }
      }
      
      public function get httpStatus() : int
      {
         return _httpStatus;
      }
      
      protected function _prepRequest() : void
      {
         _scriptAccessDenied = false;
         _httpStatus = 0;
         _closeStream();
         if(Boolean(this.vars.noCache) && (!_isLocal || _url.substr(0,4) == "http"))
         {
            _setRequestURL(_request,_url,"gsCacheBusterID=" + _cacheID++);
         }
      }
      
      protected function _setRequestURL(request:URLRequest, url:String, extraParams:String = "") : void
      {
         var data:URLVariables = null;
         var pair:Array = null;
         var a:Array = Boolean(this.vars.allowMalformedURL) ? [url] : url.split("?");
         var s:String = a[0];
         var parsedURL:String = "";
         for(var i:int = 0; i < s.length; i++)
         {
            parsedURL += s.charAt(i);
         }
         request.url = parsedURL;
         if(a.length >= 2)
         {
            extraParams += extraParams == "" ? a[1] : "&" + a[1];
         }
         if(extraParams != "")
         {
            data = request.data is URLVariables ? request.data as URLVariables : new URLVariables();
            a = extraParams.split("&");
            i = int(a.length);
            while(--i > -1)
            {
               pair = a[i].split("=");
               data[pair.shift()] = pair.join("=");
            }
            request.data = data;
         }
      }
      
      protected function _auditStreamHandler(event:Event) : void
      {
         var request:URLRequest = null;
         if(event is ProgressEvent)
         {
            _cachedBytesTotal = (event as ProgressEvent).bytesTotal;
            if(_preferEstimatedBytesInAudit && uint(this.vars.estimatedBytes) > _cachedBytesTotal)
            {
               _cachedBytesTotal = uint(this.vars.estimatedBytes);
            }
         }
         else if(event.type == "ioError" || event.type == "securityError")
         {
            if(this.vars.alternateURL != undefined && this.vars.alternateURL != "" && this.vars.alternateURL != _url)
            {
               _errorHandler(event);
               _url = this.vars.alternateURL;
               _setRequestURL(_request,_url);
               request = new URLRequest();
               request.data = _request.data;
               request.method = _request.method;
               _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
               _auditStream.load(request);
               return;
            }
            super._failHandler(event);
         }
         _auditedSize = true;
         _closeStream();
         dispatchEvent(new Event("auditedSize"));
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      override public function auditSize() : void
      {
         var request:URLRequest = null;
         if(_auditStream == null)
         {
            _auditStream = new URLStream();
            _auditStream.addEventListener(ProgressEvent.PROGRESS,_auditStreamHandler,false,0,true);
            _auditStream.addEventListener(Event.COMPLETE,_auditStreamHandler,false,0,true);
            _auditStream.addEventListener("ioError",_auditStreamHandler,false,0,true);
            _auditStream.addEventListener("securityError",_auditStreamHandler,false,0,true);
            request = new URLRequest();
            request.data = _request.data;
            request.method = _request.method;
            _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
            _auditStream.load(request);
         }
      }
   }
}

