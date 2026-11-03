package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.IChromeContextAlertProvider;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   
   public class KudosContextAlertCommandEnabled extends CommandBase
   {
      
      private var alertParams:AlertParameters;
      
      private var kudosData:PendingKudos;
      
      private var chromeContextAlertProvider:IChromeContextAlertProvider;
      
      public function KudosContextAlertCommandEnabled(param1:PendingKudos, param2:IChromeContextAlertProvider, param3:AlertParameters)
      {
         super();
         this.kudosData = param1;
         this.chromeContextAlertProvider = param2;
         this.alertParams = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(Boolean(this.kudosData) && Boolean(this.kudosData.isValid()))
         {
            if(this.kudosData.getHonorTotal() > 0)
            {
               this.chromeContextAlertProvider.showAlertForParameters(this.alertParams);
            }
         }
         onComplete();
      }
   }
}

