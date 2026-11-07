package com.riotgames.platform.gameclient.module.rt.view.intro
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class IntroTeamMediator extends Mediator
   {
      
      public static const NAME:String = "IntroTeamMediator";
      
      public function IntroTeamMediator(param1:String = "IntroTeamMediator", param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [RTNotificationConstants.RT_MODULE_TEARDOWN];
      }
      
      private function get view() : IntroTeamView
      {
         return viewComponent as IntroTeamView;
      }
      
      override public function onRegister() : void
      {
         this.view.createButton.addEventListener(MouseEvent.CLICK,this.onCreateClicked);
         this.view.linkClickSignal.add(this.onLinkClick);
         this.updateVisibility();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case RTNotificationConstants.RT_MODULE_TEARDOWN:
         }
      }
      
      private function onCreateClicked(param1:MouseEvent) : void
      {
         RTFacade.modalMediator.showCreateTeamModal();
      }
      
      private function updateVisibility() : void
      {
         if(RTFacade.instance.rtProvider.session.summonerLevel.summonerLevel >= Team.MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS)
         {
            this.view.createButton.setVisible(true);
            this.view.notLevel30Text.setVisible(false);
         }
         else
         {
            this.view.createButton.setVisible(false);
            this.view.notLevel30Text.setVisible(true);
         }
      }
      
      private function onLinkClick() : void
      {
         navigateToURL(new URLRequest(RTResource.getString("rt_footer_URL")));
      }
   }
}

