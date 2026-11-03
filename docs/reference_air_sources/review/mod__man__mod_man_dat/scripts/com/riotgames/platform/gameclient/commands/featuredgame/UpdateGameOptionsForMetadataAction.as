package com.riotgames.platform.gameclient.commands.featuredgame
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.GameOptionsList;
   import com.riotgames.platform.gameclient.domain.game.GamePropertiesListData;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.pvpnet.game.controllers.GameConfig;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.util.string.RiotStringUtil;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   internal class UpdateGameOptionsForMetadataAction extends BasicAction
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var queueOptions:Array;
      
      private var gameQueueManager:GameQueueManager;
      
      public function UpdateGameOptionsForMetadataAction(param1:GameQueueManager, param2:Array)
      {
         super(false);
         this.gameQueueManager = param1;
         this.queueOptions = param2;
      }
      
      private function parseQueuePrerequisites(param1:String) : Array
      {
         var prerequisitesArray:Array = null;
         var prerequisiteQueue:String = null;
         var parsedQueueId:Number = NaN;
         var queuePrerequisiteString:String = param1;
         var parsedPrerequisites:Array = [];
         try
         {
            prerequisitesArray = queuePrerequisiteString.split(",");
            for each(prerequisiteQueue in prerequisitesArray)
            {
               if(!RiotStringUtil.isEmpty(prerequisiteQueue))
               {
                  parsedQueueId = parseInt(prerequisiteQueue);
                  parsedPrerequisites.push(parsedQueueId);
               }
            }
         }
         catch(error:Error)
         {
            logger.error(logger.category + ", Could not parse queuePrerequisite: " + error.toSource());
         }
         return parsedPrerequisites;
      }
      
      private function configureQueueStep(param1:GamePropertiesListData) : void
      {
         var _loc2_:XML = param1.nextStep as XML;
         var _loc3_:GameQueueConfig = this.gameQueueManager.getQueueForID(_loc2_.@soloid);
         var _loc4_:GameQueueConfig = this.gameQueueManager.getQueueForID(_loc2_.@partyid);
         if(!_loc3_ && !_loc4_)
         {
            param1.meetsQueuePrerequisites = true;
            return;
         }
         var _loc5_:String = _loc2_.@queuePrerequisite;
         if(RiotStringUtil.isEmpty(_loc5_))
         {
            param1.meetsQueuePrerequisites = true;
            return;
         }
         var _loc6_:Array = GameConfig.instance.featuredGameMetadataDTO != null ? GameConfig.instance.featuredGameMetadataDTO.completedFeaturedQueueIds : null;
         if(!this.meetsQueuePrerequisites(_loc6_,param1,_loc5_))
         {
            param1.meetsQueuePrerequisites = false;
         }
         else
         {
            param1.meetsQueuePrerequisites = true;
         }
      }
      
      private function meetsQueuePrerequisites(param1:Array, param2:GamePropertiesListData, param3:String) : Boolean
      {
         var _loc5_:Number = NaN;
         if(param2.parsedQueuePrerequisites == null)
         {
            param2.parsedQueuePrerequisites = this.parseQueuePrerequisites(param3);
         }
         var _loc4_:Boolean = false;
         if(param2.parsedQueuePrerequisites.length == 0)
         {
            _loc4_ = true;
         }
         else if(param1 == null)
         {
            _loc4_ = false;
         }
         else
         {
            for each(_loc5_ in param2.parsedQueuePrerequisites)
            {
               if(param1.indexOf(_loc5_) >= 0)
               {
                  _loc4_ = true;
                  break;
               }
            }
         }
         if(!_loc4_)
         {
            param2.queuePrerequisiteNotMetMessage = RiotResourceLoader.getString("matchmaking_joinqueue_prerequisite_not_met_message");
            param2.queuePrerequisiteNotMetTipMessage = RiotResourceLoader.getString("matchmaking_joinqueue_prerequisite_not_met_tip_message");
         }
         return _loc4_;
      }
      
      override protected function doInvocation() : void
      {
         if(!FeaturedGameMetadataActions.serviceEnabled)
         {
            complete();
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.queueOptions.length)
         {
            this.updateQueueOptionItem(this.queueOptions[_loc1_]);
            _loc1_++;
         }
         complete();
      }
      
      private function updateQueueOptionItem(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc2_:GameOptionsList = param1 as GameOptionsList;
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.source.length)
            {
               this.updateQueueOptionItem(_loc2_.source[_loc4_]);
               _loc4_++;
            }
            return;
         }
         var _loc3_:GamePropertiesListData = param1 as GamePropertiesListData;
         if(_loc3_.nextStep is GameOptionsList)
         {
            this.updateQueueOptionItem(_loc3_.nextStep);
         }
         else if(_loc3_.nextStep is XML)
         {
            if(_loc3_.nextStep.name() == "queue")
            {
               this.configureQueueStep(_loc3_);
            }
         }
      }
   }
}

