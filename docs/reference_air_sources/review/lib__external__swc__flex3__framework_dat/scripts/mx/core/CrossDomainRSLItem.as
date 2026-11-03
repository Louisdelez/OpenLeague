package mx.core
{
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import mx.events.RSLEvent;
   import mx.utils.LoaderUtil;
   import mx.utils.SHA256;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class CrossDomainRSLItem extends RSLItem
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var urlIndex:int = 0;
      
      private var digests:Array;
      
      private var hashTypes:Array;
      
      private var isSigned:Array;
      
      private var rslUrls:Array;
      
      private var policyFileUrls:Array;
      
      private var loadBytesLoader:Loader;
      
      public function CrossDomainRSLItem(rslUrls:Array, policyFileUrls:Array, digests:Array, hashTypes:Array, isSigned:Array, rootURL:String = null)
      {
         super(rslUrls[0],rootURL);
         this.rslUrls = rslUrls;
         this.policyFileUrls = policyFileUrls;
         this.digests = digests;
         this.hashTypes = hashTypes;
         this.isSigned = isSigned;
      }
      
      override public function itemCompleteHandler(event:Event) : void
      {
         completeCdRslLoad(event.target as URLLoader);
      }
      
      private function loadBytesCompleteHandler(event:Event) : void
      {
         loadBytesLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadBytesCompleteHandler);
         loadBytesLoader = null;
         super.itemCompleteHandler(event);
      }
      
      override public function load(progressHandler:Function, completeHandler:Function, ioErrorHandler:Function, securityErrorHandler:Function, rslErrorHandler:Function) : void
      {
         var rslError:ErrorEvent = null;
         chainedProgressHandler = progressHandler;
         chainedCompleteHandler = completeHandler;
         chainedIOErrorHandler = ioErrorHandler;
         chainedSecurityErrorHandler = securityErrorHandler;
         chainedRSLErrorHandler = rslErrorHandler;
         urlRequest = new URLRequest(LoaderUtil.createAbsoluteURL(rootURL,rslUrls[urlIndex]));
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(ProgressEvent.PROGRESS,itemProgressHandler);
         loader.addEventListener(Event.COMPLETE,itemCompleteHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,itemErrorHandler);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,itemErrorHandler);
         if(policyFileUrls.length > urlIndex && policyFileUrls[urlIndex] != "")
         {
            Security.loadPolicyFile(policyFileUrls[urlIndex]);
         }
         if(Boolean(isSigned[urlIndex]))
         {
            if(!urlRequest.hasOwnProperty("digest"))
            {
               if(hasFailover())
               {
                  loadFailover();
                  return;
               }
               rslError = new ErrorEvent(RSLEvent.RSL_ERROR);
               rslError.text = "Flex Error #1002: Flash Player 9.0.115 and above is required to support signed RSLs. Problem occurred when trying to load the RSL " + urlRequest.url + ".  Upgrade your Flash Player and try again.";
               super.itemErrorHandler(rslError);
               return;
            }
            urlRequest.digest = digests[urlIndex];
         }
         loader.load(urlRequest);
      }
      
      private function completeCdRslLoad(urlLoader:URLLoader) : Boolean
      {
         var verifiedDigest:Boolean = false;
         var rslDigest:String = null;
         var hasFailover:Boolean = false;
         var rslError:ErrorEvent = null;
         if(urlLoader == null || urlLoader.data == null || ByteArray(urlLoader.data).bytesAvailable == 0)
         {
            return true;
         }
         loadBytesLoader = new Loader();
         var context:LoaderContext = new LoaderContext();
         context.applicationDomain = ApplicationDomain.currentDomain;
         context.securityDomain = null;
         if("allowLoadBytesCodeExecution" in context)
         {
            context["allowLoadBytesCodeExecution"] = true;
         }
         if(digests[urlIndex] != null && String(digests[urlIndex]).length > 0)
         {
            verifiedDigest = false;
            if(!isSigned[urlIndex])
            {
               if(hashTypes[urlIndex] == SHA256.TYPE_ID)
               {
                  rslDigest = null;
                  if(urlLoader.data != null)
                  {
                     rslDigest = SHA256.computeDigest(urlLoader.data);
                  }
                  if(rslDigest == digests[urlIndex])
                  {
                     verifiedDigest = true;
                  }
               }
            }
            else
            {
               verifiedDigest = true;
            }
            if(!verifiedDigest)
            {
               hasFailover = hasFailover();
               rslError = new ErrorEvent(RSLEvent.RSL_ERROR);
               rslError.text = "Flex Error #1001: Digest mismatch with RSL " + urlRequest.url + ". Redeploy the matching RSL or relink your application with the matching library.";
               itemErrorHandler(rslError);
               return !hasFailover;
            }
         }
         loadBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadBytesCompleteHandler);
         loadBytesLoader.loadBytes(urlLoader.data,context);
         return true;
      }
      
      public function hasFailover() : Boolean
      {
         return rslUrls.length > urlIndex + 1;
      }
      
      override public function itemErrorHandler(event:ErrorEvent) : void
      {
         if(hasFailover())
         {
            trace(decodeURI(event.text));
            loadFailover();
         }
         else
         {
            super.itemErrorHandler(event);
         }
      }
      
      public function loadFailover() : void
      {
         if(urlIndex < rslUrls.length)
         {
            trace("Failed to load RSL " + rslUrls[urlIndex]);
            trace("Failing over to RSL " + rslUrls[urlIndex + 1]);
            ++urlIndex;
            url = rslUrls[urlIndex];
            load(chainedProgressHandler,chainedCompleteHandler,chainedIOErrorHandler,chainedSecurityErrorHandler,chainedRSLErrorHandler);
         }
      }
   }
}

