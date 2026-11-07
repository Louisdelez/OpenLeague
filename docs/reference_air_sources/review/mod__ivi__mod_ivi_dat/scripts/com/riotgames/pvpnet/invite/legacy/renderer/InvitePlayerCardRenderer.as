package com.riotgames.pvpnet.invite.legacy.renderer
{
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import com.riotgames.pvpnet.invite.legacy.component.InvitePlayerCardButton;
   import com.riotgames.pvpnet.invite.legacy.component.InvitePlayerCardImpl;
   import com.riotgames.pvpnet.invite.legacy.event.InviteBayEvent;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import com.riotgames.rust.context.RustContext;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InvitePlayerCardRenderer extends UIComponent implements IListItemRenderer, IDataRenderer
   {
      
      private var mainView:StatefulView;
      
      private var _data:Object;
      
      private var playerCard:InvitePlayerCardImpl;
      
      private var playerCardButton:InvitePlayerCardButton;
      
      private var _2055852561isAddBuddy:Boolean = true;
      
      private var _951530927context:RustContext;
      
      private var _1515640978inviteRules:IInviteBayRules;
      
      public function InvitePlayerCardRenderer()
      {
         super();
      }
      
      public function set context(param1:RustContext) : void
      {
         var _loc2_:Object = this._951530927context;
         if(_loc2_ !== param1)
         {
            this._951530927context = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"context",_loc2_,param1));
         }
      }
      
      public function get context() : RustContext
      {
         return this._951530927context;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         this.playerCard.isAddBuddy = this.isAddBuddy;
         this.playerCard.inviteRules = this.inviteRules;
         this.playerCardButton.isAddBuddy = this.isAddBuddy;
         this.playerCardButton.inviteRules = this.inviteRules;
         this.playerCard.data = this._data as RosterItemVO;
         this.playerCardButton.data = this._data as RosterItemVO;
         this.playerCardButton.actionSignal.add(this.onInviteAction);
      }
      
      private function onDoubleClick(param1:MouseEvent) : void
      {
         this.onInviteAction();
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         invalidateProperties();
      }
      
      public function set inviteRules(param1:IInviteBayRules) : void
      {
         var _loc2_:Object = this._1515640978inviteRules;
         if(_loc2_ !== param1)
         {
            this._1515640978inviteRules = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteRules",_loc2_,param1));
         }
      }
      
      private function onInviteAction() : void
      {
         if(this.isAddBuddy)
         {
            dispatchEvent(new InviteBayEvent(InviteBayEvent.ADD_PLAYER,this._data as RosterItemVO));
         }
         else
         {
            dispatchEvent(new InviteBayEvent(InviteBayEvent.REMOVE_PLAYER,this._data as RosterItemVO));
         }
      }
      
      public function get view() : StatefulView
      {
         return this.mainView;
      }
      
      public function get inviteRules() : IInviteBayRules
      {
         return this._1515640978inviteRules;
      }
      
      public function get isAddBuddy() : Boolean
      {
         return this._2055852561isAddBuddy;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set isAddBuddy(param1:Boolean) : void
      {
         var _loc2_:Object = this._2055852561isAddBuddy;
         if(_loc2_ !== param1)
         {
            this._2055852561isAddBuddy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isAddBuddy",_loc2_,param1));
         }
      }
      
      override protected function createChildren() : void
      {
         this.mainView = new StatefulView(this.context);
         this.mainView.setLinkage("playerInviteCard");
         var _loc1_:ButtonX = new ButtonX(this.view);
         this.view.setTimelineChildByName("playerCardContainer",_loc1_);
         this.playerCard = new InvitePlayerCardImpl(this.view);
         _loc1_.setTimelineChildByName("playerCard",this.playerCard);
         this.playerCardButton = new InvitePlayerCardButton(this.view);
         this.view.setTimelineChildByName("inviteButtons",this.playerCardButton);
         _loc1_.setDoubleClickEnabled(true);
         _loc1_.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
         this.addChild(this.mainView.getAsset());
      }
   }
}

