package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.views.summoner.ISummonerInfoQuickView;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.UIComponent;
   
   public class KudosFactoryProxy extends ProviderProxyBase implements IKudosFactory
   {
      
      private static var _instance:IKudosFactory = new KudosFactoryProxy();
      
      public function KudosFactoryProxy()
      {
         super(IKudosFactory,true);
      }
      
      public static function getInstance() : IKudosFactory
      {
         return _instance;
      }
      
      public function getChampSelectBadgeRenderer() : IKudosChampSelectBadgeRenderer
      {
         return _invoke("getChampSelectBadgeRenderer",[]);
      }
      
      public function createKudosBadgeDialogCommand(param1:int, param2:int) : ICommand
      {
         return _invoke("createKudosBadgeDialogCommand",[param1,param2]);
      }
      
      public function createShowReceivedKudosCommand() : ICommand
      {
         return _invoke("createShowReceivedKudosCommand");
      }
      
      public function createKudosContextAlertCommand(param1:PendingKudos, param2:Boolean = true) : ICommand
      {
         return _invoke("createKudosContextAlertCommand",[param1,param2]);
      }
      
      public function getServiceProxy() : ServiceProxy
      {
         return _invoke("getServiceProxy",[]);
      }
      
      public function getKudosProfileTotalsCache() : IKudosProfileTotalsCache
      {
         return _invoke("getKudosProfileTotalsCache");
      }
      
      public function getKudosDialog(param1:Boolean, param2:Number, param3:Number, param4:String, param5:Number, param6:Point) : IKudosDialog
      {
         return _invoke("getKudosDialog",[param1,param2,param3,param4,param5,param6]);
      }
      
      public function getProfilePanel(param1:ISummonerInfoQuickView) : IKudosProfilePanel
      {
         return _invoke("getProfilePanel",[param1]);
      }
      
      public function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton
      {
         return _invoke("getKudosButton",[param1,param2,param3,param4,param5,param6,param7,param8,param9]);
      }
      
      public function updateKudosState(param1:Boolean, param2:ServiceProxy) : void
      {
         _invoke("updateKudosState",[param1,param2]);
      }
   }
}

