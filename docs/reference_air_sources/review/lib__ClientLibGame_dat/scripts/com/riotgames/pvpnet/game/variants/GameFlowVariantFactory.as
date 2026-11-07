package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.common.GeneratedContentLoader;
   import com.riotgames.platform.gameclient.domain.featuredgame.FeaturedGameDefinition;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public class GameFlowVariantFactory
   {
      
      private static var _instance:GameFlowVariantFactory;
      
      private var INVARIANT:GameFlowVariant = new StandardGameFlowVariant();
      
      private var gameKeys:Dictionary;
      
      private var variants:Dictionary;
      
      public function GameFlowVariantFactory()
      {
         super();
      }
      
      public static function get instance() : GameFlowVariantFactory
      {
         if(_instance == null)
         {
            _instance = new GameFlowVariantFactory();
            _instance.initializeGameKeys();
            _instance.initializeVariants();
            _instance.addFeaturedVariants();
         }
         return _instance;
      }
      
      private function initializeGameKeys() : void
      {
         this.gameKeys = new Dictionary();
         this.gameKeys["asc"] = new AscensionGameFlowVariant();
         this.gameKeys["fbl"] = new FirstBloodGameFlowVariant();
         this.gameKeys["nbots"] = new NightmareBotsGameFlowVariant();
         this.gameKeys["ofa"] = new OneForAllGameFlowVariant();
         this.gameKeys["ofax"] = new OneForAllXGameFlowVariant();
         this.gameKeys["ppp"] = new PPPGameFlowVariant();
         this.gameKeys["tt6"] = new HexakillGameFlowVariant();
         this.gameKeys["tagteam"] = new FeaturedGameFlowVariant();
         this.gameKeys["urf"] = new UrfGameFlowVariant();
      }
      
      private function initializeVariants() : void
      {
         this.variants = new Dictionary();
         this.variants[GameMode.DOMINION] = new DominionGameFlowVariant();
         this.variants[GameMode.ARAM] = new ARAMGameFlowVariant();
      }
      
      public function getVariantForGameKey(param1:String) : GameFlowVariant
      {
         var _loc2_:GameFlowVariant = this.gameKeys[param1] as GameFlowVariant;
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         return this.INVARIANT;
      }
      
      public function getVariant(param1:Object, param2:String) : GameFlowVariant
      {
         var _loc3_:ArrayCollection = this.getGameMutators(param1);
         var _loc4_:GameFlowVariant = this.findVariantForMutator(_loc3_,param2);
         BaseGameFlowVariant(_loc4_).initializeContext(_loc3_,param2);
         return _loc4_;
      }
      
      private function getGameMutators(param1:Object) : ArrayCollection
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1 is ArrayCollection)
         {
            return param1 as ArrayCollection;
         }
         if(param1 is Array)
         {
            return new ArrayCollection(param1 as Array);
         }
         if(param1 is String)
         {
            return new ArrayCollection([param1]);
         }
         return null;
      }
      
      private function findVariantForMutator(param1:ArrayCollection, param2:String) : GameFlowVariant
      {
         var _loc4_:String = null;
         var _loc3_:GameFlowVariant = null;
         for each(_loc4_ in param1)
         {
            if(this.variants[_loc4_] != null)
            {
               _loc3_ = this.variants[_loc4_];
               break;
            }
         }
         if(_loc3_ == null)
         {
            if(this.variants[param2] != null)
            {
               _loc3_ = this.variants[param2];
            }
         }
         if(_loc3_ == null)
         {
            _loc3_ = this.INVARIANT;
         }
         return _loc3_;
      }
      
      private function addFeaturedVariants() : void
      {
         var _loc2_:FeaturedGameDefinition = null;
         var _loc3_:FeaturedGameFlowVariant = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:Array = GeneratedContentLoader.instance.featuredGameDefinitions;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = this.gameKeys[_loc2_.key] as FeaturedGameFlowVariant;
            if(_loc3_ != null)
            {
               _loc4_ = _loc2_.gameMode;
               _loc5_ = _loc2_.gameMutators != null ? _loc2_.gameMutators[0] : null;
               _loc3_.initializeKey(_loc2_.key,_loc4_,_loc5_);
               this.variants[_loc3_.key] = _loc3_;
            }
         }
      }
   }
}

