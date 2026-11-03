package spark.core
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import mx.utils.LinkedList;
   import mx.utils.LinkedListNode;
   import spark.events.LoaderInvalidationEvent;
   
   [Event(name="invalidateLoader",type="spark.events.LoaderInvalidationEvent")]
   public class ContentCache extends EventDispatcher implements IContentLoader
   {
      
      protected static const UNTRUSTED:String = "untrusted";
      
      protected var cachedData:Dictionary = new Dictionary();
      
      protected var cacheEntries:LinkedList = new LinkedList();
      
      protected var requestQueue:LinkedList = new LinkedList();
      
      protected var activeRequests:LinkedList = new LinkedList();
      
      protected var priorityGroup:String = "_DEFAULT_";
      
      private var _enableCaching:Boolean = true;
      
      private var _enableQueueing:Boolean = false;
      
      private var _maxActiveRequests:int = 2;
      
      private var _maxCacheEntries:int = 100;
      
      public function ContentCache()
      {
         super();
      }
      
      public function get enableCaching() : Boolean
      {
         return this._enableCaching;
      }
      
      public function set enableCaching(value:Boolean) : void
      {
         if(value != this._enableCaching)
         {
            this._enableCaching = value;
         }
      }
      
      public function get enableQueueing() : Boolean
      {
         return this._enableQueueing;
      }
      
      public function set enableQueueing(value:Boolean) : void
      {
         if(value != this._enableQueueing)
         {
            this._enableQueueing = value;
         }
      }
      
      public function get numCacheEntries() : int
      {
         return this.cacheEntries.length;
      }
      
      public function get maxActiveRequests() : int
      {
         return this._maxActiveRequests;
      }
      
      public function set maxActiveRequests(value:int) : void
      {
         if(value != this._maxActiveRequests)
         {
            this._maxActiveRequests = value;
         }
      }
      
      public function get maxCacheEntries() : int
      {
         return this._maxCacheEntries;
      }
      
      public function set maxCacheEntries(value:int) : void
      {
         if(value != this._maxCacheEntries)
         {
            this._maxCacheEntries = value;
            this.enforceMaximumCacheEntries();
         }
      }
      
      public function load(source:Object, contentLoaderGrouping:String = null) : ContentRequest
      {
         var contentRequest:ContentRequest = null;
         var loader:Loader = null;
         var urlRequest:URLRequest = null;
         var entry:CacheEntryNode = null;
         var loaderContext:LoaderContext = null;
         var node:LinkedListNode = null;
         var key:Object = source is URLRequest ? URLRequest(source).url : source;
         var cacheEntry:CacheEntryNode = this.cachedData[key];
         if(!cacheEntry || cacheEntry.value == UNTRUSTED || !this.enableCaching)
         {
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loader_completeHandler,false,0,true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loader_completeHandler,false,0,true);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_completeHandler,false,0,true);
            urlRequest = source is URLRequest ? source as URLRequest : new URLRequest(source as String);
            if(!cacheEntry && this.enableCaching)
            {
               this.addCacheEntry(key,loader.contentLoaderInfo);
               entry = this.cachedData[key];
               if(Boolean(entry))
               {
                  entry.complete = false;
               }
            }
            contentRequest = new ContentRequest(this,loader.contentLoaderInfo);
            if(this.enableQueueing)
            {
               this.queueRequest(urlRequest,loader,contentLoaderGrouping);
            }
            else
            {
               loaderContext = new LoaderContext();
               loaderContext.checkPolicyFile = true;
               loader.load(urlRequest,loaderContext);
            }
         }
         else
         {
            contentRequest = new ContentRequest(this,cacheEntry.value as LoaderInfo,true,cacheEntry.complete);
            node = this.cacheEntries.remove(cacheEntry);
            this.cacheEntries.unshift(node);
         }
         return contentRequest;
      }
      
      public function getCacheEntry(source:Object) : Object
      {
         var key:Object = source is URLRequest ? URLRequest(source).url : source;
         var cacheEntry:CacheEntryNode = this.cachedData[key];
         return Boolean(cacheEntry) ? cacheEntry.value : null;
      }
      
      public function removeAllCacheEntries() : void
      {
         this.cachedData = new Dictionary();
         this.cacheEntries = new LinkedList();
      }
      
      public function removeCacheEntry(source:Object) : void
      {
         var key:Object = source is URLRequest ? URLRequest(source).url : source;
         var node:CacheEntryNode = this.cachedData[key];
         if(Boolean(node))
         {
            this.cacheEntries.remove(node);
            delete this.cachedData[key];
         }
      }
      
      public function addCacheEntry(source:Object, value:Object) : void
      {
         var key:Object = source is URLRequest ? URLRequest(source).url : source;
         var node:CacheEntryNode = this.cachedData[key];
         if(Boolean(node))
         {
            this.cacheEntries.remove(node);
         }
         node = new CacheEntryNode(key,value);
         this.cachedData[source] = node;
         this.cacheEntries.unshift(node);
         this.enforceMaximumCacheEntries();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function enforceMaximumCacheEntries() : void
      {
         var node:CacheEntryNode = null;
         var key:Object = null;
         if(this._maxCacheEntries <= 0)
         {
            return;
         }
         while(this.cacheEntries.length > this._maxCacheEntries)
         {
            node = this.cacheEntries.pop() as CacheEntryNode;
            key = node.source is URLRequest ? URLRequest(node.source).url : node.source;
            delete this.cachedData[key];
         }
      }
      
      public function prioritize(contentLoaderGrouping:String) : void
      {
         this.priorityGroup = contentLoaderGrouping;
         this.shiftPriority();
         this.processQueue();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function queueRequest(source:URLRequest, loader:Loader, queueGroup:String) : void
      {
         var current:QueueEntryNode = null;
         var node:QueueEntryNode = new QueueEntryNode(source,loader,queueGroup);
         if(queueGroup == this.priorityGroup)
         {
            current = this.requestQueue.head as QueueEntryNode;
            while(Boolean(current) && Boolean(current.next) && current.queueGroup == this.priorityGroup)
            {
               current = current.next as QueueEntryNode;
            }
            if(Boolean(current))
            {
               if(current.queueGroup == this.priorityGroup)
               {
                  this.requestQueue.insertAfter(node,current);
               }
               else
               {
                  this.requestQueue.insertBefore(node,current);
               }
            }
            else
            {
               this.requestQueue.push(node);
            }
         }
         else
         {
            this.requestQueue.push(node);
         }
         this.processQueue();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processQueue() : void
      {
         var node:QueueEntryNode = null;
         var loaderContext:LoaderContext = null;
         var loader:Loader = null;
         if(this.activeRequests.length < this.maxActiveRequests && this.requestQueue.length > 0)
         {
            node = this.requestQueue.shift() as QueueEntryNode;
            if(Boolean(node))
            {
               loaderContext = new LoaderContext();
               loaderContext.checkPolicyFile = true;
               loader = node.value;
               loader.load(node.urlRequest,loaderContext);
               this.activeRequests.push(node);
            }
         }
      }
      
      public function removeAllQueueEntries() : void
      {
         var current:QueueEntryNode = null;
         this.requeueActive(true);
         if(this.enableCaching)
         {
            current = this.requestQueue.head as QueueEntryNode;
            while(Boolean(current))
            {
               this.removeCacheEntry(current.urlRequest.url);
               current = current.next as QueueEntryNode;
            }
         }
         this.requestQueue = new LinkedList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function shiftPriority() : void
      {
         var candidate:QueueEntryNode = null;
         var current:QueueEntryNode = this.requestQueue.tail as QueueEntryNode;
         var prioritizedNodes:LinkedList = new LinkedList();
         this.requeueActive();
         while(Boolean(current))
         {
            candidate = current;
            current = current.prev as QueueEntryNode;
            if(candidate.queueGroup == this.priorityGroup)
            {
               this.requestQueue.remove(candidate);
               prioritizedNodes.push(candidate);
            }
         }
         while(Boolean(prioritizedNodes.length))
         {
            current = prioritizedNodes.shift() as QueueEntryNode;
            this.requestQueue.unshift(current);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function requeueActive(requeueAll:Boolean = false) : void
      {
         var activeNode:QueueEntryNode = null;
         var current:QueueEntryNode = this.activeRequests.head as QueueEntryNode;
         while(Boolean(current))
         {
            activeNode = current;
            current = current.next as QueueEntryNode;
            if(activeNode.queueGroup != this.priorityGroup || requeueAll)
            {
               this.activeRequests.remove(activeNode);
               try
               {
                  Loader(activeNode.value).close();
               }
               catch(e:Error)
               {
               }
               finally
               {
                  this.requestQueue.unshift(activeNode);
               }
            }
         }
      }
      
      private function loader_completeHandler(e:Event) : void
      {
         var node:LinkedListNode = null;
         var loaderInfo:LoaderInfo = e.target as LoaderInfo;
         var cachedRequest:CacheEntryNode = this.cacheEntries.find(loaderInfo) as CacheEntryNode;
         if(e.type == Event.COMPLETE && Boolean(loaderInfo))
         {
            if(Boolean(cachedRequest))
            {
               cachedRequest.complete = true;
               if(!loaderInfo.childAllowsParent)
               {
                  this.addCacheEntry(cachedRequest.source,UNTRUSTED);
                  dispatchEvent(new LoaderInvalidationEvent(LoaderInvalidationEvent.INVALIDATE_LOADER,loaderInfo));
               }
            }
         }
         else if(e.type == IOErrorEvent.IO_ERROR || e.type == SecurityErrorEvent.SECURITY_ERROR)
         {
            if(Boolean(cachedRequest))
            {
               this.removeCacheEntry(cachedRequest.source);
            }
         }
         if(this.activeRequests.length > 0 || this.requestQueue.length > 0)
         {
            node = this.activeRequests.remove(loaderInfo.loader);
            this.processQueue();
         }
         loaderInfo.removeEventListener(Event.COMPLETE,this.loader_completeHandler);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_completeHandler);
         loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_completeHandler);
      }
   }
}

import flash.display.Loader;
import flash.net.URLRequest;
import mx.utils.LinkedListNode;

class CacheEntryNode extends LinkedListNode
{
   
   public var source:Object;
   
   public var complete:Boolean = true;
   
   public function CacheEntryNode(source:Object, value:Object, queueGroup:String = null)
   {
      super(value);
      this.source = source;
   }
}

class QueueEntryNode extends LinkedListNode
{
   
   public var urlRequest:URLRequest;
   
   public var queueGroup:String;
   
   public function QueueEntryNode(urlRequest:URLRequest, loader:Loader, queueGroup:String)
   {
      super(loader);
      this.urlRequest = urlRequest;
      this.queueGroup = queueGroup;
   }
}
