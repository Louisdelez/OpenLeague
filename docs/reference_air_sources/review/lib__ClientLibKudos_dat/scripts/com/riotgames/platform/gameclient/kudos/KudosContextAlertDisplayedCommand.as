package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   
   public class KudosContextAlertDisplayedCommand extends CommandBase
   {
      
      private var alertParams:AlertParameters;
      
      private var kudosService:IKudosService;
      
      private var kudosData:PendingKudos;
      
      private var summonerId:Number;
      
      public function KudosContextAlertDisplayedCommand(param1:PendingKudos, param2:IKudosService)
      {
         super();
         this.kudosData = param1;
         this.kudosService = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(!this.kudosService)
         {
            throw new Error("Unable to execute command - no KudosService specified.");
         }
         this.kudosService.sendKudosAcknowledgement(this.kudosData,null);
         onComplete();
      }
   }
}

