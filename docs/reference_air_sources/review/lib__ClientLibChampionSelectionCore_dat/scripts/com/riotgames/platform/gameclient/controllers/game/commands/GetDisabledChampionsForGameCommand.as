package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.gameclient.controllers.game.enums.DisabledChampionsforGameEnum;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.string.RiotStringUtil;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class GetDisabledChampionsForGameCommand extends WaitCommand
   {
      
      private var _currentGame:GameDTO;
      
      private var _championSelections:ParticipantChampionListView;
      
      public function GetDisabledChampionsForGameCommand(param1:GameDTO, param2:ParticipantChampionListView, param3:IResourceManager, param4:ICursorManager)
      {
         super(param3,param4);
         this._currentGame = param1;
         this._championSelections = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         var _loc1_:ConfigurationModel = null;
         if(!RiotStringUtil.isEmpty(this._currentGame.queueTypeName) && QueueType.NONE != this._currentGame.queueTypeName)
         {
            _loc1_ = DynamicClientConfigManager.getConfiguration(DisabledChampionsforGameEnum.NAMESPACE,this._currentGame.queueTypeName,[]);
         }
         else if(!RiotStringUtil.isEmpty(this._currentGame.gameMode))
         {
            _loc1_ = DynamicClientConfigManager.getConfiguration(DisabledChampionsforGameEnum.NAMESPACE,this._currentGame.gameMode,[]);
         }
         this.onResult(_loc1_);
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:ParticipantChampionSelection = null;
         if(param1 != null)
         {
            _loc2_ = this.parseIntArray((param1 as ConfigurationModel).getValue());
            if(_loc2_ != null && _loc2_.length > 0)
            {
               for each(_loc3_ in _loc2_)
               {
                  _loc4_ = this._championSelections.getSelectionByChampionId(_loc3_);
                  if(_loc4_ != null)
                  {
                     _loc4_.disabledForGame = true;
                  }
               }
               this._championSelections.refresh();
            }
         }
         super.onResult(param1);
         onComplete();
      }
      
      private function parseIntArray(param1:*) : Array
      {
         var jsonString:* = param1;
         var intArray:Array = [];
         if(!RiotStringUtil.isEmpty(jsonString) && jsonString != "[]")
         {
            try
            {
               intArray = jsonDecode(jsonString) as Array;
            }
            catch(error:Error)
            {
               logger.error("Garbled dynamic configuration for disabled champions for game: " + error.toString());
            }
         }
         return intArray;
      }
   }
}

