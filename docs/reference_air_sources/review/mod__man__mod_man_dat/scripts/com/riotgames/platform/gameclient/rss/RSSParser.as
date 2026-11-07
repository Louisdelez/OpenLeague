package com.riotgames.platform.gameclient.rss
{
   import com.riotgames.util.logging.ErrorUtil;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class RSSParser
   {
      
      private var logger:ILogger;
      
      private var rssLoader:URLLoader;
      
      private var feedItemFoundCallback:Function;
      
      public function RSSParser(param1:String, param2:Function)
      {
         var rssXMLURL:URLRequest = null;
         var url:String = param1;
         var loadedCallback:Function = param2;
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
         super();
         this.feedItemFoundCallback = loadedCallback;
         try
         {
            rssXMLURL = new URLRequest(url);
            this.rssLoader = new URLLoader(rssXMLURL);
            this.rssLoader.addEventListener(IOErrorEvent.IO_ERROR,this.catchError);
            this.rssLoader.addEventListener("complete",this.xmlLoaded);
         }
         catch(e:Error)
         {
            logger.info(ErrorUtil.makeErrorMessage(e,"constructor, error loading RSS feed from url"));
         }
      }
      
      private function xmlLoaded(param1:Event) : void
      {
         var rssXML:XML = null;
         var newestItem:XML = null;
         var newestDate:Date = null;
         var item:XML = null;
         var expiredDateSring:String = null;
         var itemDateString:String = null;
         var itemDate:Date = null;
         var expiredDate:Date = null;
         var currentDate:Date = null;
         var evtObj:Event = param1;
         try
         {
            rssXML = XML(this.rssLoader.data);
            if(rssXML.namespace("") != undefined)
            {
               default xml namespace = rssXML.namespace("");
            }
            newestItem = null;
            newestDate = new Date(1);
            for each(item in rssXML..item)
            {
               itemDateString = item.pubDate.toString();
               if(itemDateString != "" && itemDateString != null)
               {
                  itemDate = new Date(itemDateString);
                  if(itemDate.time > newestDate.time)
                  {
                     newestDate = itemDate;
                     newestItem = item;
                  }
               }
            }
            if(newestItem == null)
            {
               return;
            }
            expiredDateSring = newestItem.expireDate.toString();
            if(expiredDateSring != "" && expiredDateSring != null)
            {
               expiredDate = new Date(expiredDateSring);
               currentDate = new Date();
               if(currentDate.time > expiredDate.time)
               {
                  return;
               }
            }
            this.feedItemFoundCallback(newestItem.title.toString(),newestItem.description.toString(),newestDate);
         }
         catch(e:Error)
         {
            logger.info(ErrorUtil.makeErrorMessage(e,"error parsing RSS feed" + e.message));
         }
      }
      
      private function catchError(param1:IOErrorEvent) : void
      {
         this.logger.info(ErrorUtil.makeErrorMessage(param1,"loading RSS feed"));
      }
   }
}

