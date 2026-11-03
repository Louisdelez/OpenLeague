package com.riotgames.pvpnet.microfeedback.popup
{
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyDTO;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyResponseDTO;
   import com.riotgames.pvpnet.microfeedback.ClientModuleMicroFeedback;
   import com.riotgames.pvpnet.microfeedback.popup.survey.Survey;
   import com.riotgames.util.logging.getLogger;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.logging.ILogger;
   import mx.resources.IResourceManager;
   
   public class SurveyPopup extends StatefulView
   {
      
      private static const MICROFEEDBACK_RESOURCE_ID:String = ClientModuleMicroFeedback.MICROFEEDBACK_RESOURCE_ID;
      
      public static const STATE_DOCKED:String = "docked";
      
      public static const STATE_INTRO:String = "intro";
      
      public static const STATE_SURVEY:String = "survey";
      
      public static const STATE_SUBMITTING:String = "submitting";
      
      public static const STATE_THANKS:String = "thanks";
      
      public static const STATE_ERROR:String = "error";
      
      internal var submitButton:LabelButtonX;
      
      internal var headerButton:ButtonX;
      
      internal var topCloseButton:ButtonX;
      
      internal var bottomCloseButton:ButtonX;
      
      internal var minimizeButton:ButtonX;
      
      private var headerText:Text;
      
      private var subheaderText:Text;
      
      private var submittingText:Text;
      
      private var thankYouText:Text;
      
      private var ackText:Text;
      
      private var errorText:Text;
      
      private var errorAckText:Text;
      
      internal var survey:Survey;
      
      internal var prompt:SurveyDTO;
      
      protected var _popupClosedSignal:Signal = new Signal();
      
      protected var _popupOpenedSignal:Signal = new Signal();
      
      protected var _popupMinimizedSignal:Signal = new Signal();
      
      private var logger2:ILogger = getLogger(this);
      
      private var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var parentDriver:PopupDriver;
      
      private var resourceManager:IResourceManager;
      
      public function SurveyPopup(param1:IContext, param2:SurveyDTO)
      {
         super(param1);
         this.setQuestion(param2);
         setCurrentState(STATE_INTRO);
         this.parentDriver = PopupDriver(param1);
      }
      
      public function getPrompt() : SurveyDTO
      {
         return this.prompt;
      }
      
      override protected function initializeDependencies() : void
      {
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.topCloseButton = new ButtonX(this);
         this.topCloseButton.addEventListener(MouseEvent.CLICK,this.closePressedHandler);
         setTimelineChildByName("top_close_btn",this.topCloseButton);
         this.bottomCloseButton = new ButtonX(this);
         this.bottomCloseButton.addEventListener(MouseEvent.CLICK,this.closePressedHandler);
         setTimelineChildByName("bottom_close_btn",this.bottomCloseButton);
         this.minimizeButton = new ButtonX(this);
         this.minimizeButton.addEventListener(MouseEvent.CLICK,this.headerPressedHandler);
         setTimelineChildByName("minimize_btn",this.minimizeButton);
         this.submitButton = new LabelButtonX(this);
         this.submitButton.addEventListener(MouseEvent.CLICK,this.submitPressedHandler);
         this.submitButton.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"submit"));
         this.submitButton.setEnabled(false);
         setTimelineChildByName("submit_btn",this.submitButton);
         this.headerButton = new ButtonX(this);
         this.headerButton.addEventListener(MouseEvent.CLICK,this.headerPressedHandler);
         setTimelineChildByName("header_btn",this.headerButton);
         this.headerText = new Text(this);
         this.headerText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"header"));
         setTimelineChildByName("header_txt",this.headerText);
         this.subheaderText = new Text(this);
         this.subheaderText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"sub_header"));
         setTimelineChildByName("subheader_txt",this.subheaderText);
         this.submittingText = new Text(this);
         this.submittingText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"submitting"));
         setTimelineChildByName("submitting_txt",this.submittingText);
         this.thankYouText = new Text(this);
         this.thankYouText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"thank_you"));
         setTimelineChildByName("thankYou_txt",this.thankYouText);
         this.ackText = new Text(this);
         this.ackText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"success"));
         setTimelineChildByName("ack_txt",this.ackText);
         this.errorText = new Text(this);
         this.errorText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"error"));
         setTimelineChildByName("error_txt",this.errorText);
         this.errorAckText = new Text(this);
         this.errorAckText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"failure"));
         setTimelineChildByName("errorAck_txt",this.errorAckText);
      }
      
      override public function destroy() : void
      {
         if(this.survey != null)
         {
            removeChild(this.survey);
            this.survey.getResponseChanged().removeAll();
            this.survey.destroy();
            this.survey = null;
         }
         this._popupClosedSignal.removeAll();
         this._popupOpenedSignal.removeAll();
         this._popupMinimizedSignal.removeAll();
         if(this.resourceManager)
         {
            this.resourceManager.removeEventListener(Event.CHANGE,this.onResourceManagerChange);
         }
         super.destroy();
      }
      
      private function setQuestion(param1:SurveyDTO) : void
      {
         this.prompt = param1;
         this.survey = new Survey(this,param1);
         setTimelineChildByName("survey_mc",this.survey);
         this.survey.getResponseChanged().add(this.responseChangedHandler);
      }
      
      private function headerPressedHandler(param1:MouseEvent) : void
      {
         if(getCurrentState() == STATE_INTRO)
         {
            this._popupOpenedSignal.dispatch(this);
         }
         else if(getCurrentState() == STATE_SURVEY || getCurrentState() == STATE_DOCKED)
         {
            if(this.parentDriver.getCurrentState() == PopupDriver.STATE_MINIMIZED)
            {
               this._popupOpenedSignal.dispatch(this);
            }
            else if(this.parentDriver.getCurrentState() == PopupDriver.STATE_OPEN)
            {
               this._popupMinimizedSignal.dispatch(this);
            }
         }
         else if(getCurrentState() == STATE_THANKS || getCurrentState() == STATE_ERROR)
         {
            this._popupClosedSignal.dispatch(this,false);
         }
      }
      
      private function closePressedHandler(param1:MouseEvent) : void
      {
         this._popupClosedSignal.dispatch(this,false);
      }
      
      private function submitPressedHandler(param1:MouseEvent) : void
      {
         this.sendResponse();
      }
      
      internal function responseChangedHandler(param1:Survey, param2:String) : void
      {
         if(this.isValidResponse(param2))
         {
            this.submitButton.setEnabled(true);
         }
         else
         {
            this.submitButton.setEnabled(false);
         }
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         this.submitButton.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"submit"));
         this.headerText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"header"));
         this.subheaderText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"sub_header"));
         this.submittingText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"submitting"));
         this.thankYouText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"thank_you"));
         this.ackText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"success"));
         this.errorText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"error"));
         this.errorAckText.setText(this.resourceManager.getString(MICROFEEDBACK_RESOURCE_ID,"failure"));
      }
      
      private function isValidResponse(param1:String) : Boolean
      {
         return param1 != null && param1 != "";
      }
      
      private function sendResponse() : void
      {
         var _loc2_:SurveyResponseDTO = null;
         var _loc1_:String = this.survey.getResponse();
         if(this.isValidResponse(_loc1_))
         {
            _loc2_ = new SurveyResponseDTO();
            _loc2_.questionId = this.prompt.questionId;
            _loc2_.response = _loc1_;
            this.logger2.info("Sending Response...");
            this.serviceProxy.microFeedbackService.processSurveyResponse(_loc2_,null,this.onSendComplete);
            setCurrentState(STATE_SUBMITTING);
         }
      }
      
      private function onSendComplete(param1:Object) : void
      {
         if(param1)
         {
            this.logger2.info("Response successfully processed.");
            setCurrentState(STATE_THANKS);
         }
         else
         {
            this.logger2.warn("Failed to process response.");
            setCurrentState(STATE_ERROR);
         }
         this._popupClosedSignal.dispatch(this,true);
      }
      
      public function getPopupClosedSignal() : ISignal
      {
         return this._popupClosedSignal;
      }
      
      public function getPopupOpenedSignal() : ISignal
      {
         return this._popupOpenedSignal;
      }
      
      public function getPopupMinimizedSignal() : ISignal
      {
         return this._popupMinimizedSignal;
      }
   }
}

