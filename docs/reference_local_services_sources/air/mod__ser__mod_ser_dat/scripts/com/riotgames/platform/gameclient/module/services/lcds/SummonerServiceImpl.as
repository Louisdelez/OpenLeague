package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.exception.ValidationException;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import flash.utils.Dictionary;
   import mx.rpc.AsyncToken;
   import mx.rpc.events.ResultEvent;
   
   public class SummonerServiceImpl extends BaseLcdsService implements SummonerService
   {
      
      private var summonerNameCache:Dictionary = new Dictionary();
      
      public function SummonerServiceImpl()
      {
         super();
      }
      
      public function saveSocialNetworkFriendList(param1:Array, param2:Array, param3:String, param4:Function, param5:Function, param6:Function) : void
      {
         invokeServiceWithoutSession("summonerService","saveSocialNetworkFriendList",[param1,param2,param3],param4,param5);
      }
      
      public function getAllSummonerDataByAccount(param1:Number, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getAllSummonerDataByAccount",[param1],param2,param3);
      }
      
      public function getSummonerCatalog(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getSummonerCatalog",[],param1,param2);
      }
      
      public function saveSeenHelpFlag(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("summonerService","saveSeenHelpFlag",[],param1,param2);
      }
      
      public function updateSummonerSocialNetworkUser(param1:String, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : void
      {
         var _loc7_:Dictionary = this.createErrorMap(param6);
         invokeServiceWithoutSession("summonerService","updateSummonerSocialNetworkUser",[param1,param2,param3],param4,param5,_loc7_);
      }
      
      private function createErrorMap(param1:Function) : Dictionary
      {
         var _loc2_:Dictionary = new Dictionary();
         if(param1 != null)
         {
            _loc2_[ValidationException] = param1;
         }
         return _loc2_;
      }
      
      public function getAllPublicSummonerDataByAccount(param1:Number, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getAllPublicSummonerDataByAccount",[param1],param2,param3);
      }
      
      public function createDefaultSummoner(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = this.createErrorMap(param4);
         invokeServiceWithoutSession("summonerService","createDefaultSummoner",[param1],param2,param3,_loc5_);
      }
      
      public function getSocialNetworkUsers(param1:Array, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = this.createErrorMap(param5);
         invokeServiceWithoutSession("summonerService","getSocialNetworkUsers",[param1,param2],param3,param4,_loc6_);
      }
      
      public function playerChangeSummonerName(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = this.createErrorMap(param5);
         invokeServiceWithoutSession("summonerService","playerChangeSummonerName",[param1,param2],param3,param4,_loc6_);
      }
      
      public function changeTalentRankings(param1:Number, param2:Object, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerService","changeTalentRankings",[param1,param2],param3,param4);
      }
      
      public function checkSummonerName(param1:String, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","checkSummonerName",[param1],param2,param3);
      }
      
      public function saveSeenTutorialFlag(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("summonerService","saveSeenTutorialFlag",[],param1,param2);
      }
      
      public function getSummonerNames(param1:Array, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getSummonerNames",[param1],param2,param3);
      }
      
      public function getSummonerByName(param1:String, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getSummonerByName",[param1],param2,param3);
      }
      
      public function getSummonerInternalNameByName(param1:String, param2:Function, param3:Function, param4:Function, param5:Object) : void
      {
         var token:AsyncToken = null;
         var resultEvent:ResultEvent = null;
         var wrapperSuccessCallback:Function = null;
         var errorMap:Dictionary = null;
         var summonerName:String = param1;
         var onSuccess:Function = param2;
         var onComplete:Function = param3;
         var onError:Function = param4;
         var summonerInfo:Object = param5;
         var result:Object = this.summonerNameCache[summonerName];
         if(result != null)
         {
            token = new AsyncToken(null);
            token.asyncObject = summonerInfo;
            resultEvent = new ResultEvent(ResultEvent.RESULT,false,false,result,token);
            onSuccess.apply(null,[resultEvent]);
         }
         else
         {
            wrapperSuccessCallback = function(param1:ResultEvent):void
            {
               summonerNameCache[summonerName] = param1.result;
               onSuccess.apply(null,[param1]);
            };
            errorMap = this.createErrorMap(onError);
            invokeServiceWithoutSession("summonerService","getSummonerInternalNameByName",[summonerName],wrapperSuccessCallback,onComplete,errorMap,summonerInfo);
         }
      }
      
      public function updateProfileIconId(param1:int, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","updateProfileIconId",[param1],param2,param3);
      }
      
      public function getSummonerIcons(param1:Array, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getSummonerIcons",[param1],param2,param3);
      }
      
      public function getSocialNetworkFriends(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","getSocialNetworkFriends",[],param1,param2);
      }
      
      public function resetTalents(param1:Number, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("summonerService","resetTalents",[param1],param2,param3);
      }
   }
}

