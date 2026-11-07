package com.riotgames.pvpnet.endofgamegiftwindow.actions
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.responses.factory.ILcdsProxyMessageActionFactory;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.LoadGiftsForPlayerResponseAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.LoadGiftsForPlayerServiceCall;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.SendGiftToPlayerServiceCall;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.SentGiftForPlayerResponseAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IGiftListValueObjectFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class EndOfGameGiftMessageActionFactory implements ILcdsProxyMessageActionFactory
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _validator:IGiftListValueObjectFactory;
      
      private var _service:ILcdsProxyServiceMessenger;
      
      private var _encoder:IEncode;
      
      private var _decoder:IDecode;
      
      public function EndOfGameGiftMessageActionFactory(param1:IEndOfGameGiftModel, param2:IEndOfGameGiftViewMediator, param3:IGiftListValueObjectFactory, param4:ILcdsProxyServiceMessenger, param5:IEncode, param6:IDecode)
      {
         super();
         this._model = param1;
         this._view = param2;
         this._validator = param3;
         this._service = param4;
         this._encoder = param5;
         this._decoder = param6;
      }
      
      public function createAction(param1:String, param2:String) : IAction
      {
         var _loc3_:IAction = null;
         switch(param1)
         {
            case LoadGiftsForPlayerServiceCall.METHOD_NAME:
               _loc3_ = new LoadGiftsForPlayerServiceCall(param2,this._service,this._encoder);
               break;
            case SendGiftToPlayerServiceCall.METHOD_NAME:
               _loc3_ = new SendGiftToPlayerServiceCall(param2,this._service,this._encoder);
               break;
            case LoadGiftsForPlayerResponseAction.METHOD_NAME:
               _loc3_ = new LoadGiftsForPlayerResponseAction(this._model,this._validator,LoadGiftsForPlayerResponseAction.METHOD_NAME,this._decoder,param2);
               break;
            case SentGiftForPlayerResponseAction.METHOD_NAME:
               _loc3_ = new SentGiftForPlayerResponseAction(this._model,this._validator,SentGiftForPlayerResponseAction.METHOD_NAME,this._decoder,param2);
         }
         return _loc3_;
      }
   }
}

