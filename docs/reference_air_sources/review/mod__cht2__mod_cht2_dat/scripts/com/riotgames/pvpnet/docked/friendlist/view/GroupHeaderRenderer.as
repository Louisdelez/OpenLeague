package com.riotgames.pvpnet.docked.friendlist.view
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.BuddyGroup;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.rust.components.grouplist.GroupModel;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import com.riotgames.util.logging.getLogger;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import mx.logging.ILogger;
   import mx.resources.ResourceManager;
   
   public class GroupHeaderRenderer extends StatefulView implements IDataRenderer
   {
      
      protected var logger:ILogger = getLogger(this);
      
      private var _group:GroupModel;
      
      private var _viewMediator:ChatViewMediator;
      
      private var toggleButton:ButtonX;
      
      private var groupNameEditSprite:StatefulView;
      
      private var groupNameLabel:Text;
      
      private var groupCountLabel:TextFieldProxy;
      
      private var groupNameEditField:InputTextFieldProxy;
      
      private var _editingGroupName:Boolean;
      
      public function GroupHeaderRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("chat.GroupHeader");
         addEventListener(MouseEvent.RIGHT_CLICK,this.onContextMenu);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._viewMediator = getDependency(ChatViewMediator);
      }
      
      override protected function createChildren() : void
      {
         this.groupNameEditSprite = new StatefulView(this);
         setTimelineChildByName("groupNameEditSprite",this.groupNameEditSprite);
         this.toggleButton = new ButtonX(this);
         this.toggleButton.toggleOnClick = true;
         this.toggleButton.addEventListener(MouseEvent.CLICK,this.onClick);
         setTimelineChildByName("toggleButton",this.toggleButton);
         this.groupNameLabel = new Text(this);
         this.groupNameLabel.setSelectable(false);
         this.groupNameLabel.setDoubleClickEnabled(true);
         this.groupNameLabel.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
         this.groupNameLabel.setTruncateToFit(true);
         this.groupNameEditSprite.setTimelineChildByName("groupNameLabel",this.groupNameLabel);
         this.groupCountLabel = new TextFieldProxy(this);
         this.groupNameEditSprite.setTimelineChildByName("groupCountLabel",this.groupCountLabel);
         this.groupNameEditField = new InputTextFieldProxy(this);
         this.groupNameEditSprite.setTimelineChildByName("groupNameEditField",this.groupNameEditField);
         this.groupNameEditField.addEventListener(FocusEvent.FOCUS_OUT,this.onNameEditFieldFocusOut);
         this.groupNameEditField.addEventListener(KeyboardEvent.KEY_UP,this.onNameEditFieldKeyUp);
      }
      
      private function onNameEditFieldKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER && this._editingGroupName)
         {
            this.endNameEditing();
         }
      }
      
      private function onNameEditFieldFocusOut(param1:FocusEvent) : void
      {
         if(this._editingGroupName)
         {
            this.endNameEditing();
         }
      }
      
      private function onContextMenu(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._group)
         {
            return;
         }
         var _loc2_:NativeMenu = new NativeMenu();
         var _loc3_:Point = this.localToGlobal(new Point(param1.localX,param1.localY));
         var _loc4_:Boolean = Boolean(this._viewMediator.isCustomRosterGroup(this._group.headerData));
         var _loc5_:Boolean = this._group.headerData.getLabel() == this._viewMediator.getOfflineGroupName();
         if(!_loc5_)
         {
            if(_loc4_)
            {
               this.buildMenuItem(_loc2_,RiotResourceLoader.getString("GroupHeaderRenderer_renameGroup","**RenameGroup"),this.onRenameGroupMenuItemSelected,true);
               this.buildMenuItem(_loc2_,RiotResourceLoader.getString("BuddyListTreeRenderer_groupRemoveGroup","**RemoveGroup"),this.onRemoveGroupMenuItemSelected,true);
            }
            this.buildMenuItem(_loc2_,RiotResourceLoader.getString("GroupHeaderRenderer_moveGroupUp","**Move group up"),this.onMoveGroupUpMenuItemSelected,true);
            this.buildMenuItem(_loc2_,RiotResourceLoader.getString("GroupHeaderRenderer_moveGroupDown","**Move group down"),this.onMoveGroupDownMenuItemSelected,true);
            this.buildMenuItem(_loc2_,RiotResourceLoader.getString("BuddyListTreeRenderer_groupInviteToChat","**Invite Group To Chat"),this.onInviteGroupToChatMenuItemSelected,true);
         }
         _loc2_.display(this.getStage(),_loc3_.x,_loc3_.y);
      }
      
      private function onRenameGroupMenuItemSelected(param1:Event) : void
      {
         this.setNameEditActive();
      }
      
      private function onMoveGroupUpMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.moveGroupUp(this._group.headerData);
      }
      
      private function onMoveGroupDownMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.moveGroupDown(this._group.headerData);
      }
      
      private function setNameEditActive() : void
      {
         this._editingGroupName = true;
         this.groupNameEditSprite.setCurrentState("active");
         this.groupNameEditField.getAsset().stage.focus = this.groupNameEditField.getAsset() as TextField;
         this.groupNameEditField.setSelection(0,this.groupNameEditField.getText().length);
      }
      
      private function endNameEditing() : void
      {
         var _loc3_:AlertAction = null;
         this._editingGroupName = false;
         var _loc1_:String = this.groupNameEditField.getText();
         this.groupNameEditSprite.setCurrentState("inactive");
         if(this._group.headerData.getLabel() == _loc1_)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(this._viewMediator.renameGroup(this._group.headerData,_loc1_));
         if(!_loc2_)
         {
            this.groupNameEditField.setText(this._group.headerData.getLabel());
            this.logger.error("0001 Renaming the group failed.");
            _loc3_ = new AlertAction(RiotResourceLoader.getString("GroupHeaderRenderer_renameGroupErrorTitle","**Rename Group Error"),RiotResourceLoader.getString("GroupHeaderRenderer_renameGroupError","**Renaming the group has failed. Please try again."));
            _loc3_.add();
         }
      }
      
      private function onInviteGroupToChatMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.inviteGroupToChat(this._group.headerData);
      }
      
      private function onRemoveGroupMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.emptyAndRemoveGroup(this._group.headerData.getLabel());
      }
      
      private function buildMenuItem(param1:NativeMenu, param2:String, param3:Function, param4:Boolean) : void
      {
         var _loc5_:NativeMenuItem = new NativeMenuItem(param2);
         _loc5_.enabled = param4;
         param1.addItem(_loc5_);
         if(param3 != null)
         {
            _loc5_.addEventListener(Event.SELECT,param3,false,0,true);
         }
      }
      
      public function getData() : *
      {
         return this._group;
      }
      
      public function setData(param1:*) : void
      {
         if(this._group)
         {
            this._group.expandedChanged.remove(this.handleGroupExpandedChanged);
            this._group.itemsChanged.remove(this.handleGroupItemsChanged);
            this._group.headerChanged.remove(this.handleHeaderChanged);
         }
         this._group = param1;
         if(this._group)
         {
            this._group.expandedChanged.add(this.handleGroupExpandedChanged);
            this._group.itemsChanged.add(this.handleGroupItemsChanged);
            this._group.headerChanged.add(this.handleHeaderChanged);
            this.handleGroupExpandedChanged();
            this.handleGroupItemsChanged();
         }
      }
      
      private function handleGroupExpandedChanged() : void
      {
         setCurrentState(this._group.expanded ? "open" : "closed");
      }
      
      private function handleGroupItemsChanged() : void
      {
         this.updateHeaderText();
      }
      
      private function handleHeaderChanged() : void
      {
         this.updateHeaderText();
      }
      
      private function updateHeaderText() : void
      {
         var _loc1_:String = (this._group.headerData as BuddyGroup).getLabel();
         if(_loc1_ == this._viewMediator.getDefaultGroupName())
         {
            _loc1_ = ResourceManager.getInstance().getString("resources","chat_defaultBuddyGroup");
         }
         this.groupNameEditField.setText((this._group.headerData as BuddyGroup).getLabel());
         this.groupNameLabel.setText(_loc1_);
         this.groupCountLabel.setText(ResourceManager.getInstance().getString("resources","BuddyListTreeRenderer_groupNumber",[this._group.itemData.filter(this.isOnline).length,this._group.unfilteredSize]));
      }
      
      private function isOnline(param1:Buddy, param2:int, param3:Array) : Boolean
      {
         return param1.getIsOnline();
      }
      
      private function onDoubleClick(param1:MouseEvent) : void
      {
         if(Boolean(this._group) && Boolean(this._viewMediator.isCustomRosterGroup(this._group.headerData)))
         {
            this.setNameEditActive();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this._group.expanded = !this._group.expanded;
      }
   }
}

