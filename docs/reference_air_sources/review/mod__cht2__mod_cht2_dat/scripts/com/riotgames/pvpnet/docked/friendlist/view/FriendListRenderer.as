package com.riotgames.pvpnet.docked.friendlist.view
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.chat.utils.StatusMessageUtil;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.chat.ChatBuddyTooltipView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.drag.DragBehavior;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class FriendListRenderer extends ButtonX implements IDataRenderer
   {
      
      private var buddyNameLabel:Text;
      
      private var statusLabel:Text;
      
      private var buddyNoteButton:ButtonX;
      
      private var statusIndicator:StatefulView;
      
      private var spectateIndicator:SpriteProxy;
      
      private var summonerIconBox:SpriteProxy;
      
      private var summonerIcon:BitmapProxy;
      
      private var background:StatefulView;
      
      private var _viewMediator:ChatViewMediator;
      
      private var _buddy:Buddy;
      
      private var _isMobileEnabled:Boolean;
      
      private var dragBehavior:DragBehavior;
      
      private var noteLayoutData:CanvasLayoutData = new CanvasLayoutData();
      
      public function FriendListRenderer(param1:IContext)
      {
         super(param1);
         setDoubleClickEnabled(true);
         setMouseChildren(true);
         this.dragBehavior = new DragBehavior(this);
         this.dragBehavior.getDragBegin().add(this.dragBeginHandler);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._viewMediator = getDependency(ChatViewMediator);
         var _loc1_:IConfigurationRegistry = getDependency(IConfigurationRegistry);
         var _loc2_:ConfigurationModel = _loc1_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this._isMobileEnabled = _loc2_.getValue();
      }
      
      protected function dragBeginHandler(param1:DragBehavior, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:BitmapData = new BitmapData(getWidth(),getHeight(),true,0);
         _loc5_.draw(getAsset());
         var _loc6_:Clipboard = new Clipboard();
         _loc6_.setData(Buddy.DATA_FORMAT,this._buddy);
         var _loc7_:NativeDragOptions = new NativeDragOptions();
         _loc7_.allowCopy = false;
         _loc7_.allowLink = false;
         _loc7_.allowMove = true;
         NativeDragManager.doDrag(getInteractiveAsset(),_loc6_,_loc5_,new Point().subtract(param1.getLocalMouseDownPosition()),_loc7_);
      }
      
      override protected function createChildren() : void
      {
         this.buddyNameLabel = new Text(this);
         setTimelineChildByName("summonerNameLabel",this.buddyNameLabel);
         this.buddyNameLabel.setMouseEnabled(false);
         this.buddyNameLabel.setTruncateToFit(true);
         this.statusLabel = new Text(this);
         setTimelineChildByName("statusLabel",this.statusLabel);
         this.statusLabel.setMouseEnabled(false);
         this.statusLabel.setAutoSize(TextFieldAutoSize.NONE);
         this.statusLabel.setTruncateToFit(true);
         this.buddyNoteButton = new ButtonX(this);
         setTimelineChildByName("noteButton",this.buddyNoteButton);
         this.buddyNoteButton.setVisible(false);
         this.buddyNoteButton.addEventListener(MouseEvent.CLICK,this.buddyNoteClickHandler);
         assignToolTip(this.buddyNoteButton,RiotResourceLoader.getString("buddyNoteSuggestionText"));
         this.statusIndicator = new StatefulView(this);
         setTimelineChildByName("statusIndicator",this.statusIndicator);
         this.statusIndicator.setMouseEnabled(false);
         this.spectateIndicator = new SpriteProxy(this);
         setTimelineChildByName("spectatorIcon",this.spectateIndicator);
         assignToolTip(this.spectateIndicator,RiotResourceLoader.getString("chat_buddyManagerWindow_spectatorIcon"));
         this.summonerIconBox = new SpriteProxy(this);
         setTimelineChildByName("iconContainer",this.summonerIconBox);
         this.summonerIconBox.setMouseEnabled(false);
         this.summonerIcon = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this.summonerIcon.setTransformBehavior(_loc1_);
         this.summonerIcon.setSmoothing(true);
         addChild(this.summonerIcon);
         this.background = new StatefulView(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this.background.setDoubleClickEnabled(true);
         this.background.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleDoubleClick);
         _currentStateChanged.add(this.buttonStateChanged);
         addEventListener(MouseEvent.RIGHT_CLICK,this.handleContextMenu);
         getMouseIsOverChanged().add(this.handleMouseOverChanged);
         this.refreshBuddyTooltip();
      }
      
      private function buddyNoteClickHandler(param1:MouseEvent) : void
      {
         this.updateNoteLayoutPosition();
         this.createBuddyNoteDialogue(this._buddy);
      }
      
      private function refreshBuddyTooltip() : void
      {
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.showDelay = 0;
         _loc1_.toolTipPosition = new RectPosition(RectPosition.TOP_RIGHT,RectPosition.TOP_LEFT,new Point(6,0));
         TipsProviderProxy.instance.assignCustomToolTip(this,this._buddy,ChatBuddyTooltipView,_loc1_);
      }
      
      private function handleMouseOverChanged() : void
      {
         this.updateBuddyNoteButtonVisibility();
      }
      
      private function createBuddyNoteDialogue(param1:Buddy) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:BuddyNotePopup = new BuddyNotePopup(this,param1,this._viewMediator);
         _loc2_.getDismissed().add(this.handleBuddyNotePopupDismissed);
         PopUpManager.instance.addPopUp(_loc2_,this.noteLayoutData);
         unassignToolTip(this.background);
      }
      
      private function handleBuddyNotePopupDismissed() : void
      {
         this.refreshBuddyTooltip();
      }
      
      private function updateBuddyNoteButtonVisibility() : void
      {
         if(getMouseIsOver())
         {
            this.buddyNoteButton.setVisible(ClientConfig.instance.buddyNotesEnabled);
         }
         else if(this._buddy)
         {
            this.buddyNoteButton.setVisible(this._buddy.getNote() != "" && Boolean(ClientConfig.instance.buddyNotesEnabled));
         }
      }
      
      private function handleContextMenu(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._buddy)
         {
            return;
         }
         this.updateNoteLayoutPosition();
         var _loc2_:FriendsListMenu = new FriendsListMenu(this._buddy,this._viewMediator);
         _loc2_.editNoteSelect.add(this.editNoteSelectHandler);
         var _loc3_:Point = this.localToGlobal(new Point(param1.localX,param1.localY));
         _loc2_.display(this.getStage(),_loc3_.x,_loc3_.y);
      }
      
      private function buttonStateChanged(param1:StatefulView, param2:String, param3:String) : void
      {
         this.background.setCurrentState(param3);
      }
      
      private function updateNoteLayoutPosition() : void
      {
         var _loc1_:Point = null;
         if(getIsOnStage())
         {
            _loc1_ = localToGlobal(new Point(0,0));
            this.noteLayoutData.setRight(getStage().stageWidth - _loc1_.x);
            this.noteLayoutData.setTop(_loc1_.y - 50);
         }
      }
      
      private function editNoteSelectHandler(param1:FriendsListMenu) : void
      {
         this.createBuddyNoteDialogue(param1.buddy);
      }
      
      override public function getData() : *
      {
         return this._buddy;
      }
      
      override public function setData(param1:*) : void
      {
         if(this._buddy)
         {
            this._buddy.getBuddyChanged().remove(this.updateName);
            this._buddy.getBuddyChanged().remove(this.updatePresenceAndStatus);
         }
         this._buddy = param1 as Buddy;
         if(this._buddy)
         {
            if(Boolean(this._buddy.getIsOnline()) && Boolean(this._buddy.getIsMutualFriend()))
            {
               setLinkage("chat.FriendListRenderer");
               this._buddy.getBuddyChanged().add(this.updateName);
               this.updateName();
               this._buddy.getBuddyChanged().add(this.updatePresenceAndStatus);
               this.updatePresenceAndStatus();
            }
            else if(this._buddy.getIsMutualFriend())
            {
               setLinkage("chat.FriendListRendererOffline");
               this.updateName();
               this.statusLabel.setText("");
               this.statusIndicator.setCurrentState(RiotPresence.OFFLINE.assetKey);
               this.summonerIcon.setBitmapData(null);
            }
            else
            {
               setLinkage("chat.FriendListRendererPending");
               this.updateName();
               this.statusLabel.setText("");
               this.statusIndicator.setCurrentState(RiotPresence.OFFLINE.assetKey);
               this.summonerIcon.setBitmapData(null);
            }
            this.buddyNoteButton.setSelected(this._buddy.getNote() != "");
            this.updateBuddyNoteButtonVisibility();
            this.refreshBuddyTooltip();
         }
         invalidateLayout();
      }
      
      private function updateName() : void
      {
         this.buddyNameLabel.setText(this._buddy.getName());
      }
      
      private function updatePresenceAndStatus() : void
      {
         var _loc4_:BitmapData = null;
         this.updateStatusLabel();
         if(this._buddy.getPresence())
         {
            _loc4_ = BuddyImages.getSummonerIconSafely(this._buddy.getPresence().profileIconId);
            this.summonerIcon.setBitmapData(_loc4_);
            this.summonerIcon.setWidth(this.summonerIconBox.getWidth());
            this.summonerIcon.setHeight(this.summonerIconBox.getHeight());
            this.spectateIndicator.setVisible(this._viewMediator.canDropInSpectateBuddy(this._buddy));
         }
         else
         {
            this.spectateIndicator.setVisible(false);
            this.summonerIcon.setBitmapData(null);
         }
         var _loc1_:String = this._buddy.getBusyStatus();
         var _loc2_:RiotPresence = RiotPresence.fromXiffPresence(_loc1_,this._isMobileEnabled);
         var _loc3_:String = _loc2_.assetKey;
         this.statusIndicator.setCurrentState(_loc3_);
      }
      
      private function updateStatusLabel() : void
      {
         var _loc1_:RiotPresence = RiotPresence.fromXiffPresence(this._buddy.getBusyStatus(),this._isMobileEnabled);
         var _loc2_:PresenceStatusData = this._buddy.getPresence();
         var _loc3_:String = _loc2_ ? _loc2_.statusMsg : "";
         var _loc4_:String = _loc2_ ? _loc2_.gameType : "";
         var _loc5_:String = StatusMessageUtil.presenceToStatusMessage(_loc3_,_loc1_,_loc4_);
         this.statusLabel.setText(_loc5_);
         this.statusLabel.setTextColor(_loc1_.color);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.summonerIcon.setExplicitSize(this.summonerIconBox.getWidth(),this.summonerIconBox.getHeight());
         this.summonerIcon.setExplicitPosition(this.summonerIconBox.getX(),this.summonerIconBox.getY());
         return new Rectangle(0,0,this.background.getWidth(),this.background.getHeight());
      }
      
      private function handleDoubleClick(param1:MouseEvent) : void
      {
         this.startChat();
      }
      
      private function startChat() : void
      {
         if(this._buddy != null && this._buddy.getStatus() == Buddy.STATUS_ONLINE)
         {
            this._viewMediator.createPersonalPopUp(this._buddy.getJID(),true);
         }
      }
      
      override public function destroy() : void
      {
         unassignToolTip(this.buddyNoteButton);
         unassignToolTip(this.spectateIndicator);
         unassignToolTip(this.background);
         this.dragBehavior.destroy();
         super.destroy();
      }
   }
}

