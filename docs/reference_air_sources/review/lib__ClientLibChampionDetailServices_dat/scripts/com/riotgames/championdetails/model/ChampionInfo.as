package com.riotgames.championdetails.model
{
   import com.riotgames.gameItems.model.RecommendedItem;
   import com.riotgames.store.model.ChampionSearchTag;
   
   public class ChampionInfo
   {
      
      public var armorBase:Number;
      
      public var armorLevel:Number;
      
      public var attackBase:Number;
      
      public var attackLevel:Number;
      
      public var criticalChanceBase:Number;
      
      public var criticalChanceLevel:Number;
      
      public var description:String;
      
      public var displayName:String;
      
      public var healthBase:Number;
      
      public var healthLevel:Number;
      
      public var healthRegenBase:Number;
      
      public var healthRegenLevel:Number;
      
      public var iconPath:String;
      
      public var id:uint;
      
      public var magicResistBase:Number;
      
      public var magicResistLevel:Number;
      
      public var manaBase:Number;
      
      public var manaLevel:Number;
      
      public var manaRegenBase:Number;
      
      public var manaRegenLevel:Number;
      
      public var moveSpeed:uint;
      
      public var name:String;
      
      public var opponentTips:String;
      
      public var portraitPath:String;
      
      public var quote:String;
      
      public var quoteAuthor:String;
      
      public var range:Number;
      
      public var ratingAttack:Number;
      
      public var ratingDefense:Number;
      
      public var ratingDifficulty:Number;
      
      public var ratingMagic:Number;
      
      public var splashPath:String;
      
      public var tips:String;
      
      public var title:String;
      
      public var abilities:Vector.<ChampionAbility>;
      
      public var skins:Vector.<ChampionSkin>;
      
      public var recommendedItems:Vector.<RecommendedItem>;
      
      public var searchTags:Vector.<ChampionSearchTag>;
      
      public var secondaryTags:Vector.<ChampionSearchTag>;
      
      public function ChampionInfo()
      {
         super();
      }
      
      public function getTagsStr() : String
      {
         return this.championTagsToStr(this.searchTags);
      }
      
      public function getSecondaryTagsStr() : String
      {
         return this.championTagsToStr(this.secondaryTags);
      }
      
      private function championTagsToStr(param1:Vector.<ChampionSearchTag>) : String
      {
         var _loc3_:ChampionSearchTag = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         for each(_loc3_ in param1)
         {
            _loc2_[_loc2_.length] = _loc3_.displayName;
         }
         return _loc2_.join(", ");
      }
      
      public function getRecommendedItems(param1:String) : Vector.<RecommendedItem>
      {
         var gameMode:String = param1;
         return this.recommendedItems.filter(function(param1:RecommendedItem, param2:int, param3:Vector.<RecommendedItem>):Boolean
         {
            return param1.gameMode == gameMode;
         });
      }
      
      public function getSkinById(param1:int) : ChampionSkin
      {
         var _loc2_:ChampionSkin = null;
         for each(_loc2_ in this.skins)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function toString() : String
      {
         return "[ChampionInfo name=\'" + this.name + "\']";
      }
   }
}

