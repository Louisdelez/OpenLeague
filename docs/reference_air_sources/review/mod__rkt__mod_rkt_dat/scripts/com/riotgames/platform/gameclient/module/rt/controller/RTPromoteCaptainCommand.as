package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.module.rt.vo.ErrorMessageVO;
   import mx.collections.ArrayCollection;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTPromoteCaptainCommand extends RTSimpleCommand
   {
      
      public static const PROMOTE:String = "RTPromoteCaptainCommand.PROMOTE";
      
      private var team:Team = null;
      
      public function RTPromoteCaptainCommand()
      {
         super();
      }
      
      public static function BuildCommandArgs(param1:Team) : Object
      {
         return {"team":param1};
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ArrayCollection = null;
         this.team = param1.getBody().team;
         if(this.team)
         {
            _loc2_ = ProfileTeamProxy.findOwnerCandidates(this.team);
            RTFacade.modalMediator.showPromoteCaptainModal(_loc2_,RTResource.getString("promoteCaptainWarningMessage"),RTResource.getString("promoteCaptainButtonLabel"),this.onPromoteCaptainClicked);
         }
      }
      
      private function onPromoteCaptainClicked(param1:TeamMemberInfo) : void
      {
         var _loc2_:ErrorMessageVO = null;
         if(param1)
         {
            RTFacade.playerProxy.changeOwner(param1.playerId,this.team.teamId);
         }
         else
         {
            _loc2_ = new ErrorMessageVO();
            _loc2_.setTitle("ranked_team_error_header");
            _loc2_.setBody("RT_NOT_TEAM_OWNER");
            sendNotification(RTErrorCommand.ERROR,_loc2_);
         }
      }
   }
}

