package com.riotgames.platform.gameclient.module.rt.view.tab
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.topTab.TabItemRenderer;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.pvpnet.component.DeprecatedAudioButton;
   import com.riotgames.rust.components.FlashFlexComponent;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class ProfileTabRenderer extends FlashFlexComponent implements IListItemRenderer
   {
      
      private var _data:TeamInfo;
      
      public var alertIcon:StatefulView;
      
      public var itemName:TextFieldProxy;
      
      public function ProfileTabRenderer()
      {
         super(RTFacade.context,"rt.TabItemRenderer");
         var _loc1_:TabItemRenderer = new TabItemRenderer();
         this.alertIcon = new StatefulView(this.view);
         this.view.setTimelineChild(_loc1_.pendingAlert,this.alertIcon);
         this.itemName = _loc1_.itemName.create(this.view);
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new DeprecatedAudioButton(_context);
      }
      
      override protected function commitProperties() : void
      {
         if(this._data)
         {
            this.itemName.setText(this._data.name);
            if(this._data.memberStatusString == TeamMemberStatus.INVITED)
            {
               this.alertIcon.setVisible(true);
               this.alertIcon.setCurrentState("invited");
            }
            else if(this._data.calculateSecondsUntilEligibleForDeletion() < Team.INACTIVE_WARNING_SECONDS)
            {
               this.alertIcon.setVisible(true);
               this.alertIcon.setCurrentState("inactive");
            }
            else
            {
               this.alertIcon.setVisible(false);
            }
            this.view.setEnabled(true);
         }
         else
         {
            this.itemName.setText("");
            this.alertIcon.setVisible(false);
            this.view.setEnabled(false);
         }
      }
      
      public function get view() : DeprecatedAudioButton
      {
         return _view as DeprecatedAudioButton;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = TeamInfo(param1);
         invalidateProperties();
      }
   }
}

