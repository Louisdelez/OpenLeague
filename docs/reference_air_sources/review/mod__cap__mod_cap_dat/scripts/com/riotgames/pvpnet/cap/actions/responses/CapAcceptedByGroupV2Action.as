package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.controllers.CapTimerController;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.LcdsProxyMessageActionDataUtil;
   import flash.desktop.NativeApplication;
   import flash.display.NativeWindow;
   
   public class CapAcceptedByGroupV2Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "acceptedByGroupV2";
      
      public static const GROUP_ID_KEY:String = "groupId";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      private static const TIMEOUT_KEY:String = "candidateAutoQuitTimeout";
      
      private static const MILLISECONDS_PER_SECOND:int = 1000;
      
      private var _timerController:CapTimerController;
      
      private var _model:CapModel;
      
      private var _controller:ICapController;
      
      public function CapAcceptedByGroupV2Action(param1:CapModel, param2:CapTimerController, param3:ICapController, param4:IDecode = null, param5:String = null)
      {
         super(METHOD_NAME,param4,param5);
         this._model = param1;
         this._controller = param3;
         this._timerController = param2;
      }
      
      protected function startAFKTimer(param1:Object) : void
      {
         var _loc2_:int = int(param1[TIMEOUT_KEY]);
         var _loc3_:Number = _loc2_ * MILLISECONDS_PER_SECOND;
         this._model.soloAFKStartTime = _loc3_;
         this._timerController.tickSignal.add(this.handleTimerTick);
         this._timerController.completeSignal.addOnce(this.handleTimerTick);
         this._timerController.stopSignal.addOnce(this.handleTimerStop);
         this._timerController.start(_loc2_ * MILLISECONDS_PER_SECOND);
      }
      
      private function orderClientToFront() : void
      {
         var _loc1_:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
         _loc1_.activate();
         _loc1_.orderToFront();
         _loc1_.alwaysInFront = true;
         _loc1_.alwaysInFront = false;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         LcdsProxyMessageActionDataUtil.validate(param1,[GROUP_ID_KEY,SLOT_ID_KEY]);
         this._model.groupId = param1[GROUP_ID_KEY];
         this._model.localPlayerSelection.slotId = param1[SLOT_ID_KEY];
         this.startAFKTimer(param1);
         this.orderClientToFront();
         this._controller.joinChatRoom();
      }
      
      protected function handleTimerTick() : void
      {
         this._model.soloAFKTimeRemaining = this._timerController.timeRemaining;
      }
      
      protected function handleTimerComplete() : void
      {
      }
      
      protected function handleTimerStop() : void
      {
         this._timerController.tickSignal.remove(this.handleTimerTick);
      }
   }
}

