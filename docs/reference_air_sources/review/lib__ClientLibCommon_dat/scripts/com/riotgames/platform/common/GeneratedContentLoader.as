package com.riotgames.platform.common
{
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.GameItem;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.featuredgame.FeaturedGameDefinition;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class GeneratedContentLoader
   {
      
      private static var _instance:GeneratedContentLoader;
      
      private static const GENERATED_CONTENT_SWF:String = "/assets/swfs/AirGeneratedContent.swf";
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _championDataAvailable:Signal = new OnceSignal();
      
      private var loader:Loader;
      
      private var _mapDataAvailable:Signal = new Signal();
      
      public var spellDictionary:Dictionary;
      
      public var championCount:int;
      
      public var championDataDictionary:Dictionary;
      
      public var championSearchTagsSecondary:Array;
      
      public var mapData:ArrayCollection;
      
      public var featuredGameDefinitions:Array;
      
      public var runeDictionary:Dictionary;
      
      public var championSearchTags:Array;
      
      public var gameItemData:Dictionary;
      
      private var _loadCallback:Function;
      
      public function GeneratedContentLoader()
      {
         super();
         this.loader = new Loader();
      }
      
      public static function get instance() : GeneratedContentLoader
      {
         if(_instance == null)
         {
            _instance = new GeneratedContentLoader();
         }
         return _instance;
      }
      
      private function loadMapData(param1:Dictionary) : void
      {
         var _loc3_:Object = null;
         var _loc4_:GameMap = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in param1)
         {
            _loc4_ = new GameMap();
            _loc4_.mapId = _loc3_.mapId;
            _loc4_.name = _loc3_.name;
            _loc4_.displayName = RiotResourceLoader.getMapResourceString("displayname",_loc4_.mapId,_loc4_.name);
            _loc4_.description = RiotResourceLoader.getMapResourceString("description",_loc4_.mapId,_loc4_.name);
            _loc4_.totalPlayers = _loc3_.totalPlayers;
            _loc2_.addItem(_loc4_);
         }
         this.mapData = _loc2_;
         this._mapDataAvailable.dispatch();
      }
      
      public function getMapDataAvailable() : ISignal
      {
         return this._mapDataAvailable;
      }
      
      private function loadRuneData(param1:Dictionary) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Rune = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            _loc4_ = new Rune(_loc3_);
            _loc4_.displayName = RiotResourceLoader.getItemResourceString("name",_loc4_.itemId,"**" + _loc4_.itemId.toString());
            _loc4_.displayDescription = RiotResourceLoader.getItemResourceString("description",_loc4_.itemId,"**" + _loc4_.itemId.toString() + "_desc");
            _loc2_[_loc4_.itemId] = _loc4_;
         }
         this.runeDictionary = _loc2_;
      }
      
      private function loadGameItemData(param1:Dictionary) : void
      {
         var _loc3_:Object = null;
         var _loc4_:GameItem = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            _loc4_ = new GameItem(_loc3_);
            _loc4_.displayName = RiotResourceLoader.getItemResourceString("name",_loc4_.gameCode,"**" + _loc4_.gameCode.toString());
            _loc4_.displayDescription = RiotResourceLoader.getItemResourceString("description",_loc4_.gameCode,"**" + _loc4_.gameCode.toString() + "_desc");
            _loc2_[_loc4_.itemId] = _loc4_;
         }
         this.gameItemData = _loc2_;
      }
      
      private function loadChampionData(param1:Object) : void
      {
         this.championSearchTags = param1.championSearchTags;
         if(param1.hasOwnProperty("championSearchTagsSecondary"))
         {
            this.championSearchTagsSecondary = param1.championSearchTagsSecondary;
         }
         this.championCount = param1.championCount;
         this.championDataDictionary = param1.champions;
         this._championDataAvailable.dispatch(this);
      }
      
      private function handleSwfLoaded(param1:Event) : void
      {
         var _loc2_:Class = ApplicationDomain.currentDomain.getDefinition("com.riotgames.platform.gameclient.domain.ChampionGeneratedData") as Class;
         var _loc3_:Class = ApplicationDomain.currentDomain.getDefinition("com.riotgames.platform.gameclient.domain.GameItemGeneratedData") as Class;
         var _loc4_:Class = ApplicationDomain.currentDomain.getDefinition("com.riotgames.platform.gameclient.domain.RuneGeneratedData") as Class;
         var _loc5_:Class = ApplicationDomain.currentDomain.getDefinition("com.riotgames.platform.gameclient.domain.SpellGeneratedData") as Class;
         var _loc6_:Class = ApplicationDomain.currentDomain.getDefinition("com.riotgames.platform.gameclient.domain.MapGeneratedData") as Class;
         var _loc7_:Class = ApplicationDomain.currentDomain.getDefinition("com.riotgames.platform.gameclient.domain.FeaturedGameGeneratedData") as Class;
         var _loc8_:Object = new _loc3_();
         var _loc9_:Object = new _loc5_();
         var _loc10_:Object = new _loc4_();
         var _loc11_:Object = new _loc2_();
         var _loc12_:Object = new _loc6_();
         var _loc13_:Object = new _loc7_();
         this.loadGameItemData(_loc8_.gameItems);
         this.loadSpellData(_loc9_.spells);
         this.loadRuneData(_loc10_.runes);
         this.loadChampionData(_loc11_);
         this.loadMapData(_loc12_.maps);
         this.loadFeaturedGameData(_loc13_.featuredGames);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleSwfLoaded);
         if(this._loadCallback != null)
         {
            this._loadCallback.apply();
            this._loadCallback = null;
         }
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         this.logger.fatal("handleIOError Content initialization failed on " + GENERATED_CONTENT_SWF + " becasue " + param1.toString());
         throw new Error("GeneratedContentLoader failed to load " + GENERATED_CONTENT_SWF + " because " + param1.toString());
      }
      
      private function loadFeaturedGameData(param1:Dictionary) : void
      {
         var _loc3_:Object = null;
         var _loc4_:FeaturedGameDefinition = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc4_ = new FeaturedGameDefinition();
            _loc4_.key = _loc3_.key;
            _loc4_.gameMode = _loc3_.gameMode;
            _loc4_.gameMutators = _loc3_.gameMutators;
            _loc2_.push(_loc4_);
         }
         this.featuredGameDefinitions = _loc2_;
      }
      
      private function loadSpellData(param1:Dictionary) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.spellId] = new Spell(_loc3_);
         }
         this.spellDictionary = _loc2_;
      }
      
      public function getChampionDataAvailable() : ISignal
      {
         return this._championDataAvailable;
      }
      
      public function load(param1:Function = null) : void
      {
         var context:LoaderContext;
         var request:URLRequest;
         var callback:Function = param1;
         this._loadCallback = callback;
         request = new URLRequest(GENERATED_CONTENT_SWF);
         context = new LoaderContext();
         context.applicationDomain = ApplicationDomain.currentDomain;
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleSwfLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         try
         {
            this.loader.load(request,context);
         }
         catch(e:Error)
         {
            logger.fatal("handleIOError Content initialization failed on " + GENERATED_CONTENT_SWF + " becasue " + e.toString());
            throw new Error("GeneratedContentLoader failed to load " + GENERATED_CONTENT_SWF + " because " + e.toString());
         }
      }
   }
}

