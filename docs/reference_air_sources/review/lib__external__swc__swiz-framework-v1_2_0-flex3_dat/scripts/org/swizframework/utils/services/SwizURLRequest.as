package org.swizframework.utils.services
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   [ExcludeClass]
   public class SwizURLRequest
   {
      
      public var loader:URLLoader;
      
      public function SwizURLRequest(request:URLRequest, resultHandler:Function, faultHandler:Function = null, progressHandler:Function = null, httpStatusHandler:Function = null, handlerArgs:Array = null)
      {
         super();
         this.loader = new URLLoader();
         this.loader.addEventListener(Event.COMPLETE,function(e:Event):void
         {
            if(handlerArgs == null)
            {
               resultHandler(e);
            }
            else
            {
               resultHandler.apply(null,[e].concat(handlerArgs));
            }
         });
         if(faultHandler != null)
         {
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
            {
               if(handlerArgs == null)
               {
                  faultHandler(e);
               }
               else
               {
                  faultHandler.apply(null,[e].concat(handlerArgs));
               }
            });
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(e:SecurityErrorEvent):void
            {
               if(handlerArgs == null)
               {
                  faultHandler(e);
               }
               else
               {
                  faultHandler.apply(null,[e].concat(handlerArgs));
               }
            });
         }
         if(progressHandler != null)
         {
            this.loader.addEventListener(ProgressEvent.PROGRESS,function(e:ProgressEvent):void
            {
               if(handlerArgs == null)
               {
                  progressHandler(e);
               }
               else
               {
                  progressHandler.apply(null,[e].concat(handlerArgs));
               }
            });
         }
         if(httpStatusHandler != null)
         {
            this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,function(e:HTTPStatusEvent):void
            {
               if(handlerArgs == null)
               {
                  httpStatusHandler(e);
               }
               else
               {
                  httpStatusHandler.apply(null,[e].concat(handlerArgs));
               }
            });
         }
         this.loader.load(request);
      }
   }
}

