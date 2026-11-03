package com.riotgames.platform.gameclient.kudos
{
   import blix.context.IContext;
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.views.summoner.ISummonerInfoQuickView;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.UIComponent;
   
   public class KudosFactoryDisabled implements IKudosFactory
   {
      
      protected var context:IContext;
      
      private var serviceProxy:ServiceProxy;
      
      public function KudosFactoryDisabled()
      {
         super();
      }
      
      public function getChampSelectBadgeRenderer() : IKudosChampSelectBadgeRenderer
      {
         return new KudosChampSelectBadgeRendererDisabled();
      }
      
      public function createKudosBadgeDialogCommand(param1:int, param2:int) : ICommand
      {
         return new CommandBase();
      }
      
      public function getServiceProxy() : ServiceProxy
      {
         return this.serviceProxy;
      }
      
      public function getKudosProfileTotalsCache() : IKudosProfileTotalsCache
      {
         return new KudosProfileTotalsCacheDisabled();
      }
      
      public function updateKudosState(param1:Boolean, param2:ServiceProxy) : void
      {
         this.serviceProxy = param2;
      }
      
      public function createShowReceivedKudosCommand() : ICommand
      {
         return new CommandBase();
      }
      
      public function getKudosDialog(param1:Boolean, param2:Number, param3:Number, param4:String, param5:Number, param6:Point) : IKudosDialog
      {
         return new KudosDialogDisabled();
      }
      
      public function getProfilePanel(param1:ISummonerInfoQuickView) : IKudosProfilePanel
      {
         return new KudosProfilePanelDisabled();
      }
      
      public function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton
      {
         return new KudosButtonDisabled();
      }
      
      public function createKudosContextAlertCommand(param1:PendingKudos, param2:Boolean = true) : ICommand
      {
         return new CommandBase();
      }
   }
}

