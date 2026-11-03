package com.riotgames.platform.gameclient.domain
{
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   
   [RemoteClass(alias="com.riotgames.platform.game.BotParticipant")]
   public class BotParticipant extends GameParticipant
   {
      
      public static const BOT_ID_PREFIX:String = "bot";
      
      public static const SEPARATOR:String = "_";
      
      public static const SKILL_LEVEL_EASY:int = 0;
      
      public static const SKILL_LEVEL_MEDIUM:int = 1;
      
      public static const SKILL_LEVEL_HARD:int = 2;
      
      public static const SKILL_LEVEL_UBER:int = 3;
      
      public static const SKILL_LEVEL_TUTORIAL:int = 4;
      
      public static const SKILL_LEVEL_INTRO:int = 5;
      
      private var _1431766121champion:Champion;
      
      private var _1852418693botSkillLevelName:String;
      
      private var _teamId:String;
      
      private var _botSkillLevel:Number;
      
      public function BotParticipant(param1:Champion = null)
      {
         super();
         this.champion = param1;
         this.updateInternalName();
      }
      
      public function get botSkillLevel() : Number
      {
         return this._botSkillLevel;
      }
      
      private function set _245319462botSkillLevel(param1:Number) : void
      {
         this._botSkillLevel = param1;
         switch(param1)
         {
            case SKILL_LEVEL_EASY:
               this.botSkillLevelName = ResourceManager.getInstance().getString("resources","bot_difficulty_easy");
               break;
            case SKILL_LEVEL_MEDIUM:
               this.botSkillLevelName = ResourceManager.getInstance().getString("resources","bot_difficulty_medium");
               break;
            case SKILL_LEVEL_HARD:
               this.botSkillLevelName = ResourceManager.getInstance().getString("resources","bot_difficulty_hard");
               break;
            case SKILL_LEVEL_INTRO:
               this.botSkillLevelName = ResourceManager.getInstance().getString("resources","bot_difficulty_intro");
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get botSkillLevelName() : String
      {
         return this._1852418693botSkillLevelName;
      }
      
      [Bindable(event="propertyChange")]
      public function set teamId(param1:String) : void
      {
         var _loc2_:Object = this.teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      public function getChampionName() : String
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(summonerInternalName != null)
         {
            _loc2_ = summonerInternalName.indexOf(SEPARATOR);
            _loc1_ = summonerInternalName.substring(_loc2_ + 1,summonerInternalName.indexOf(SEPARATOR,_loc2_ + 1));
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get champion() : Champion
      {
         return this._1431766121champion;
      }
      
      public function updateInternalName() : void
      {
         if(this.champion == null)
         {
            return;
         }
         summonerName = this.champion.skinName + " bot";
         summonerInternalName = this.getInternalName();
      }
      
      private function set _877713320teamId(param1:String) : void
      {
         this._teamId = param1;
         this.updateInternalName();
      }
      
      [Bindable(event="propertyChange")]
      public function set botSkillLevel(param1:Number) : void
      {
         var _loc2_:Object = this.botSkillLevel;
         if(_loc2_ !== param1)
         {
            this._245319462botSkillLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botSkillLevel",_loc2_,param1));
         }
      }
      
      public function get teamId() : String
      {
         return this._teamId;
      }
      
      public function set botSkillLevelName(param1:String) : void
      {
         var _loc2_:Object = this._1852418693botSkillLevelName;
         if(_loc2_ !== param1)
         {
            this._1852418693botSkillLevelName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botSkillLevelName",_loc2_,param1));
         }
      }
      
      public function getInternalName() : String
      {
         return BOT_ID_PREFIX + SEPARATOR + this.champion.skinName + SEPARATOR + this.teamId;
      }
      
      public function set champion(param1:Champion) : void
      {
         var _loc2_:Object = this._1431766121champion;
         if(_loc2_ !== param1)
         {
            this._1431766121champion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champion",_loc2_,param1));
         }
      }
   }
}

