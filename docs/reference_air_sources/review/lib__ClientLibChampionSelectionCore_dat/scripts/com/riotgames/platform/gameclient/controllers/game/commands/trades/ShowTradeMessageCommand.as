package com.riotgames.platform.gameclient.controllers.game.commands.trades
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionTrade;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.resources.IResourceManager;
   
   public class ShowTradeMessageCommand extends CommandBase
   {
      
      private var _resourceManager:IResourceManager;
      
      private var _timeout:uint;
      
      private var _titleKey:String;
      
      private var _tradeMessage:String;
      
      private var _messageParameters:Array;
      
      private var _tradeTitle:String;
      
      private var _messageKey:String;
      
      private var _tradeMessageTimeoutId:uint = 0;
      
      private var _championTrade:ChampionTrade;
      
      public function ShowTradeMessageCommand(param1:ChampionTrade, param2:String, param3:String, param4:Array, param5:IResourceManager, param6:uint = 5000)
      {
         super();
         this._championTrade = param1;
         this._titleKey = param2;
         this._messageKey = param3;
         this._messageParameters = param4;
         this._resourceManager = param5;
         this._timeout = param6;
      }
      
      override public function execute() : void
      {
         super.execute();
         this._tradeMessage = this._resourceManager.getString("resources",this._messageKey,this._messageParameters);
         this._tradeTitle = this._resourceManager.getString("resources",this._titleKey);
         this._championTrade.tradeTitle = this._tradeTitle;
         this._championTrade.tradeMessage = this._tradeMessage;
         this._championTrade.tradeCancellable = false;
         if(this._tradeMessageTimeoutId != 0)
         {
            clearTimeout(this._tradeMessageTimeoutId);
         }
         this._tradeMessageTimeoutId = setTimeout(this.tradeMessageWaitTimeoutCallback,this._timeout);
      }
      
      private function tradeMessageWaitTimeoutCallback() : void
      {
         if(this._tradeMessageTimeoutId != 0)
         {
            clearTimeout(this._tradeMessageTimeoutId);
         }
         this._tradeMessageTimeoutId = 0;
         if(!this._championTrade.pendingTrade && this._championTrade.tradeMessage == this._tradeMessage && this._championTrade.tradeTitle == this._tradeTitle)
         {
            this._championTrade.tradeMessage = "";
            this._championTrade.tradeTitle = "";
            onResult();
         }
         onComplete();
      }
   }
}

