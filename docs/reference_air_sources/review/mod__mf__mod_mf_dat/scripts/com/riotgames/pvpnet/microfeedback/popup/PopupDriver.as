package com.riotgames.pvpnet.microfeedback.popup
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyDTO;
   import com.riotgames.util.logging.getLogger;
   import mx.logging.ILogger;
   
   public class PopupDriver extends StatefulView
   {
      
      public static const LINKAGE:String = "PopupDriver";
      
      public static const POPUP_MINIMIZED_LINKAGE:String = "surveyPopup_Minimized_mc";
      
      public static const POPUP_OPEN_LINKAGE:String = "surveyPopup_open_mc";
      
      public static const STATE_CLOSED:String = "closed";
      
      public static const STATE_DELAY_CLOSED:String = "delay_closed";
      
      public static const STATE_OPEN:String = "open";
      
      public static const STATE_MINIMIZED:String = "minimized";
      
      internal var popup:SurveyPopup;
      
      private var inProgress:Boolean = false;
      
      private var logger2:ILogger = getLogger(this);
      
      public function PopupDriver(param1:IContext, param2:SurveyDTO)
      {
         super(param1);
         setLinkage(LINKAGE);
         setCurrentState(STATE_MINIMIZED);
         this.popup = new SurveyPopup(this,param2);
         setTimelineChildByName(POPUP_MINIMIZED_LINKAGE,this.popup);
         this.popup.getPopupClosedSignal().add(this.onPopupClosed);
         this.popup.getPopupOpenedSignal().add(this.onPopupOpen);
         this.popup.getPopupMinimizedSignal().add(this.onPopupMinimized);
      }
      
      public function getInProgress() : Boolean
      {
         return this.inProgress;
      }
      
      override public function destroy() : void
      {
         this.popup.getPopupClosedSignal().removeAll();
         this.popup.getPopupOpenedSignal().removeAll();
         this.popup.getPopupMinimizedSignal().removeAll();
         this.popup.destroy();
         this.popup = null;
         super.destroy();
      }
      
      private function onPopupClosed(param1:SurveyPopup, param2:Boolean = false) : void
      {
         if(param2)
         {
            param1.setCurrentState(STATE_DELAY_CLOSED);
         }
         else
         {
            setCurrentState(STATE_CLOSED);
            param1.setCurrentState(STATE_CLOSED);
         }
      }
      
      private function onPopupOpen(param1:SurveyPopup) : void
      {
         if(this.inProgress)
         {
            setTimelineChildByName(POPUP_OPEN_LINKAGE,this.popup);
            setCurrentState(STATE_OPEN);
            this.popup.setCurrentState(SurveyPopup.STATE_SURVEY);
         }
      }
      
      private function onPopupMinimized(param1:SurveyPopup) : void
      {
         if(this.inProgress)
         {
            setCurrentState(STATE_MINIMIZED);
            this.popup.setCurrentState(SurveyPopup.STATE_DOCKED);
         }
      }
      
      public function startSurvey() : void
      {
         if(!this.inProgress)
         {
            this.inProgress = true;
            setCurrentState(STATE_MINIMIZED);
         }
      }
   }
}

