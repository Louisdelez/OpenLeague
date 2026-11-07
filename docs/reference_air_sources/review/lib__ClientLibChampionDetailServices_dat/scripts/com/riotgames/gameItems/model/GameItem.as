package com.riotgames.gameItems.model
{
   import flash.utils.Dictionary;
   
   public class GameItem
   {
      
      public static const DATA_FORMAT:String = "gameItemData";
      
      public var id:uint;
      
      public var name:String;
      
      public var description:String;
      
      public var icon:String;
      
      public var price:int;
      
      public var sellPrice:int;
      
      public var totalPrice:int;
      
      public var canBeSold:Boolean;
      
      public var consumed:Boolean;
      
      public var stacks:int;
      
      public var inStore:Boolean;
      
      public var hideFromAll:Boolean;
      
      public var specialRecipe:int;
      
      public var usableInStore:Boolean;
      
      public var requiredChampion:String;
      
      public var depth:int;
      
      public var flatHPPoolMod:Number;
      
      public var percentHPPoolMod:Number;
      
      public var flatMPPoolMod:Number;
      
      public var percentMPPoolMod:Number;
      
      public var flatHPRegenMod:Number;
      
      public var percentHPRegenMod:Number;
      
      public var flatMPRegenMod:Number;
      
      public var percentMPRegenMod:Number;
      
      public var flatArmorMod:Number;
      
      public var percentArmorMod:Number;
      
      public var flatPhysicalDamageMod:Number;
      
      public var percentPhysicalDamageMod:Number;
      
      public var flatMagicDamageMod:Number;
      
      public var percentMagicDamageMod:Number;
      
      public var flatMovementSpeedMod:Number;
      
      public var percentMovementSpeedMod:Number;
      
      public var flatAttackSpeedMod:Number;
      
      public var percentAttackSpeedMod:Number;
      
      public var flatDodgeMod:Number;
      
      public var percentDodgeMod:Number;
      
      public var flatCritChanceMod:Number;
      
      public var percentCritChanceMod:Number;
      
      public var flatCritDamageMod:Number;
      
      public var percentCritDamageMod:Number;
      
      public var flatBlockMod:Number;
      
      public var percentBlockMod:Number;
      
      public var flatSpellBlockMod:Number;
      
      public var percentSpellBlockMod:Number;
      
      public var flatEXPBonus:Number;
      
      public var percentEXPBonus:Number;
      
      public var aliases:Vector.<String> = new Vector.<String>();
      
      public var restrictedMapIDs:Vector.<int> = new Vector.<int>();
      
      public var buildsTo:Vector.<GameItem> = new Vector.<GameItem>();
      
      public var recipeItems:Vector.<GameItem> = new Vector.<GameItem>();
      
      private var _tags:Vector.<ItemTag> = new Vector.<ItemTag>();
      
      private var tagCache:Dictionary = new Dictionary(true);
      
      public function GameItem()
      {
         super();
      }
      
      public function isInCategory(param1:String) : Boolean
      {
         var _loc2_:ItemTag = null;
         if(this.tagCache[param1] === undefined)
         {
            this.tagCache[param1] = false;
            for each(_loc2_ in this.tags)
            {
               if(_loc2_.tag === param1)
               {
                  this.tagCache[param1] = true;
                  break;
               }
            }
         }
         return this.tagCache[param1];
      }
      
      public function toString() : String
      {
         return "[GameItem name=\'" + this.name + "\']";
      }
      
      public function get tags() : Vector.<ItemTag>
      {
         return this._tags;
      }
      
      public function set tags(param1:Vector.<ItemTag>) : void
      {
         this.tagCache = new Dictionary(true);
         this._tags = param1;
      }
   }
}

