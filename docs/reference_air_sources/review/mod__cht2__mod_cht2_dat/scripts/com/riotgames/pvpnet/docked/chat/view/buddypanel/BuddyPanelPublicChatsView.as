package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomListViewModel;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.rust.data.ListAdapter;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelPublicChatsView extends SpriteProxy
   {
      
      private static const layoutGap:uint = 1;
      
      private var _chatRoomListViewModel:ChatRoomListViewModel;
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _rendererFactory:RendererFactory;
      
      private var _chatListAdapter:ListAdapter;
      
      private var _publicChatList:ListView;
      
      private var _publicChatDataGroup:DataGroup;
      
      private var _sectionHeader:SpriteProxy;
      
      private var _sectionHeaderText:TextFieldProxy;
      
      public function BuddyPanelPublicChatsView(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function initializeDependencies() : void
      {
         this._chatViewMediator = getDependency(ChatViewMediator);
         this._chatRoomListViewModel = this._chatViewMediator.getChatRoomListViewModel();
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._rendererFactory = new RendererFactory(BuddyPanelChatRoomRenderer,[this]);
         this._chatListAdapter = new ListAdapter(this._chatRoomListViewModel.publicChatRoomInfoList);
         this._publicChatList = new ListView(this._chatListAdapter);
         this._sectionHeader = new SpriteProxy(this);
         this._sectionHeader.setLinkage("PublicChatHeader");
         addChild(this._sectionHeader);
         this._sectionHeaderText = new TextFieldProxy(this);
         this._sectionHeader.setTimelineChildByName("textField",this._sectionHeaderText);
         this._sectionHeaderText.setText(ResourceManager.getInstance().getString("resources","chat_buddyWindow_massiveChatLabel"));
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(layoutGap);
         _loc1_.setPadding(new Padding(layoutGap,0,0,0));
         this._publicChatDataGroup = new DataGroup(this);
         this._publicChatDataGroup.setRendererFactory(this._rendererFactory);
         this._publicChatDataGroup.setDataProvider(this._publicChatList);
         this._publicChatDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._publicChatDataGroup.setLayoutAlgorithm(_loc1_);
         addChild(this._publicChatDataGroup);
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = new Point();
         _loc3_ = this._publicChatDataGroup.setExplicitSize(NaN,NaN);
         this._publicChatDataGroup.setExplicitPosition(0,20);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y + 20);
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         super.destroy();
      }
   }
}

