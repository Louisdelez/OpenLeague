package mx.collections
{
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.IXMLNotifiable;
   import mx.utils.UIDUtil;
   import mx.utils.XMLNotifier;
   
   use namespace mx_internal;
   
   [ResourceBundle("collections")]
   [ExcludeClass]
   [Event(name="collectionChange",type="mx.events.CollectionEvent")]
   public class XMLListAdapter extends EventDispatcher implements IList, IXMLNotifiable
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _source:XMLList;
      
      private var _dispatchEvents:int = 0;
      
      private var _busy:int = 0;
      
      private var seedUID:String;
      
      private var uidCounter:int = 0;
      
      public function XMLListAdapter(source:XMLList = null)
      {
         super();
         this.disableEvents();
         this.source = source;
         this.enableEvents();
      }
      
      public function get length() : int
      {
         return this.source.length();
      }
      
      public function get source() : XMLList
      {
         return this._source;
      }
      
      public function set source(s:XMLList) : void
      {
         var i:int = 0;
         var len:int = 0;
         var event:CollectionEvent = null;
         if(Boolean(this._source) && Boolean(this._source.length()))
         {
            len = this._source.length();
            for(i = 0; i < len; i++)
            {
               this.stopTrackUpdates(this._source[i]);
            }
         }
         this._source = Boolean(s) ? s : XMLList(new XMLList(""));
         this.seedUID = UIDUtil.createUID();
         this.uidCounter = 0;
         len = this._source.length();
         for(i = 0; i < len; i++)
         {
            this.startTrackUpdates(this._source[i],this.seedUID + this.uidCounter.toString());
            ++this.uidCounter;
         }
         if(this._dispatchEvents == 0)
         {
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.RESET;
            dispatchEvent(event);
         }
      }
      
      public function addItem(item:Object) : void
      {
         this.addItemAt(item,this.length);
      }
      
      public function addItemAt(item:Object, index:int) : void
      {
         var message:String = null;
         var event:CollectionEvent = null;
         if(index < 0 || index > this.length)
         {
            message = this.resourceManager.getString("collections","outOfBounds",[index]);
            throw new RangeError(message);
         }
         if(!(item is XML) && !(item is XMLList && item.length() == 1))
         {
            message = this.resourceManager.getString("collections","invalidType");
            throw new Error(message);
         }
         this.setBusy();
         if(index == 0)
         {
            this.source[0] = this.length > 0 ? item + this.source[0] : item;
         }
         else
         {
            this.source[index - 1] += item;
         }
         this.startTrackUpdates(item,this.seedUID + this.uidCounter.toString());
         ++this.uidCounter;
         if(this._dispatchEvents == 0)
         {
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.ADD;
            event.items.push(item);
            event.location = index;
            dispatchEvent(event);
         }
         this.clearBusy();
      }
      
      public function getItemAt(index:int, prefetch:int = 0) : Object
      {
         var message:String = null;
         if(index < 0 || index >= this.length)
         {
            message = this.resourceManager.getString("collections","outOfBounds",[index]);
            throw new RangeError(message);
         }
         return this.source[index];
      }
      
      public function getItemIndex(item:Object) : int
      {
         var len:int = 0;
         var i:int = 0;
         var search:Object = null;
         if(item is XML && this.source.contains(XML(item)))
         {
            len = this.length;
            for(i = 0; i < len; i++)
            {
               search = this.source[i];
               if(search === item)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null) : void
      {
         var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         event.kind = PropertyChangeEventKind.UPDATE;
         event.source = item;
         event.property = property;
         event.oldValue = oldValue;
         event.newValue = newValue;
         this.itemUpdateHandler(event);
      }
      
      public function removeAll() : void
      {
         var i:int = 0;
         var event:CollectionEvent = null;
         if(this.length > 0)
         {
            for(i = this.length - 1; i >= 0; i--)
            {
               this.stopTrackUpdates(this.source[i]);
               delete this.source[i];
            }
            if(this._dispatchEvents == 0)
            {
               event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
               event.kind = CollectionEventKind.RESET;
               dispatchEvent(event);
            }
         }
      }
      
      public function removeItemAt(index:int) : Object
      {
         var message:String = null;
         var event:CollectionEvent = null;
         if(index < 0 || index >= this.length)
         {
            message = this.resourceManager.getString("collections","outOfBounds",[index]);
            throw new RangeError(message);
         }
         this.setBusy();
         var removed:Object = this.source[index];
         delete this.source[index];
         this.stopTrackUpdates(removed);
         if(this._dispatchEvents == 0)
         {
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.REMOVE;
            event.location = index;
            event.items.push(removed);
            dispatchEvent(event);
         }
         this.clearBusy();
         return removed;
      }
      
      public function setItemAt(item:Object, index:int) : Object
      {
         var message:String = null;
         var event:CollectionEvent = null;
         var updateInfo:PropertyChangeEvent = null;
         if(index < 0 || index >= this.length)
         {
            message = this.resourceManager.getString("collections","outOfBounds",[index]);
            throw new RangeError(message);
         }
         var oldItem:Object = this.source[index];
         this.source[index] = item;
         this.stopTrackUpdates(oldItem);
         this.startTrackUpdates(item,this.seedUID + this.uidCounter.toString());
         ++this.uidCounter;
         if(this._dispatchEvents == 0)
         {
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.REPLACE;
            updateInfo = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            updateInfo.kind = PropertyChangeEventKind.UPDATE;
            updateInfo.oldValue = oldItem;
            updateInfo.newValue = item;
            event.location = index;
            event.items.push(updateInfo);
            dispatchEvent(event);
         }
         return oldItem;
      }
      
      public function toArray() : Array
      {
         var s:XMLList = this.source;
         var len:int = s.length();
         var ret:Array = [];
         for(var i:int = 0; i < len; i++)
         {
            ret[i] = s[i];
         }
         return ret;
      }
      
      override public function toString() : String
      {
         if(Boolean(this.source))
         {
            return this.source.toString();
         }
         return getQualifiedClassName(this);
      }
      
      public function busy() : Boolean
      {
         return this._busy != 0;
      }
      
      protected function enableEvents() : void
      {
         ++this._dispatchEvents;
         if(this._dispatchEvents > 0)
         {
            this._dispatchEvents = 0;
         }
      }
      
      protected function disableEvents() : void
      {
         --this._dispatchEvents;
      }
      
      private function clearBusy() : void
      {
         ++this._busy;
         if(this._busy > 0)
         {
            this._busy = 0;
         }
      }
      
      private function setBusy() : void
      {
         --this._busy;
      }
      
      protected function itemUpdateHandler(event:PropertyChangeEvent) : void
      {
         var updateEvent:CollectionEvent = null;
         if(this._dispatchEvents == 0)
         {
            updateEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            updateEvent.kind = CollectionEventKind.UPDATE;
            updateEvent.items.push(event);
            dispatchEvent(updateEvent);
         }
      }
      
      public function xmlNotification(currentTarget:Object, type:String, target:Object, value:Object, detail:Object) : void
      {
         var prop:String = null;
         var oldValue:Object = null;
         var newValue:Object = null;
         var par:* = undefined;
         var gpar:* = undefined;
         if(currentTarget === target)
         {
            switch(type)
            {
               case "attributeAdded":
                  prop = "@" + String(value);
                  newValue = detail;
                  break;
               case "attributeChanged":
                  prop = "@" + String(value);
                  oldValue = detail;
                  newValue = target[prop];
                  break;
               case "attributeRemoved":
                  prop = "@" + String(value);
                  oldValue = detail;
                  break;
               case "nodeAdded":
                  prop = value.localName();
                  newValue = value;
                  break;
               case "nodeChanged":
                  prop = value.localName();
                  oldValue = detail;
                  newValue = value;
                  break;
               case "nodeRemoved":
                  prop = value.localName();
                  oldValue = value;
                  break;
               case "textSet":
                  prop = String(value);
                  newValue = String(target[prop]);
                  oldValue = detail;
            }
         }
         else if(type == "textSet")
         {
            par = target.parent();
            if(par != undefined)
            {
               gpar = par.parent();
               if(gpar === currentTarget)
               {
                  prop = par.name().toString();
                  newValue = value;
                  oldValue = detail;
               }
            }
         }
         this.itemUpdated(currentTarget,prop,oldValue,newValue);
      }
      
      protected function startTrackUpdates(item:Object, uid:String) : void
      {
         XMLNotifier.getInstance().watchXML(item,this,uid);
      }
      
      protected function stopTrackUpdates(item:Object) : void
      {
         XMLNotifier.getInstance().unwatchXML(item,this);
      }
   }
}

