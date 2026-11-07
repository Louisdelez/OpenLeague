package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.views.summoner.ISummonerInfoQuickView;
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.UIComponent;
   
   public interface IKudosFactory extends IProvider
   {
      
      function getKudosDialog(param1:Boolean, param2:Number, param3:Number, param4:String, param5:Number, param6:Point) : IKudosDialog;
      
      function getChampSelectBadgeRenderer() : IKudosChampSelectBadgeRenderer;
      
      function createKudosBadgeDialogCommand(param1:int, param2:int) : ICommand;
      
      function updateKudosState(param1:Boolean, param2:ServiceProxy) : void;
      
      function createShowReceivedKudosCommand() : ICommand;
      
      function getProfilePanel(param1:ISummonerInfoQuickView) : IKudosProfilePanel;
      
      function getKudosProfileTotalsCache() : IKudosProfileTotalsCache;
      
      function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton;
      
      function createKudosContextAlertCommand(param1:PendingKudos, param2:Boolean = true) : ICommand;
      
      function getServiceProxy() : ServiceProxy;
   }
}

