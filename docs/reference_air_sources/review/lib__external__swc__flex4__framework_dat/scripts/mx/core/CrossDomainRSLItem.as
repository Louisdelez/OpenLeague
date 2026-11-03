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
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var rsls:Array = [];
      
      private var urlIndex:int = 0;
      
      private var loadBytesLoader:Loader;
      
      public function CrossDomainRSLItem(rsls:Array, rootURL:String = null, moduleFactory:IFlexModuleFactory = null)
      {
         super(rsls[0].rslURL,rootURL,moduleFactory);
         this.rsls = rsls;
      }
      
      private function get currentRSLData() : RSLData
      {
         return RSLData(this.rsls[this.urlIndex]);
      }
      
      override public function load(progressHandler:Function, completeHandler:Function, ioErrorHandler:Function, securityErrorHandler:Function, rslErrorHandler:Function) : void
      {
         chainedProgressHandler = progressHandler;
         chainedCompleteHandler = completeHandler;
         chainedIOErrorHandler = ioErrorHandler;
         chainedSecurityErrorHandler = securityErrorHandler;
         chainedRSLErrorHandler = rslErrorHandler;
         var rslData:RSLData = this.currentRSLData;
         urlRequest = new URLRequest(LoaderUtil.createAbsoluteURL(rootURL,rslData.rslURL));
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(ProgressEvent.PROGRESS,itemProgressHandler);
         loader.addEventListener(Event.COMPLETE,this.itemCompleteHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.itemErrorHandler);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.itemErrorHandler);
         if(rslData.policyFileURL != "")
         {
            Security.loadPolicyFile(rslData.policyFileURL);
         }
         if(rslData.isSigned)
         {
            urlRequest.digest = rslData.digest;
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
         this.loadBytesLoader = new Loader();
         var context:LoaderContext = new LoaderContext();
         var rslData:RSLData = this.currentRSLData;
         if(Boolean(rslData.moduleFactory))
         {
            context.applicationDomain = rslData.moduleFactory.info()["currentDomain"];
         }
         else if(Boolean(moduleFactory))
         {
            context.applicationDomain = moduleFactory.info()["currentDomain"];
         }
         else
         {
            context.applicationDomain = ApplicationDomain.currentDomain;
         }
         context.securityDomain = null;
         context.allowCodeImport = true;
         if(rslData.digest != null && rslData.verifyDigest)
         {
            verifiedDigest = false;
            if(!rslData.isSigned)
            {
               if(rslData.hashType == SHA256.TYPE_ID)
               {
                  rslDigest = null;
                  if(urlLoader.data != null)
                  {
                     rslDigest = SHA256.computeDigest(urlLoader.data);
                  }
                  if(rslDigest == rslData.digest)
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
               hasFailover = this.hasFailover();
               rslError = new ErrorEvent(RSLEvent.RSL_ERROR);
               rslError.text = "Flex Error #1001: Digest mismatch with RSL " + urlRequest.url + ". Redeploy the matching RSL or relink your application with the matching library.";
               this.itemErrorHandler(rslError);
               return !hasFailover;
            }
         }
         this.loadBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadBytesCompleteHandler);
         this.loadBytesLoader.loadBytes(urlLoader.data,context);
         return true;
      }
      
      public function hasFailover() : Boolean
      {
         return this.rsls.length > this.urlIndex + 1;
      }
      
      public function loadFailover() : void
      {
         if(this.urlIndex < this.rsls.length)
         {
            trace("Failed to load RSL " + this.currentRSLData.rslURL);
            trace("Failing over to RSL " + RSLData(this.rsls[this.urlIndex + 1]).rslURL);
            ++this.urlIndex;
            url = this.currentRSLData.rslURL;
            this.load(chainedProgressHandler,chainedCompleteHandler,chainedIOErrorHandler,chainedSecurityErrorHandler,chainedRSLErrorHandler);
         }
      }
      
      override public function itemCompleteHandler(event:Event) : void
      {
         this.completeCdRslLoad(event.target as URLLoader);
      }
      
      override public function itemErrorHandler(event:ErrorEvent) : void
      {
         if(this.hasFailover())
         {
            trace(decodeURI(event.text));
            this.loadFailover();
         }
         else
         {
            super.itemErrorHandler(event);
         }
      }
      
      private function loadBytesCompleteHandler(event:Event) : void
      {
         this.loadBytesLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadBytesCompleteHandler);
         this.loadBytesLoader = null;
         super.itemCompleteHandler(event);
      }
   }
}

