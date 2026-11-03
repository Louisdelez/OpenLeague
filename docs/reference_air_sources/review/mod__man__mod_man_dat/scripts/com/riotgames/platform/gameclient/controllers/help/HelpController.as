package com.riotgames.platform.gameclient.controllers.help
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class HelpController implements IEventDispatcher
   {
      
      public static var RUNES_HELP:String = "RUNES_HELP";
      
      public static var SPELLS_HELP:String = "SPELLS_HELP";
      
      public static var MASTERIES_HELP:String = "MASTERIES_HELP";
      
      public var initalized:Boolean = false;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.controllers.help.HelpController");
      
      private var _1245077445helpTopics:ArrayCollection;
      
      private var _729537403helpHeaderText:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function HelpController()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get helpHeaderText() : String
      {
         return this._729537403helpHeaderText;
      }
      
      private function onSaveSummonerComplete(param1:Boolean) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get helpTopics() : ArrayCollection
      {
         return this._1245077445helpTopics;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set helpTopics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1245077445helpTopics;
         if(_loc2_ !== param1)
         {
            this._1245077445helpTopics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpTopics",_loc2_,param1));
         }
      }
      
      private function addHelpTopic(param1:String, param2:String) : void
      {
         var _loc3_:int = param1.indexOf(File.lineEnding);
         var _loc4_:String = param1.substring(0,_loc3_);
         param1 = param1.substring(_loc3_ + 1);
         if(param2 == "General.help")
         {
            this.helpTopics.addItemAt({
               "label":_loc4_,
               "content":param1
            },0);
         }
         else
         {
            this.helpTopics.addItem({
               "label":_loc4_,
               "content":param1
            });
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function readHelpFile(param1:File, param2:String) : void
      {
         var _loc5_:String = null;
         var _loc3_:String = param1.nativePath;
         var _loc4_:FileStream = new FileStream();
         if(param1.exists)
         {
            _loc4_.open(param1,FileMode.READ);
            _loc5_ = _loc4_.readUTFBytes(_loc4_.bytesAvailable);
            this.addHelpTopic(_loc5_,param2);
            _loc4_.close();
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function saveHelpFlag() : void
      {
         Session.instance.summoner.helpFlag = true;
         ServiceProxy.instance.summonerService.saveSeenHelpFlag(this.onSaveSummoner,this.onSaveSummonerComplete);
      }
      
      public function initializeHelp() : void
      {
         if(this.initalized)
         {
            return;
         }
         this.helpHeaderText = ResourceManager.getInstance().getString("resources","helpHeader_Text");
         this.helpTopics = new ArrayCollection();
         this.loadHelpFiles();
         this.initalized = true;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set helpHeaderText(param1:String) : void
      {
         var _loc2_:Object = this._729537403helpHeaderText;
         if(_loc2_ !== param1)
         {
            this._729537403helpHeaderText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpHeaderText",_loc2_,param1));
         }
      }
      
      private function loadHelpFiles() : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc1_:String = ResourceManager.getInstance().getString("resources","helpDirectory_listing");
         var _loc2_:File = File.applicationDirectory.resolvePath(_loc1_);
         if(!_loc2_.exists)
         {
            return;
         }
         var _loc3_:Array = _loc2_.getDirectoryListing();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_].name;
            _loc6_ = _loc5_.indexOf(".help");
            if(_loc6_ > 0)
            {
               this.readHelpFile(_loc3_[_loc4_],_loc5_);
            }
            _loc4_++;
         }
      }
      
      private function onSaveSummoner(param1:ResultEvent) : void
      {
      }
   }
}

