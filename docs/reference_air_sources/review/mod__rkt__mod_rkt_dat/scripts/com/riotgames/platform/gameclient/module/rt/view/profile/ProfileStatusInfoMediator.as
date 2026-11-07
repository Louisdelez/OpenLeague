package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import com.riotgames.platform.common.provider.ICLSProvider;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.provider.ProviderLookup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ProfileStatusInfoMediator extends Mediator
   {
      
      public static const NAME:String = "ProfileStatusInfoMediator";
      
      public static const SEEDING:String = "seeding";
      
      public static const SEEDING_INACTIVE:String = "seedingInactive";
      
      public static const RANKED:String = "ranked";
      
      public static const INACTIVE:String = "inactive";
      
      public static const DECAYING_SOON:String = "decayingSoon";
      
      private var _leagueSystemProvider:ICLSProvider;
      
      public function ProfileStatusInfoMediator(param1:Object = null)
      {
         super(NAME,param1);
         ProviderLookup.getProvider(ICLSProvider,this.onGetLeagueProvider);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ProfileTeamProxy.PROFILE_TEAM_CHANGE,RTNotificationConstants.RT_MODULE_STARTUP,RTNotificationConstants.RT_MODULE_TEARDOWN];
      }
      
      override public function onRegister() : void
      {
         this.refreshView();
      }
      
      private function get view() : ProfileStatusInfo
      {
         return viewComponent as ProfileStatusInfo;
      }
      
      private function refreshView() : void
      {
         var _loc1_:Team = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(RTFacade.profileTeamProxy.team)
         {
            _loc1_ = RTFacade.profileTeamProxy.team;
            _loc3_ = null;
            if(_loc1_.status == TeamStatus.PROVISIONAL)
            {
               _loc5_ = int(_loc1_.getInactivityStatus());
               switch(_loc5_)
               {
                  case Team.STATUS_ACTIVE:
                     _loc2_ = SEEDING;
                     break;
                  case Team.STATUS_PENDING_INACTIVE:
                     _loc2_ = SEEDING_INACTIVE;
                     _loc3_ = this.makePendingInactiveStatusString(_loc1_);
                     break;
                  case Team.STATUS_INACTIVE:
                     _loc2_ = INACTIVE;
               }
            }
            else
            {
               _loc2_ = RANKED;
            }
            _loc4_ = null;
            if(this._leagueSystemProvider)
            {
               this._leagueSystemProvider.getTeamProfileDecayMessages(_loc1_.name);
            }
            if(_loc4_)
            {
               _loc2_ = DECAYING_SOON;
            }
            this.view.setStatusState(_loc2_,_loc3_);
            if(_loc4_)
            {
               this.view.setBulletText(_loc4_.message);
            }
         }
      }
      
      private function onGetLeagueProvider(param1:ICLSProvider) : void
      {
         this._leagueSystemProvider = param1;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ProfileTeamProxy.PROFILE_TEAM_CHANGE:
               this.refreshView();
               break;
            case RTNotificationConstants.RT_MODULE_STARTUP:
            case RTNotificationConstants.RT_MODULE_TEARDOWN:
         }
      }
      
      private function makePendingInactiveStatusString(param1:Team) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = int(param1.calculateSecondsUntilEligibleForDeletion());
         if(_loc4_ > 60 * 60 * 24 * 1.5)
         {
            _loc2_ = Math.round(_loc4_ / (60 * 60 * 24)).toString();
            _loc3_ = RTResource.getString("timeDays");
         }
         else if(_loc4_ > 60 * 90)
         {
            _loc2_ = Math.round(_loc4_ / (60 * 60)).toString();
            _loc3_ = RTResource.getString("timeHours");
         }
         else
         {
            _loc2_ = Math.round(_loc4_ / 60).toString();
            _loc3_ = RTResource.getString("timeMinutes");
         }
         return RTResource.getString("statusSeedingInactive",[_loc2_,_loc3_]);
      }
   }
}

