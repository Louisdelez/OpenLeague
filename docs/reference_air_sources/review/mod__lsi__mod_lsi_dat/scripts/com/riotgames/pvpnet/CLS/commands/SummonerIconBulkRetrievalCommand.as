package com.riotgames.pvpnet.CLS.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import mx.rpc.events.ResultEvent;
   
   public class SummonerIconBulkRetrievalCommand extends CommandBase
   {
      
      private var _models:Array = new Array();
      
      private var _summonerIds:Array = new Array();
      
      private var _callback:Function;
      
      public function SummonerIconBulkRetrievalCommand()
      {
         super();
      }
      
      public function addLeagueListItemModelToLookup(param1:ListItemObjectModel) : void
      {
         this._models.push(param1);
         this._summonerIds.push(param1.id);
      }
      
      public function executeAndCallback(param1:Function = null) : void
      {
         this._callback = param1;
         this.execute();
      }
      
      override public function execute() : void
      {
         super.execute();
         this.onSuccess(new ResultEvent("hardcodedIconReturnEvent",false,true,"{}"));
      }
      
      private function onSuccess(param1:ResultEvent) : void
      {
         var _loc4_:ListItemObjectModel = null;
         var _loc2_:JSONDecoder = new JSONDecoder();
         var _loc3_:Object = _loc2_.decode(param1.result as String);
         for each(_loc4_ in this._models)
         {
            if(!_loc3_.hasOwnProperty(_loc4_.id.toString()))
            {
               _loc4_.iconId = 0;
            }
            else
            {
               _loc4_.iconId = _loc3_[_loc4_.id];
            }
         }
         if(this._callback != null)
         {
            this._callback();
         }
      }
      
      private function onServiceComplete(param1:ResultEvent) : void
      {
      }
   }
}

