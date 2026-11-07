package flash.html
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   
   [API("661")]
   [native(cls="HTMLResourceLoaderClass",instance="HTMLResourceLoaderObject",methods="auto",construct="native")]
   internal class ResourceLoader
   {
      
      internal static const s_MailToURLScheme:String = "mailto:";
      
      internal static const s_FileURLScheme:String = "file:";
      
      internal static const s_AboutURLScheme:String = "about:";
      
      internal static const s_HttpURLScheme:String = "http:";
      
      internal static const s_HttpsURLScheme:String = "https:";
      
      internal static const s_FtpURLScheme:String = "ftp:";
      
      internal static const s_AppURLScheme:String = "app:";
      
      internal static const s_AppStorageURLScheme:String = "app-storage:";
      
      internal static const s_DataURLScheme:String = "data:";
      
      private static const s_LocationHeaderName:String = "Location".toLowerCase();
      
      private static const s_LoadSwfHeaderName:String = "x-adobe-load-swf".toLowerCase();
      
      private static const s_HTTP_STATUS_OK:int = 200;
      
      private static const s_HTTP_STATUS_FILE_NOT_FOUND:int = 404;
      
      private static const s_HTTP_CONTENT_LENGTH_HEADER_NAME:String = "Content-Length";
      
      private var m_CurrStateFunction:Function;
      
      private var m_URLRequest:URLRequest;
      
      private var m_htmlControl:HTMLLoader;
      
      private var m_URLStream:URLStream;
      
      private var m_loader:Loader;
      
      private var m_receivedResponse:Boolean;
      
      private var m_receivedAllData:Boolean;
      
      private var m_clientReleased:Boolean;
      
      private var m_isStageWebViewRequest:Boolean;
      
      public function ResourceLoader(urlReq:URLRequest, htmlControl:HTMLLoader, isStageWebViewRequest:Boolean = false)
      {
         var startFunction:Function = null;
         var loaderInfo:LoaderInfo = null;
         var isLangDefined:Boolean = false;
         var isSubLangDefined:Boolean = false;
         var defaultAcceptLanguage:String = null;
         var headerAcceptLanguage:String = null;
         var foundAcceptLanguageHeader:Boolean = false;
         var index:int = 0;
         var reqHeaderItem:URLRequestHeader = null;
         super();
         this.m_URLRequest = urlReq;
         this.m_htmlControl = htmlControl;
         this.m_isStageWebViewRequest = isStageWebViewRequest;
         var urlStr:String = this.m_URLRequest.url;
         this.m_receivedResponse = false;
         this.m_receivedAllData = false;
         this.m_clientReleased = false;
         if(isScheme(urlStr,s_MailToURLScheme))
         {
            startFunction = this.startMailTo;
         }
         else if(isScheme(urlStr,s_DataURLScheme))
         {
            startFunction = this.startData;
         }
         else if(isScheme(urlStr,s_FileURLScheme))
         {
            startFunction = this.startFile;
            this.m_URLStream = new URLStream();
            this.m_URLStream.addEventListener(Event.COMPLETE,this.onFileComplete);
            this.m_URLStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onFileHTTPStatus);
            this.m_URLStream.addEventListener(IOErrorEvent.IO_ERROR,this.onFileError);
            this.m_URLStream.addEventListener(ProgressEvent.PROGRESS,this.onFileProgress);
            this.m_URLStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
         else if(!this.m_isStageWebViewRequest && Boolean(isScheme(urlStr,"app:")) && this.findHeader(s_LoadSwfHeaderName,this.m_URLRequest.requestHeaders) != null)
         {
            startFunction = this.startLoadSWF;
            this.m_loader = new Loader();
            loaderInfo = this.m_loader.contentLoaderInfo;
            loaderInfo.addEventListener(Event.COMPLETE,this.onLoadSWFComplete);
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadSWFError);
            loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
         else
         {
            if(!isScheme(urlStr,s_HttpURLScheme) && !isScheme(urlStr,s_HttpsURLScheme) && !isScheme(urlStr,s_AppURLScheme) && !isScheme(urlStr,s_AppStorageURLScheme) && !isScheme(urlStr,s_AboutURLScheme) && !isScheme(urlStr,s_FtpURLScheme))
            {
               this.m_URLRequest.url = "about:blank";
            }
            else if(Boolean(this.m_isStageWebViewRequest) && (Boolean(isScheme(urlStr,s_AppURLScheme)) || Boolean(isScheme(urlStr,s_AppStorageURLScheme))))
            {
               this.m_URLRequest.url = "about:blank";
            }
            else if(this.nativeIsPlatformAIR20())
            {
               isLangDefined = Capabilities.language != "xu";
               isSubLangDefined = Capabilities.languages.length > 0;
               if(isLangDefined && isSubLangDefined)
               {
                  defaultAcceptLanguage = Capabilities.languages[0] + "," + Capabilities.language;
               }
               else if(isLangDefined && !isSubLangDefined)
               {
                  defaultAcceptLanguage = Capabilities.language;
               }
               else if(!isLangDefined && isSubLangDefined)
               {
                  defaultAcceptLanguage = Capabilities.languages[0];
               }
               else
               {
                  defaultAcceptLanguage = "";
               }
               headerAcceptLanguage = new String("Accept-Language");
               foundAcceptLanguageHeader = false;
               for(index = 0; index < this.m_URLRequest.requestHeaders.length; index++)
               {
                  reqHeaderItem = this.m_URLRequest.requestHeaders[index];
                  if(reqHeaderItem.name.toLowerCase() == headerAcceptLanguage.toLowerCase())
                  {
                     if(reqHeaderItem.value.length == 0)
                     {
                        reqHeaderItem.value = defaultAcceptLanguage;
                     }
                     foundAcceptLanguageHeader = true;
                     break;
                  }
               }
               if(!foundAcceptLanguageHeader)
               {
                  reqHeaderItem = new URLRequestHeader(headerAcceptLanguage,defaultAcceptLanguage);
                  this.m_URLRequest.requestHeaders.push(reqHeaderItem);
               }
            }
            startFunction = this.start;
            this.m_URLStream = new URLStream();
            this.m_URLStream.addEventListener(Event.COMPLETE,this.onComplete);
            this.m_URLStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHTTPStatus);
            this.m_URLStream.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.m_URLStream.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.m_URLStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
         this.nativeInit(this.cancel,startFunction);
      }
      
      private static function isScheme(urlStr:String, scheme:String) : Boolean
      {
         return urlStr.substring(0,Math.min(urlStr.length,scheme.length)).toLowerCase() == scheme;
      }
      
      private static function isLocalURL(urlStr:String) : Boolean
      {
         return Boolean(isScheme(urlStr,s_FileURLScheme)) || Boolean(isScheme(urlStr,s_AppURLScheme)) || Boolean(isScheme(urlStr,s_AppStorageURLScheme));
      }
      
      private static function makeRequestForRedirect(request:URLRequest, newURL:String) : URLRequest
      {
         var newRequest:URLRequest = new URLRequest(newURL);
         newRequest.contentType = request.contentType;
         newRequest.method = "GET";
         newRequest.requestHeaders = [new URLRequestHeader("Referer","http://adobe.com/apollo")];
         newRequest.userAgent = request.userAgent;
         newRequest.manageCookies = request.manageCookies;
         newRequest.useCache = request.useCache;
         newRequest.cacheResponse = request.cacheResponse;
         if(request.hasOwnProperty("idleTimeout"))
         {
            newRequest.idleTimeout = request.idleTimeout;
         }
         newRequest.authenticate = request.authenticate;
         return newRequest;
      }
      
      private function detachURLStream() : void
      {
         var loaderInfo:LoaderInfo = null;
         var urlStr:String = this.m_URLRequest.url;
         this.m_receivedAllData = true;
         this.releaseClient(false);
         if(isScheme(urlStr,s_FileURLScheme))
         {
            this.m_URLStream.removeEventListener(Event.COMPLETE,this.onFileComplete);
            this.m_URLStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onFileHTTPStatus);
            this.m_URLStream.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileError);
            this.m_URLStream.removeEventListener(ProgressEvent.PROGRESS,this.onFileProgress);
            this.m_URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
         else if(Boolean(isScheme(urlStr,"app:")) && this.findHeader(s_LoadSwfHeaderName,this.m_URLRequest.requestHeaders) != null)
         {
            loaderInfo = this.m_loader.contentLoaderInfo;
            loaderInfo.removeEventListener(Event.COMPLETE,this.onLoadSWFComplete);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadSWFError);
            loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
         else
         {
            this.m_URLStream.removeEventListener(Event.COMPLETE,this.onComplete);
            this.m_URLStream.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHTTPStatus);
            this.m_URLStream.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.m_URLStream.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.m_URLStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
      }
      
      private function doTrace(traceStr:String) : void
      {
      }
      
      public function cancel() : void
      {
         try
         {
            if(!this.m_receivedAllData)
            {
               if(Boolean(this.m_URLStream))
               {
                  this.m_URLStream.close();
               }
            }
            this.releaseClient(true);
         }
         catch(error:*)
         {
            doTrace("HTMLResourceLoader::cancel raised!!!");
         }
      }
      
      private function startMailTo() : void
      {
         navigateToURL(this.m_URLRequest);
         this.releaseClient(true);
      }
      
      private function startData() : void
      {
         var endOfHeaderString:int;
         var headerString:String;
         var indexOfBase64:int;
         var buffer:String;
         var url:String = null;
         var isBase64:Boolean = false;
         var dataArray:ByteArray = null;
         url = this.m_URLRequest.url;
         if(this.nativeIsSynchronous())
         {
            this.nativeDidFail(url);
            this.releaseClient(true);
            return;
         }
         if(!this.nativeCanLoadDataURL())
         {
            setTimeout(function():void
            {
               nativeDidFail(url);
               releaseClient(true);
            },1);
            return;
         }
         endOfHeaderString = url.indexOf(",");
         if(endOfHeaderString == -1)
         {
            setTimeout(function():void
            {
               nativeDidFail(url);
               releaseClient(true);
            },1);
            return;
         }
         headerString = url.substring(s_DataURLScheme.length,endOfHeaderString + 1).toLowerCase();
         indexOfBase64 = headerString.indexOf(";base64,");
         isBase64 = indexOfBase64 != -1;
         buffer = url.substring(endOfHeaderString + 1);
         dataArray = new ByteArray();
         dataArray.writeUTFBytes(buffer);
         setTimeout(function():void
         {
            nativeReceivedRawDataURLBuffer(dataArray,isBase64);
            nativeReceivedAllData();
            releaseClient(true);
         },1);
      }
      
      private function startFile() : void
      {
         var fileURLWithoutQueryString:String = null;
         var fileURLRequest:URLRequest = null;
         var urlRequestToLoad:URLRequest = this.m_URLRequest;
         var startOfQueryString:int = urlRequestToLoad.url.indexOf("?");
         if(startOfQueryString != -1)
         {
            fileURLWithoutQueryString = urlRequestToLoad.url.substring(0,startOfQueryString);
            fileURLRequest = new URLRequest(fileURLWithoutQueryString);
            this.nativeCopySynchronousAttribute(fileURLRequest,urlRequestToLoad);
            fileURLRequest.contentType = this.m_URLRequest.contentType;
            fileURLRequest.data = this.m_URLRequest.data;
            fileURLRequest.method = this.m_URLRequest.method;
            fileURLRequest.requestHeaders = this.m_URLRequest.requestHeaders;
            urlRequestToLoad = fileURLRequest;
         }
         this.m_URLStream.load(urlRequestToLoad);
      }
      
      private function onFileHTTPStatus(ev:Event) : void
      {
      }
      
      private function onFileProgress(ev:Event) : void
      {
      }
      
      private function onFileError(event:Event) : void
      {
         this.doTrace("onFileError: " + this.m_URLRequest.url);
         try
         {
            this.doTrace(event.toString());
            this.didFail("got onFileError when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onFileError: " + this.m_URLRequest.url);
         }
      }
      
      private function onFileComplete(ev:Event) : void
      {
         var fileLength:uint = 0;
         var flNum:* = undefined;
         var bytes:ByteArray = null;
         this.doTrace("onComplete: " + this.m_URLRequest.url);
         try
         {
            fileLength = uint(this.m_URLStream.bytesAvailable);
            flNum = new Number(fileLength);
            this.receivedResponse(0,[new URLRequestHeader("Content-Length",flNum.toString())],this.m_URLRequest.url,null,null);
            if(!this.m_receivedAllData && fileLength > 0 && this.m_URLStream.connected == true)
            {
               bytes = new ByteArray();
               this.m_URLStream.readBytes(bytes,0);
               this.nativeReceivedData(bytes);
            }
            this.receivedAllData("got onComplete when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onComplete: " + this.m_URLRequest.url);
         }
      }
      
      private function start() : void
      {
         try
         {
            this.m_URLStream.load(this.m_URLRequest);
         }
         catch(error:*)
         {
            setTimeout(function():void
            {
               didFail("caught an exception while attempting to call m_URLStream.load() in ResourceLoader::start()");
               releaseClient(true);
            },1);
         }
      }
      
      private function receivedResponse(httpStatus:int, responseHeaders:Array, responseURL:String, traceStrNotSent:String, traceStrSent:String = null) : void
      {
         if(this.m_clientReleased)
         {
            this.doTrace("in receivedResponse, when m_clientReleased is true!!!");
         }
         if(!this.m_receivedResponse)
         {
            this.nativeReceivedResponse(httpStatus,responseHeaders,responseURL);
            this.m_receivedResponse = true;
            if(traceStrSent != null)
            {
               this.doTrace(traceStrSent);
            }
         }
         else if(traceStrNotSent != null)
         {
            this.doTrace(traceStrNotSent);
         }
      }
      
      private function receivedAllData(traceStrNotSent:String, traceStrSent:String = null) : void
      {
         if(this.m_clientReleased)
         {
            this.doTrace("in receivedAllData, when m_clientReleased is true!!!");
         }
         if(!this.m_receivedAllData)
         {
            this.nativeReceivedAllData();
            this.m_receivedAllData = true;
            if(traceStrSent != null)
            {
               this.doTrace(traceStrSent);
            }
         }
         else if(traceStrNotSent != null)
         {
            this.doTrace(traceStrNotSent);
         }
      }
      
      private function didFail(traceStrNotSent:String, traceStrSent:* = null) : void
      {
         if(this.m_clientReleased)
         {
            this.doTrace("in didFail, when m_clientReleased is true!!!");
         }
         if(!this.m_receivedAllData)
         {
            this.nativeDidFail(this.m_URLRequest.url);
            this.m_receivedAllData = true;
            this.m_receivedResponse = true;
            if(traceStrSent != null)
            {
               this.doTrace(traceStrSent);
            }
         }
         else if(traceStrNotSent != null)
         {
            this.doTrace(traceStrNotSent);
         }
      }
      
      private function releaseClient(closeStream:Boolean) : void
      {
         if(!this.m_clientReleased)
         {
            this.nativeReleaseClient(closeStream);
            this.m_clientReleased = true;
         }
      }
      
      private function findHeader(header:String, headersArray:Array) : URLRequestHeader
      {
         var currHeader:URLRequestHeader = null;
         for(var i:uint = 0; i < headersArray.length; i++)
         {
            currHeader = headersArray[i];
            if(Boolean(currHeader) && Boolean(currHeader.name) && currHeader.name.toLowerCase() == header)
            {
               return currHeader;
            }
         }
         return null;
      }
      
      private native function makeURLAbsolute(param1:String, param2:String) : String;
      
      private function getRedirectLocation(currentURL:String, responseHeadersArray:Array) : String
      {
         var locationHeaderValue:String = null;
         var result:String = null;
         var locationHeader:URLRequestHeader = this.findHeader(s_LocationHeaderName,responseHeadersArray);
         if(locationHeader != null)
         {
            locationHeaderValue = locationHeader.value;
            if(locationHeaderValue != null)
            {
               result = this.makeURLAbsolute(currentURL,locationHeaderValue);
            }
         }
         return result;
      }
      
      private function onHTTPStatus(event:HTTPStatusEvent) : void
      {
         var proposedURLRequest:URLRequest = null;
         var newURLRequest:URLRequest = null;
         var newURL:String = null;
         var failRedirect:Boolean = false;
         this.doTrace("onHTTPStatus: " + this.m_URLRequest.url);
         try
         {
            this.doTrace(event.toString());
            proposedURLRequest = null;
            newURLRequest = null;
            newURL = null;
            failRedirect = true;
            switch(event.status)
            {
               case 301:
               case 302:
               case 306:
               case 303:
                  newURL = this.getRedirectLocation(this.m_URLRequest.url,event.responseHeaders);
                  if(newURL != null && !isLocalURL(newURL))
                  {
                     proposedURLRequest = makeRequestForRedirect(this.m_URLRequest,newURL);
                     newURLRequest = this.nativeReceivedRedirect(proposedURLRequest,300,event.responseHeaders,newURL);
                     if(newURLRequest != null)
                     {
                        this.m_URLStream.load(newURLRequest);
                        this.m_URLRequest = newURLRequest;
                        failRedirect = false;
                     }
                  }
                  if(failRedirect)
                  {
                     this.didFail("bad redirection");
                     this.releaseClient(true);
                  }
                  break;
               default:
                  this.receivedResponse(event.status,event.responseHeaders,event.responseURL,"got onHTTStatus when m_receivedResponse was true");
            }
         }
         finally
         {
            this.doTrace("exit onHTTPStatus: " + this.m_URLRequest.url);
         }
      }
      
      private function onProgress(event:ProgressEvent) : void
      {
         var bytesAvailableNow:uint = 0;
         var bytes:ByteArray = null;
         this.doTrace("onProgress: " + this.m_URLRequest.url);
         try
         {
            if(this.m_clientReleased)
            {
               this.doTrace("in onProgress, when m_clientReleased is true!!!");
            }
            if(!this.m_receivedAllData)
            {
               bytesAvailableNow = uint(this.m_URLStream.bytesAvailable);
               if(bytesAvailableNow > 0)
               {
                  if(this.m_receivedResponse == false)
                  {
                     this.doTrace(event.toString());
                  }
                  this.receivedResponse(s_HTTP_STATUS_OK,[],this.m_URLRequest.url,null,"got onProgress when m_receivedResponse was false!!");
                  bytes = new ByteArray();
                  if(this.m_URLStream.connected == true)
                  {
                     this.m_URLStream.readBytes(bytes,0);
                     this.nativeReceivedData(bytes);
                  }
               }
            }
            else
            {
               this.doTrace("got onProgress when m_receivedAllData was true!!");
            }
         }
         finally
         {
            this.doTrace("exit onProgress: " + this.m_URLRequest.url);
         }
      }
      
      private function onComplete(event:Event) : void
      {
         var bytesAvailableNow:uint = 0;
         var bytes:ByteArray = null;
         this.doTrace("onComplete: " + this.m_URLRequest.url);
         try
         {
            this.receivedResponse(s_HTTP_STATUS_OK,[],this.m_URLRequest.url,null,"got onComplete when m_receivedResponse was false!!");
            if(!this.m_receivedAllData)
            {
               bytesAvailableNow = this.m_URLStream.connected ? uint(this.m_URLStream.bytesAvailable) : 0;
               if(bytesAvailableNow > 0 && this.m_URLStream.connected == true)
               {
                  bytes = new ByteArray();
                  this.m_URLStream.readBytes(bytes,0);
                  this.nativeReceivedData(bytes);
               }
            }
            this.receivedAllData("got onComplete when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onComplete: " + this.m_URLRequest.url);
         }
      }
      
      private function onError(event:IOErrorEvent) : void
      {
         this.doTrace("onError: " + this.m_URLRequest.url);
         try
         {
            this.doTrace(event.toString());
            this.didFail("got onError when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onError: " + this.m_URLRequest.url);
         }
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
         this.doTrace("onSecurityError: " + this.m_URLRequest.url);
         try
         {
            this.didFail("got onSecurityError when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onSecurityError: " + this.m_URLRequest.url);
         }
      }
      
      private function startLoadSWF() : void
      {
         var loaderContext:LoaderContext = new LoaderContext(false,this.m_htmlControl.pageApplicationDomain);
         this.m_loader.load(this.m_URLRequest,loaderContext);
      }
      
      private function onLoadSWFError(event:Event) : void
      {
         this.doTrace("onFileError: " + this.m_URLRequest.url);
         try
         {
            this.doTrace(event.toString());
            this.receivedResponse(0,[],this.m_URLRequest.url,"got onLoadSWFError when m_receivedResponse was true!!","got onFileError when m_receivedResponse was false!!");
            this.receivedAllData("got onLoadSWFError when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onFileError: " + this.m_URLRequest.url);
         }
      }
      
      private function onLoadSWFComplete(ev:Event) : void
      {
         var fileLength:uint = 0;
         var flNum:* = undefined;
         this.doTrace("onLoadSWFComplete: " + this.m_URLRequest.url);
         try
         {
            fileLength = 0;
            flNum = new Number(fileLength);
            this.receivedResponse(0,[new URLRequestHeader("Content-Length",flNum.toString())],this.m_URLRequest.url,null,null);
            this.receivedAllData("got onLoadSWFComplete when m_receivedAllData was already true!!!");
            this.releaseClient(true);
         }
         finally
         {
            this.doTrace("exit onComplete: " + this.m_URLRequest.url);
         }
      }
      
      private native function nativeInit(param1:Function, param2:Function) : void;
      
      private native function nativeReceivedRedirect(param1:URLRequest, param2:int, param3:Array, param4:String) : URLRequest;
      
      private native function nativeReceivedResponse(param1:int, param2:Array, param3:String) : void;
      
      private native function nativeReceivedData(param1:ByteArray) : void;
      
      private native function nativeCanLoadDataURL() : Boolean;
      
      private native function nativeIsSynchronous() : Boolean;
      
      private native function nativeReceivedRawDataURLBuffer(param1:ByteArray, param2:Boolean) : void;
      
      private native function nativeReceivedAllData() : void;
      
      private native function nativeDidFail(param1:String) : void;
      
      private native function nativeReleaseClient(param1:Boolean) : void;
      
      private native function nativeCopySynchronousAttribute(param1:URLRequest, param2:URLRequest) : void;
      
      private native function nativeIsPlatformAIR20() : Boolean;
   }
}

