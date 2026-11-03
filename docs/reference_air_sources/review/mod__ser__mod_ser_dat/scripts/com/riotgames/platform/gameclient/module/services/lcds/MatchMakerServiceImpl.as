package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.domain.MatchMakerParams;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.exception.MatchmakingException;
   import com.riotgames.platform.gameclient.services.MatchMakerService;
   import flash.utils.Dictionary;
   
   public class MatchMakerServiceImpl extends BaseLcdsService implements MatchMakerService
   {
      
      public function MatchMakerServiceImpl()
      {
         super();
      }
      
      public function isMatchmakingEnabled(param1:Function) : void
      {
         invokeServiceWithoutSession("matchmakerService","isMatchmakingEnabled",[],param1);
      }
      
      public function cancelFromQueueIfPossible(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[GameException] = param4;
         invokeServiceWithoutSession("matchmakerService","cancelFromQueueIfPossible",[param1],param2,param3,_loc5_);
      }
      
      public function getQueueInfo(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[GameException] = param4;
         invokeServiceWithoutSession("matchmakerService","getQueueInfo",[param1],param2,param3,_loc5_);
      }
      
      public function purgeFromQueues(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         _loc4_[GameException] = param3;
         invokeServiceWithoutSession("matchmakerService","purgeFromQueues",[],param1,param2,_loc4_);
      }
      
      public function attachToQueue(param1:MatchMakerParams, param2:Object, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         _loc6_[GameException] = param5;
         invokeServiceWithoutSession("matchmakerService","attachToQueue",[param1,param2],param3,param4,_loc6_);
      }
      
      public function acceptInviteForMatchmakingGame(param1:String, param2:Function, param3:Function, param4:Function, param5:Object) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         _loc6_[MatchmakingException] = param4;
         invokeServiceWithoutSession("matchmakerService","acceptInviteForMatchmakingGame",[param1],param2,param3,_loc6_,param5);
      }
      
      public function getAvailableQueues(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         _loc4_[GameException] = param3;
         invokeServiceWithoutSession("matchmakerService","getAvailableQueues",[],param1,param2,_loc4_);
      }
   }
}

