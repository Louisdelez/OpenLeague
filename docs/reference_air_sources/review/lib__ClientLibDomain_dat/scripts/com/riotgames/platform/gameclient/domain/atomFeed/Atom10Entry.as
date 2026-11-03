package com.riotgames.platform.gameclient.domain.atomFeed
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class Atom10Entry implements IEventDispatcher
   {
      
      private var _110371416title:String;
      
      private var _2060497896subtitle:String;
      
      private var _389131437contentType:String;
      
      private var _3355id:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1825054470thumbnailLink:Atom10Link;
      
      private var _102977465links:ArrayCollection;
      
      private var _1857640538summary:String;
      
      private var _951530617content:String;
      
      private var _570265847updatedDate:Date;
      
      public function Atom10Entry()
      {
         super();
      }
      
      public static function parseFromXML(param1:XML) : Atom10Entry
      {
         var defaultNamespace:Namespace = null;
         var entry:Atom10Entry = null;
         var dateString:String = null;
         var year:String = null;
         var month:String = null;
         var day:String = null;
         var hours:String = null;
         var minutes:String = null;
         var seconds:String = null;
         var links:XMLList = null;
         var linksList:XMLList = null;
         var linkXML:XML = null;
         var xml:XML = param1;
         defaultNamespace = xml.namespace();
         entry = new Atom10Entry();
         entry.id = xml.defaultNamespace::id;
         entry.title = xml.defaultNamespace::title;
         entry.subtitle = xml.defaultNamespace::subtitle;
         dateString = xml.defaultNamespace::updated;
         year = dateString.substring(0,4);
         month = dateString.substring(5,7);
         day = dateString.substring(8,10);
         hours = dateString.substring(11,13);
         minutes = dateString.substring(14,16);
         seconds = dateString.substring(17,19);
         entry.updatedDate = new Date(year,month,day,hours,minutes,seconds);
         entry.content = xml.defaultNamespace::content;
         entry.contentType = xml.defaultNamespace::content.defaultNamespace::@type;
         entry.summary = xml.defaultNamespace::summary;
         links = xml.defaultNamespace::link.(@rel == "thumbnail");
         if(links.length() > 0)
         {
            entry.thumbnailLink = Atom10Link.parseFromXML(links[0] as XML);
         }
         linksList = xml.defaultNamespace::link;
         entry.links = new ArrayCollection();
         for each(linkXML in linksList)
         {
            entry.links.addItem(Atom10Link.parseFromXML(linkXML));
         }
         return entry;
      }
      
      [Bindable(event="propertyChange")]
      public function set contentLinks(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.contentLinks;
         if(_loc2_ !== param1)
         {
            this._813960896contentLinks = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentLinks",_loc2_,param1));
         }
      }
      
      public function set links(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._102977465links;
         if(_loc2_ !== param1)
         {
            this._102977465links = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"links",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get thumbnailLink() : Atom10Link
      {
         return this._1825054470thumbnailLink;
      }
      
      [Bindable(event="propertyChange")]
      public function get updatedDate() : Date
      {
         return this._570265847updatedDate;
      }
      
      public function set thumbnailLink(param1:Atom10Link) : void
      {
         var _loc2_:Object = this._1825054470thumbnailLink;
         if(_loc2_ !== param1)
         {
            this._1825054470thumbnailLink = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thumbnailLink",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set updatedDate(param1:Date) : void
      {
         var _loc2_:Object = this._570265847updatedDate;
         if(_loc2_ !== param1)
         {
            this._570265847updatedDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"updatedDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subtitle() : String
      {
         return this._2060497896subtitle;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      public function set contentType(param1:String) : void
      {
         var _loc2_:Object = this._389131437contentType;
         if(_loc2_ !== param1)
         {
            this._389131437contentType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summary() : String
      {
         return this._1857640538summary;
      }
      
      public function set subtitle(param1:String) : void
      {
         var _loc2_:Object = this._2060497896subtitle;
         if(_loc2_ !== param1)
         {
            this._2060497896subtitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subtitle",_loc2_,param1));
         }
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get links() : ArrayCollection
      {
         return this._102977465links;
      }
      
      public function getLinkWithLabel(param1:String) : Atom10Link
      {
         var _loc3_:Atom10Link = null;
         var _loc2_:Atom10Link = null;
         for each(_loc3_ in this.links)
         {
            if(_loc3_.label == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function get contentLinks() : ArrayCollection
      {
         var _loc2_:Atom10Link = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.links)
         {
            if(_loc2_.rel != "thumbnail")
            {
               _loc1_.addItem(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function set _813960896contentLinks(param1:ArrayCollection) : void
      {
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set summary(param1:String) : void
      {
         var _loc2_:Object = this._1857640538summary;
         if(_loc2_ !== param1)
         {
            this._1857640538summary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summary",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get contentType() : String
      {
         return this._389131437contentType;
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      public function set content(param1:String) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : String
      {
         return this._951530617content;
      }
   }
}

