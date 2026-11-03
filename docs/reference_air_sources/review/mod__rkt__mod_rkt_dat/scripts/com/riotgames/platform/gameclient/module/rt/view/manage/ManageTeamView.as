package com.riotgames.platform.gameclient.module.rt.view.manage
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.Manage_Team_Tab.ManageTeamView;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.module.rt.view.common.IActivatableView;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.rust.components.FlashFlexComponent;
   import com.riotgames.rust.components.PromptingTextView;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   
   public class ManageTeamView extends FlashFlexComponent implements IActivatableView
   {
      
      private var buddyList:List;
      
      private var lastInviteText:TextFieldProxy;
      
      private var statusInfoText:TextFieldProxy;
      
      public var promoteButton:ButtonX;
      
      private var rosterFilledText:TextFieldProxy;
      
      private var statusStates:StatefulView;
      
      private var rawBuddies:Array;
      
      private var _buddyFilter:String = null;
      
      private var nextInviteText:TextFieldProxy;
      
      private var invitesAvailableText:TextFieldProxy;
      
      private var rosterListComponent:List;
      
      private var _team:Team;
      
      private var statusText:TextFieldProxy;
      
      private var gamesPlayedText:TextFieldProxy;
      
      private var invitedListComponent:List;
      
      private var filterText:PromptingTextView;
      
      private var teamTagText:TextFieldProxy;
      
      private var teamNameText:TextFieldProxy;
      
      private var _mediator:IMediator;
      
      private var openSlotsText:TextFieldProxy;
      
      private var establishedText:TextFieldProxy;
      
      private var infoPanel:StatefulView;
      
      public function ManageTeamView(param1:RTContext)
      {
         super(param1,"rt.ManageTeamView");
         var _loc2_:blix.assets.proxy.Manage_Team_Tab.ManageTeamView = new blix.assets.proxy.Manage_Team_Tab.ManageTeamView();
         this.promoteButton = param1.viewUtil.wireButton(this.view,_loc2_.promoteNewCaptainButton,null);
         this.teamNameText = _loc2_.teamNameText.create(this.view);
         this.teamTagText = _loc2_.teamTagText.create(this.view);
         this.statusText = _loc2_.statusText.create(this.view);
         this.establishedText = _loc2_.establishedText.create(this.view);
         this.gamesPlayedText = _loc2_.gamesPlayedText.create(this.view);
         this.lastInviteText = _loc2_.lastInviteText.create(this.view);
         this.nextInviteText = _loc2_.nextInviteText.create(this.view);
         this.rosterFilledText = _loc2_.rosterFilledText.create(this.view);
         this.invitesAvailableText = _loc2_.invitesAvailableText.create(this.view);
         this.openSlotsText = _loc2_.openSlotsText.create(this.view);
         this.filterText = new PromptingTextView(this.view);
         this.filterText.setPrompt(RTResource.getString("filterInvitePrompt"),8947848);
         this.view.setTimelineChild(_loc2_.filterText,this.filterText);
         this.filterText.onTextChanged.add(this.onFilterChanged);
         this.buddyList = new List();
         this.buddyList.itemRenderer = new ClassFactory(InviteBuddyRenderer);
         this.buddyList.rowHeight = 28;
         this.buddyList.selectable = false;
         this.buddyList.verticalScrollPolicy = ScrollPolicy.ON;
         this.buddyList.styleName = "yellow";
         param1.viewUtil.setupComponentOverlay(this.view,_loc2_.buddyListProxy,this,this.buddyList);
         this.invitedListComponent = new List();
         this.invitedListComponent.itemRenderer = new ClassFactory(ManageInvitedItemView);
         this.invitedListComponent.rowHeight = 45;
         this.invitedListComponent.selectable = false;
         this.invitedListComponent.verticalScrollPolicy = ScrollPolicy.ON;
         this.invitedListComponent.styleName = "yellow";
         param1.viewUtil.setupComponentOverlay(this.view,_loc2_.inviteListProxy,this,this.invitedListComponent);
         ManageRosterItemView.setContext(param1);
         this.rosterListComponent = new List();
         this.rosterListComponent.itemRenderer = new ClassFactory(ManageRosterItemView);
         this.rosterListComponent.rowHeight = 45;
         this.rosterListComponent.selectable = false;
         this.rosterListComponent.verticalScrollPolicy = ScrollPolicy.ON;
         this.rosterListComponent.styleName = "yellow";
         param1.viewUtil.setupComponentOverlay(this.view,_loc2_.rosterListProxy,this,this.rosterListComponent);
         this.statusStates = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.statusStates,this.statusStates);
         this.infoPanel = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.infoPanel,this.infoPanel);
         this.infoPanel.setCurrentState("hide");
         this.statusStates.addEventListener(MouseEvent.ROLL_OVER,this.onStatusRollOver);
         this.statusStates.addEventListener(MouseEvent.ROLL_OUT,this.onStatusRollOut);
         this.statusInfoText = _loc2_.infoPanel.bullet1.create(this.view);
      }
      
      private function makeHeaderRenderer(param1:String) : InviteRendererData
      {
         var _loc2_:InviteRendererData = new InviteRendererData();
         _loc2_.header = RTResource.getString(param1);
         return _loc2_;
      }
      
      private function onStatusRollOut(param1:MouseEvent) : void
      {
         this.infoPanel.setCurrentState("hide");
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      private function setBuddyArray(param1:Array) : void
      {
         this.rawBuddies = param1;
         this.updateInviteList();
      }
      
      private function onStatusRollOver(param1:MouseEvent) : void
      {
         this.infoPanel.setCurrentState("show");
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function setTeamData(param1:Team, param2:Array) : void
      {
         var _loc8_:TeamMemberInfo = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         this._team = param1;
         if(!param1)
         {
            return;
         }
         this.teamNameText.setText(param1.name);
         this.teamTagText.setText(param1.getFormattedTag());
         this.establishedText.setText(param1.createDate ? DateUtil.getDateString(param1.createDate) : "missing");
         this.gamesPlayedText.setText(param1.calculateTotalGamesPlayed().toString());
         this.lastInviteText.setText(param1.lastJoinDate ? DateUtil.getDateString(param1.lastJoinDate) : "");
         var _loc3_:Date = param1.calculateNextInvite();
         this.nextInviteText.setText(_loc3_ != null ? DateUtil.getDateAndTimeString(_loc3_) : "");
         this.rosterFilledText.setText(RTResource.getString("manageRosterSlotsValue",[param1.calculateFilledRosterSlots(),Team.MAX_NUMBER_OF_MEMBERS]));
         this.invitesAvailableText.setText(RTResource.getString("manageInvitesAvailable",[param1.calculateInvitesAvailable()]));
         this.openSlotsText.setText(RTResource.getString("manageRosterOpenSlots",[param1.calculateOpenRosterSlots()]));
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Number = Number(RTFacade.instance.rtProvider.session.summoner.sumId);
         for each(_loc8_ in param1.roster.memberList)
         {
            if(_loc8_.playerId == _loc7_)
            {
               continue;
            }
            switch(_loc8_.status)
            {
               case TeamMemberStatus.INVITED:
                  _loc4_.push(_loc8_);
                  break;
               case TeamMemberStatus.DECLINED:
                  _loc5_.push(_loc8_);
                  break;
               case TeamMemberStatus.MEMBER:
                  _loc6_.push(_loc8_);
            }
         }
         _loc9_ = [];
         _loc10_ = 0;
         while(_loc10_ < _loc4_.length)
         {
            _loc9_.push({
               "info":_loc4_[_loc10_],
               "teamId":param1.teamId
            });
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc5_.length)
         {
            _loc9_.push({
               "info":_loc5_[_loc10_],
               "teamId":param1.teamId
            });
            _loc10_++;
         }
         this.invitedListComponent.dataProvider = _loc9_;
         var _loc11_:Array = [];
         _loc10_ = 0;
         while(_loc10_ < _loc6_.length)
         {
            _loc11_.push({
               "info":_loc6_[_loc10_],
               "teamId":param1.teamId
            });
            _loc10_++;
         }
         this.rosterListComponent.dataProvider = _loc11_;
         this.setBuddyArray(param2);
         var _loc12_:Boolean = _loc6_.length > 0;
         this.promoteButton.setVisible(_loc12_);
         if(param1.status == TeamStatus.PROVISIONAL)
         {
            this.statusStates.setCurrentState("seeding");
            this.statusText.setText(RTResource.getString("statusSeeding"));
            this.statusInfoText.setText(RTResource.getString("Status_seeding_bullet1"));
         }
         else
         {
            this.statusStates.setCurrentState("ranked");
            this.statusText.setText(RTResource.getString("statusRanked"));
            this.statusInfoText.setText(RTResource.getString("Status_ranked_bullet1"));
         }
      }
      
      private function makeBuddyRenderer(param1:Buddy) : InviteRendererData
      {
         var _loc2_:InviteRendererData = new InviteRendererData();
         _loc2_.buddy = param1;
         _loc2_.eligible = true;
         return _loc2_;
      }
      
      private function filterMatchesBuddy(param1:Buddy) : Boolean
      {
         if(Boolean(this._buddyFilter) && this._buddyFilter.length > 0)
         {
            if(param1.getName().toLowerCase().indexOf(this._buddyFilter.toLowerCase()) != -1)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      private function updateInviteList() : void
      {
         var _loc4_:Buddy = null;
         var _loc5_:ArrayCollection = null;
         var _loc6_:Number = NaN;
         var _loc7_:InviteRendererData = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         for each(_loc4_ in this.rawBuddies)
         {
            _loc6_ = Number(_loc4_.getSummonerId());
            if(!this.isPlayerInTeamAlready(_loc6_))
            {
               if(this.filterMatchesBuddy(_loc4_))
               {
                  if(_loc4_.getIsMutualFriend())
                  {
                     _loc7_ = this.makeBuddyRenderer(_loc4_);
                     if(_loc4_.getPresence())
                     {
                        if(_loc4_.getPresence().level < Team.MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS)
                        {
                           _loc7_.eligible = false;
                           _loc7_.ineligibleReason = RTResource.getString("ineligibleReasonNotLevel30",[Team.MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS]);
                           _loc3_.push(_loc7_);
                        }
                        else
                        {
                           _loc1_.push(_loc7_);
                        }
                     }
                     else
                     {
                        _loc2_.push(_loc7_);
                     }
                  }
               }
            }
         }
         _loc5_ = new ArrayCollection();
         if(_loc1_.length > 0)
         {
            _loc5_.addItem(this.makeHeaderRenderer("inviteHeaderOnline"));
            this.appendArrayToCollection(_loc5_,_loc1_);
         }
         if(_loc2_.length > 0)
         {
            _loc5_.addItem(this.makeHeaderRenderer("inviteHeaderOffline"));
            this.appendArrayToCollection(_loc5_,_loc2_);
         }
         if(_loc3_.length > 0)
         {
            _loc5_.addItem(this.makeHeaderRenderer("inviteHeaderIneligible"));
            this.appendArrayToCollection(_loc5_,_loc3_);
         }
         this.buddyList.dataProvider = _loc5_;
      }
      
      private function isPlayerInTeamAlready(param1:Number) : Boolean
      {
         var _loc2_:TeamMemberInfo = null;
         for each(_loc2_ in this._team.roster.memberList)
         {
            if(param1 == _loc2_.playerId)
            {
               if(_loc2_.status == TeamMemberStatus.INVITED || _loc2_.status == TeamMemberStatus.MEMBER)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function activate() : void
      {
         if(!this._mediator)
         {
            this._mediator = new ManageTeamMediator(ManageTeamMediator.NAME,this);
         }
         RTFacade.instance.registerMediator(this._mediator);
      }
      
      public function deactivate() : void
      {
         RTFacade.instance.removeMediator(ManageTeamMediator.NAME);
      }
      
      private function onFilterChanged(param1:PromptingTextView, param2:String) : void
      {
         if(param2.length > 0 && param2 != this.filterText.promptText)
         {
            this._buddyFilter = param2;
         }
         else
         {
            this._buddyFilter = null;
         }
         this.updateInviteList();
      }
      
      private function appendArrayToCollection(param1:ArrayCollection, param2:Array) : void
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param2)
         {
            param1.addItem(_loc3_);
         }
      }
   }
}

