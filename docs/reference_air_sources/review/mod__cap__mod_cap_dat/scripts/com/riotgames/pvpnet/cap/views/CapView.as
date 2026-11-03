package com.riotgames.pvpnet.cap.views
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.views.components.CapButtonsFooterComponent;
   import com.riotgames.pvpnet.cap.views.components.ICapButtonsFooterComponent;
   import com.riotgames.pvpnet.cap.views.popups.CapMatchFoundPopup;
   import com.riotgames.pvpnet.cap.views.popups.CapSoloGroupFoundPopup;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class CapView extends StatefulView implements ICapView
   {
      
      public static const TEAM_STATE_LABEL:String = "team";
      
      public static const SOLO_STATE_LABEL:String = "solo";
      
      private var _soloGroupFoundPopup:CapSoloGroupFoundPopup;
      
      protected var _model:CapModel;
      
      private var _soloViewContent:CapSoloViewContent;
      
      private var _matchFoundPopup:CapMatchFoundPopup;
      
      private var _teamViewContent:CapTeamViewContent;
      
      private var _buttonsFooter:CapButtonsFooterComponent;
      
      public function CapView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      public function get buttonsFooter() : ICapButtonsFooterComponent
      {
         return this._buttonsFooter;
      }
      
      public function hideGroupFoundPopup() : void
      {
         if(this._soloGroupFoundPopup)
         {
            PopUpManager.removePopUp(this._soloGroupFoundPopup);
         }
      }
      
      public function showSoloView() : void
      {
         setCurrentState(SOLO_STATE_LABEL);
         this._buttonsFooter.showSoloView();
      }
      
      public function showTeamViewForCaptain() : void
      {
         this._buttonsFooter.setVisible(true);
         setCurrentState(TEAM_STATE_LABEL);
         this._buttonsFooter.showTeamViewForCaptain();
      }
      
      public function hideMatchFoundPopup() : void
      {
         if(this._matchFoundPopup)
         {
            PopUpManager.removePopUp(this._matchFoundPopup);
            this._matchFoundPopup.destroy();
         }
      }
      
      public function showTeamViewForSolo() : void
      {
         this._buttonsFooter.setVisible(true);
         setCurrentState(TEAM_STATE_LABEL);
         this._buttonsFooter.showTeamViewForSolo();
      }
      
      public function get soloGroupFoundPopup() : CapSoloGroupFoundPopup
      {
         return this._soloGroupFoundPopup;
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(CapModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._teamViewContent = new CapTeamViewContent(this,this._model);
         setTimelineChildByName("teamViewContent",this._teamViewContent);
         this._soloViewContent = new CapSoloViewContent(this,this._model);
         setTimelineChildByName("soloViewContent",this._soloViewContent);
         this._buttonsFooter = new CapButtonsFooterComponent(this,new MovieClip());
         setTimelineChildByName("buttons",this._buttonsFooter);
      }
      
      override public function destroy() : void
      {
         this._model = null;
         this._soloViewContent.destroy();
         this._teamViewContent.destroy();
         this._buttonsFooter.destroy();
         if(this._soloGroupFoundPopup)
         {
            PopUpManager.removePopUp(this._soloGroupFoundPopup);
            this._soloGroupFoundPopup.destroy();
         }
         if(this._matchFoundPopup)
         {
            PopUpManager.removePopUp(this._matchFoundPopup);
            this._matchFoundPopup.destroy();
         }
         super.destroy();
      }
      
      public function showTeamViewForInvitee() : void
      {
         this._buttonsFooter.setVisible(true);
         setCurrentState(TEAM_STATE_LABEL);
         this._buttonsFooter.showTeamViewForInvitee();
      }
      
      public function showMatchFoundPopup() : void
      {
         this._matchFoundPopup = new CapMatchFoundPopup(this);
         PopUpManager.addPopUp(this._matchFoundPopup,null,true);
      }
      
      public function showGroupFoundPopup() : void
      {
         this._soloGroupFoundPopup = new CapSoloGroupFoundPopup(this,new Sprite());
         PopUpManager.addPopUp(this._soloGroupFoundPopup,null,true);
      }
   }
}

