package com.riotgames.pvpnet.cap.views.components
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollArea;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VerticalLayout;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.pvpnet.cap.controllers.CapController;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.renderers.CapInviteParticipantRenderer;
   import com.riotgames.pvpnet.cap.renderers.CapSuggestedPlayerRenderer;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.data.ListAdapter;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   
   public class CapInviteStatusPanel extends CapPanel
   {
      
      private static const LIST_PADDING_LEFT:int = 7;
      
      private static const LIST_PADDING_RIGHT:int = 8;
      
      private static const LIST_PADDING_TOP:int = 37;
      
      private static const LIST_PADDING_BOTTOM:int = 50;
      
      private static const LIST_GAP:int = 0;
      
      private var _inviteDataProvider:IListX;
      
      private var _capController:CapController;
      
      private var _viewMediator:CapViewMediator;
      
      private var _scrollArea:ScrollArea;
      
      private var _suggestedPlayersHeader:StatefulView;
      
      private var _playAgainModel:CapPlayAgainModel;
      
      private var _suggestedInviteDataGroup:DataGroup;
      
      private var _model:CapModel;
      
      private var _suggestedInviteDataProvider:ListView;
      
      private var _suggestedInviteRendererFactory:RendererFactory;
      
      private var _inviteeCollection:ArrayCollection = new ArrayCollection();
      
      private var _inviteGroup:InviteGroup;
      
      private var _inviteeDataGroup:DataGroup;
      
      private var _suggestedInviteAdapter:ListAdapter;
      
      private var _inviteController:IInviteController;
      
      private var _contentContainer:SpriteProxy;
      
      private var _suggestedPlayersHeaderText:TextFieldProxy;
      
      private var _scrollAreaSizer:SpriteProxy;
      
      private var _inviteButton:LabelButtonX;
      
      private var _inviteRendererFactory:RendererFactory;
      
      public function CapInviteStatusPanel(param1:IContext)
      {
         super(param1);
      }
      
      override public function destroy() : void
      {
         this._model.invitePanelVisibleChanged.remove(this.updateInvitePanelStatus);
         this._model.inviteSuggestionListChanged.remove(this.handleSuggestedInvitesChanged);
         this._model.enabledFeatureTogglesChanged.remove(this.updateSuggestedInviteVisibility);
         this._suggestedInviteAdapter.destroy();
         this._inviteeCollection.removeAll();
         this._inviteGroup.allowedToInviteChanged.remove(this.updateAllowedToInviteStatus);
         this._inviteGroup.getInvitedParticipantsChangedSignal().remove(this.handleInviteeStatusChange);
         this._inviteeDataGroup.destroy();
         this._inviteButton.destroy();
         this._inviteDataProvider.destroy();
         if(this._inviteRendererFactory)
         {
            this._inviteRendererFactory.destroy();
         }
         super.destroy();
      }
      
      private function handleSuggestedInvitesChanged() : void
      {
         this._suggestedInviteAdapter.setList(this._model.inviteSuggestionList);
         this.updateSuggestedInviteVisibility();
      }
      
      private function updateInviteCollection() : void
      {
         this._inviteeCollection.source = this._inviteGroup.participants.concat();
         this._inviteeCollection.refresh();
      }
      
      private function updateInvitePanelStatus() : void
      {
         if(!getVisible())
         {
            if(UserPreferencesManager.userPrefs.enableAnimations)
            {
               setCurrentState("intro");
            }
            else
            {
               setCurrentState("enabled");
            }
         }
         setEnabled(this._model.invitePanelVisible);
         setVisible(this._model.invitePanelVisible);
      }
      
      private function inviteeFilterFunction(param1:InviteParticipant) : Boolean
      {
         if(param1.isOwner)
         {
            return false;
         }
         return true;
      }
      
      private function handleInviteeStatusChange(param1:InviteParticipant) : void
      {
         this.updateInviteCollection();
      }
      
      private function handleInviteRequested(param1:CapSuggestedPlayerRenderer) : void
      {
         var _loc2_:SuggestedPlayer = param1.getData() as SuggestedPlayer;
         if(_loc2_)
         {
            this._capController.inviteSuggestedPlayer(_loc2_);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.title = CapLocaleUtil.getResourceString("gf_invite_panel_title","Invited");
         this._contentContainer = new MovieClipProxy(this);
         setTimelineChildByName("content",this._contentContainer);
         this._scrollAreaSizer = new SpriteProxy(this);
         this._contentContainer.setTimelineChildByName("sizer",this._scrollAreaSizer);
         this._scrollAreaSizer.setVisible(false);
         this._scrollArea = new ScrollArea(this);
         this._scrollArea.getContents().setLayoutAlgorithm(new VerticalLayout());
         this._contentContainer.setTimelineChildByName("inviteList",this._scrollArea);
         this._inviteButton = new LabelButtonX(this);
         this._inviteButton.addEventListener(MouseEvent.CLICK,function():void
         {
            _capController.launchInvites();
         });
         this._contentContainer.setTimelineChildByName("inviteBtn",this._inviteButton);
         this._inviteButton.setText(CapLocaleUtil.getResourceString("gf_invite_panel_invite_button_label","Invite More..."));
         this._inviteeCollection.filterFunction = this.inviteeFilterFunction;
         this._inviteeCollection.refresh();
         this._inviteDataProvider = new ListAdapter(this._inviteeCollection);
         this._inviteRendererFactory = new RendererFactory(CapInviteParticipantRenderer,[this]);
         this._inviteeDataGroup = new DataGroup(this,this._inviteDataProvider,this._inviteRendererFactory,new Sprite());
         addChild(this._inviteeDataGroup);
         this._scrollArea.getContents().addElement(this._inviteeDataGroup);
         this._suggestedPlayersHeader = new StatefulView(this);
         this._suggestedPlayersHeader.setMouseChildren(false);
         this._suggestedPlayersHeader.setMouseEnabled(false);
         this._suggestedPlayersHeader.setLinkage("CapHeader");
         addChild(this._suggestedPlayersHeader);
         this._scrollArea.getContents().addElement(this._suggestedPlayersHeader);
         this._suggestedPlayersHeaderText = new TextFieldProxy(this);
         this._suggestedPlayersHeader.setTimelineChildByName("textField",this._suggestedPlayersHeaderText);
         this._suggestedPlayersHeaderText.setText(CapLocaleUtil.getResourceString("gf_playagain_header","Suggested Players"));
         this._suggestedInviteRendererFactory = new RendererFactory(CapSuggestedPlayerRenderer,[this]);
         this._suggestedInviteRendererFactory.getEntryActivated().add(this.handleEntryActivated);
         this._suggestedInviteAdapter = new ListAdapter();
         this._suggestedInviteDataProvider = new ListView(this._suggestedInviteAdapter);
         this._suggestedInviteDataGroup = new DataGroup(this,this._suggestedInviteDataProvider,this._suggestedInviteRendererFactory,new Sprite());
         addChild(this._suggestedInviteDataGroup);
         this._scrollArea.getContents().addElement(this._suggestedInviteDataGroup);
         this.handleSuggestedInvitesChanged();
         this.updateInvitePanelStatus();
         this.updateInviteCollection();
         this.updateAllowedToInviteStatus();
      }
      
      private function handleInviteClick(param1:MouseEvent) : void
      {
         this._viewMediator.currentState.handleInviteButtonClicked(this._inviteButton);
      }
      
      private function handleEntryActivated(param1:LayoutEntry, param2:String) : void
      {
         var _loc3_:CapSuggestedPlayerRenderer = param1.element as CapSuggestedPlayerRenderer;
         _loc3_.getInviteRequested().add(this.handleInviteRequested);
         _loc3_.getDeclineRequested().add(this.handleDeclineRequested);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._scrollArea.setExplicitSize(this._scrollAreaSizer.getWidth(),this._scrollAreaSizer.getHeight());
         return super.updateLayout(param1,param2);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._model = getDependency(CapModel);
         this._model.invitePanelVisibleChanged.add(this.updateInvitePanelStatus);
         this._model.inviteSuggestionListChanged.add(this.handleSuggestedInvitesChanged);
         this._model.enabledFeatureTogglesChanged.add(this.updateSuggestedInviteVisibility);
         this._capController = getDependency(CapController);
         this._inviteController = getDependency(IInviteController);
         this._viewMediator = getDependency(CapViewMediator);
         this._inviteGroup = getDependency(InviteGroup);
         this._inviteGroup.allowedToInviteChanged.add(this.updateAllowedToInviteStatus);
         this._inviteGroup.getInvitedParticipantsChangedSignal().add(this.handleInviteeStatusChange);
         this._playAgainModel = getDependency(CapPlayAgainModel);
      }
      
      private function handleDeclineRequested(param1:CapSuggestedPlayerRenderer) : void
      {
         var _loc2_:SuggestedPlayer = param1.getData() as SuggestedPlayer;
         if(_loc2_)
         {
            this._capController.declineSuggestedPlayer(_loc2_);
         }
      }
      
      private function updateSuggestedInviteVisibility() : void
      {
         var _loc1_:Boolean = Boolean(this._inviteGroup.allowedToInvite) && Boolean(this._inviteGroup.isOwner) && (this._playAgainModel.isVictorious || this._model.useNewSuggestedPlayers) && this._suggestedInviteDataProvider.getLength() > 0;
         this._suggestedInviteDataGroup.setVisible(_loc1_);
         this._suggestedPlayersHeader.setVisible(_loc1_);
      }
      
      private function updateAllowedToInviteStatus() : void
      {
         var _loc1_:String = this._inviteGroup.allowedToInvite ? "enabled" : "disabled";
         setCurrentState(_loc1_);
         this._inviteButton.setVisible(this._inviteGroup.allowedToInvite);
         this.updateSuggestedInviteVisibility();
      }
   }
}

