package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ChampionSkinController
   {
      
      private var selectSkinTimeoutId:int = 0;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var requestedSkin:ChampionSkin = null;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var championIdToLastSkinMap:Dictionary;
      
      private var lastPlayedSkin:ChampionSkin = null;
      
      private var _playerSelection:PlayerSelection;
      
      private var commandFactory:IChampionSelectionCommandFactory;
      
      public function ChampionSkinController(param1:ChampionSelectionModel, param2:IChampionSelectionCommandFactory)
      {
         super();
         this.championSelectionModel = param1;
         this.playerSelection = param1.currentPlayerSelection;
         this.commandFactory = param2;
      }
      
      private function isSkinSelected(param1:ChampionSkin) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.lastSelected == true)
         {
            return true;
         }
         if(this.requestedSkin == param1)
         {
            return true;
         }
         return false;
      }
      
      private function onUseSkinSuccess(param1:Object) : void
      {
         this.lastPlayedSkin = this.requestedSkin;
         this.playerSelection.selectedSkin = this.lastPlayedSkin;
         this.recordSkinSelection(param1 as ChampionSkin);
      }
      
      protected function removePlayerSelection() : void
      {
         if(Boolean(this._playerSelection))
         {
            this._playerSelection.removeEventListener("championChanged",this.onChampionChanged);
         }
      }
      
      protected function selectSkin() : void
      {
         var _loc1_:ICommand = this.commandFactory.getSkinSelectCommand(this.championSelectionModel,this.requestedSkin);
         _loc1_.addResponder(this.onUseSkinSuccess);
         _loc1_.execute();
      }
      
      public function set playerSelection(param1:PlayerSelection) : void
      {
         if(this._playerSelection == param1)
         {
            return;
         }
         this.removePlayerSelection();
         this._playerSelection = param1;
         this.setPlayerSelection();
      }
      
      public function useSkin(param1:ChampionSkin) : void
      {
         var _loc2_:ICommand = this.commandFactory.getPlaySoundCommand(AudioKeys.NEW_SOUND_SKIN_SCROLL);
         _loc2_.execute();
         if(this.selectSkinTimeoutId > 0)
         {
            clearTimeout(this.selectSkinTimeoutId);
            this.selectSkinTimeoutId = 0;
         }
         this.requestedSkin = null;
         var _loc3_:Boolean = this.championSelectionModel.allSkinsRentalUnlock || Boolean(param1.isAvailable());
         if(!_loc3_ || Boolean(param1.skinDisabled) || this.isSkinSelected(param1))
         {
            return;
         }
         this.selectSkinTimeoutId = setTimeout(this.selectSkin,750);
         if(this.selectSkinTimeoutId > 0)
         {
            this.requestedSkin = param1;
         }
      }
      
      private function updateSkin() : void
      {
         if(Boolean(this.playerSelection) && !this.playerSelection.champion)
         {
            this.playerSelection.selectedSkin = null;
            return;
         }
         this.lastPlayedSkin = this.playerSelection.champion.getCurrentChampionSkin();
         if((Boolean(this.lastPlayedSkin.isOwned()) || Boolean(this.lastPlayedSkin.isAvailable())) && !this.lastPlayedSkin.skinDisabled)
         {
            this.playerSelection.selectedSkin = this.lastPlayedSkin;
         }
         else
         {
            this.lastPlayedSkin.lastSelected = false;
            this.lastPlayedSkin = this.playerSelection.champion.defaultSkin;
            this.lastPlayedSkin.lastSelected = true;
            this.playerSelection.selectedSkin = this.lastPlayedSkin;
         }
         this.recordSkinSelection(this.lastPlayedSkin);
      }
      
      private function setPlayerSelection() : void
      {
         if(!this.playerSelection)
         {
            this.lastPlayedSkin = null;
         }
         else
         {
            this.updateSkin();
         }
         if(Boolean(this.playerSelection))
         {
            this.playerSelection.addEventListener("championChanged",this.onChampionChanged,false,0,true);
         }
      }
      
      public function get playerSelection() : PlayerSelection
      {
         return this._playerSelection;
      }
      
      protected function onChampionChanged(param1:Event) : void
      {
         this.setPlayerSelection();
      }
      
      private function restoreSkinSelections() : void
      {
         var _loc1_:ChampionSkin = null;
         if(this.championSelectionModel.allSkinsRentalUnlock && this.championIdToLastSkinMap != null)
         {
            for each(_loc1_ in this.championIdToLastSkinMap)
            {
               if(_loc1_.getChampion() != null)
               {
                  _loc1_.getChampion().setCurrentChampionSkin(_loc1_.skinId);
               }
            }
         }
         this.championIdToLastSkinMap = null;
      }
      
      private function recordSkinSelection(param1:ChampionSkin) : void
      {
         if(param1 != null && !this.championSelectionModel.allSkinsRentalUnlock)
         {
            if(this.championIdToLastSkinMap == null)
            {
               this.championIdToLastSkinMap = new Dictionary();
            }
            this.championIdToLastSkinMap[param1.championId] = param1;
         }
      }
      
      public function cleanup() : void
      {
         this.restoreSkinSelections();
      }
   }
}

