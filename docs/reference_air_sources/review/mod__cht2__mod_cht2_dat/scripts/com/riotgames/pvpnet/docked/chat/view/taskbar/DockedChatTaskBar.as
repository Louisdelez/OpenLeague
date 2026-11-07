package com.riotgames.pvpnet.docked.chat.view.taskbar
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.MultiRendererFactory;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.LayoutEntry;
   import blix.layout.data.SizeLayoutData;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.chat.IDockedMessageWindow;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   import com.riotgames.pvpnet.docked.chat.view.*;
   import com.riotgames.pvpnet.docked.chat.view.groupchat.GroupChatWindowView;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class DockedChatTaskBar extends LayoutContainerView
   {
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _chatModels:ArrayCollection;
      
      private var chatViewFactory:MultiRendererFactory;
      
      private var _currentChatViews:Vector.<LayoutEntry> = new Vector.<LayoutEntry>();
      
      private var renderersAreValidFlag:Boolean = false;
      
      private var _sizer:SpriteProxy;
      
      public function DockedChatTaskBar(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._chatViewMediator = getDependency(ChatViewMediator);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:DockedChatLayout = new DockedChatLayout();
         setLayoutAlgorithm(_loc1_);
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this.chatViewFactory = new MultiRendererFactory();
         this.chatViewFactory.getEntryConstructed().add(this.chatViewConstructedHandler);
         this.chatViewFactory.getEntryDeconstructed().add(this.chatViewDeconstructedHandler);
         var _loc2_:SizeLayoutData = new SizeLayoutData();
         _loc2_.setWidthPercent(1);
         this.chatViewFactory.addType(ChatWindowModel,ChatWindowView,[this],_loc2_);
         this.chatViewFactory.addType(ChatRoom,GroupChatWindowView,[this],_loc2_);
         this._chatModels = this._chatViewMediator.getTotalChatViews();
         this._chatModels.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.chatModelsCollectionChangeHandler);
         this._chatViewMediator.getCurrentChatModelChanged().add(this.refreshOpenedWindows);
      }
      
      private function chatViewConstructedHandler(param1:LayoutEntry, param2:*) : void
      {
         var _loc3_:IDockedMessageWindow = IDockedMessageWindow(param1.element);
         _loc3_.getActivateWindowRequested().add(this.onActivateWindowRequested);
         _loc3_.getMinimizeWindowRequested().add(this.onMinimizeWindowRequested);
         _loc3_.getCloseWindowRequested().add(this.onCloseWindowRequested);
         _loc3_.getViewProfileRequested().add(this.onViewProfileRequested);
      }
      
      private function chatViewDeconstructedHandler(param1:LayoutEntry) : void
      {
         var _loc2_:IDockedMessageWindow = IDockedMessageWindow(param1.element);
         _loc2_.getActivateWindowRequested().remove(this.onActivateWindowRequested);
         _loc2_.getMinimizeWindowRequested().remove(this.onMinimizeWindowRequested);
         _loc2_.getCloseWindowRequested().remove(this.onCloseWindowRequested);
         _loc2_.getViewProfileRequested().remove(this.onViewProfileRequested);
      }
      
      private function onCloseWindowRequested(param1:IDockedMessageWindow, param2:* = null) : void
      {
         var _loc3_:ChatWindowView = null;
         var _loc4_:ChatWindowModel = null;
         var _loc5_:UnescapedJID = null;
         var _loc6_:GroupChatWindowView = null;
         var _loc7_:ChatRoom = null;
         if(this._chatViewMediator.getCurrentChatModel() == param1.getData())
         {
            this._chatViewMediator.setCurrentChatModel(null);
         }
         if(param1 is ChatWindowView)
         {
            _loc3_ = param1 as ChatWindowView;
            _loc4_ = _loc3_.getModel();
            _loc5_ = new UnescapedJID(_loc4_.getBuddy().getJID());
            this._chatViewMediator.closePersonalPopupWindow(_loc5_);
         }
         else if(param1 is GroupChatWindowView)
         {
            _loc6_ = param1 as GroupChatWindowView;
            _loc7_ = _loc6_.getModel();
            this._chatViewMediator.closeChatRoomBySubject(_loc7_.subject,_loc7_.getRoomType());
         }
      }
      
      private function onViewProfileRequested(param1:IDockedMessageWindow, param2:Buddy) : void
      {
         this._chatViewMediator.viewProfile(param2);
      }
      
      private function onActivateWindowRequested(param1:IDockedMessageWindow) : void
      {
         this._chatViewMediator.setCurrentChatModel(param1.getData());
      }
      
      private function refreshOpenedWindows() : void
      {
         var _loc2_:LayoutEntry = null;
         var _loc3_:IDockedMessageWindow = null;
         var _loc1_:Object = this._chatViewMediator.getCurrentChatModel();
         for each(_loc2_ in this._currentChatViews)
         {
            _loc3_ = IDockedMessageWindow(_loc2_.element);
            if(_loc3_.getData() != _loc1_)
            {
               _loc3_.setIsOpen(false);
            }
            else
            {
               _loc3_.setIsOpen(true);
            }
         }
      }
      
      private function onMinimizeWindowRequested(param1:IDockedMessageWindow) : void
      {
         if(this._chatViewMediator.getCurrentChatModel() == param1.getData())
         {
            this._chatViewMediator.setCurrentChatModel(null);
         }
      }
      
      private function chatModelsCollectionChangeHandler(param1:CollectionEvent = null) : void
      {
         this.renderersAreValidFlag = false;
         invalidateLayout();
         this.validate();
      }
      
      override public function validate() : void
      {
         if(!this.renderersAreValidFlag)
         {
            this.validateRenderers();
         }
         super.validate();
      }
      
      private function validateRenderers() : void
      {
         var _loc1_:LayoutEntry = null;
         var _loc2_:Object = null;
         var _loc3_:IDockedMessageWindow = null;
         var _loc4_:* = undefined;
         var _loc5_:LayoutEntry = null;
         for each(_loc1_ in this._currentChatViews)
         {
            _loc3_ = IDockedMessageWindow(_loc1_.element);
            _loc4_ = _loc3_.getData();
            if(this._chatModels.getItemIndex(_loc4_) == -1)
            {
               removeElement(_loc3_);
               _loc3_.destroy();
            }
            else
            {
               removeElement(_loc1_.element);
               this.chatViewFactory.returnEntry(_loc1_);
            }
         }
         this._currentChatViews.length = 0;
         for each(_loc2_ in this._chatModels)
         {
            _loc5_ = this.chatViewFactory.createEntry(_loc2_);
            addElement(_loc5_.element,_loc5_.data);
            this._currentChatViews[this._currentChatViews.length] = _loc5_;
         }
         this.refreshOpenedWindows();
         this.renderersAreValidFlag = true;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return super.updateLayout(this._sizer.getWidth(),this._sizer.getHeight());
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.chatViewFactory.destroy();
      }
   }
}

