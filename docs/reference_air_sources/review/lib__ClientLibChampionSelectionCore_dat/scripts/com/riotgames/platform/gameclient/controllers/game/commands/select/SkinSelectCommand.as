package com.riotgames.platform.gameclient.controllers.game.commands.select
{
   import com.riotgames.platform.gameclient.controllers.game.commands.*;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class SkinSelectCommand extends WaitCommand
   {
      
      private var gameService:GameService;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private const SKIN_WAIT_STRING:String = "serverWait_usingSkin";
      
      private var skin:ChampionSkin;
      
      public function SkinSelectCommand(param1:ChampionSelectionModel, param2:ChampionSkin, param3:GameService, param4:IResourceManager, param5:ICursorManager)
      {
         super(param4,param5);
         this.championSelectionModel = param1;
         this.skin = param2;
         this.gameService = param3;
      }
      
      override protected function logResult(param1:Object) : void
      {
      }
      
      override protected function logError(param1:Object) : void
      {
         if(param1.errorCode == "PG-0014")
         {
            return;
         }
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","championSelection_selectChampionErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         var _loc2_:ChampionSkin = this.skin.getChampion().getCurrentChampionSkin();
         if(_loc2_.skinId != this.skin.skinId)
         {
            _loc2_.lastSelected = false;
         }
         this.skin.lastSelected = true;
         super.onResult(this.skin);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.gameService.selectChampionSkin(this.skin,this.onResult,this.onComplete,this.onError);
      }
   }
}

