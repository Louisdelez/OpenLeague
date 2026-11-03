package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.views.summoner.ISummonerInfoQuickView;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.UIComponent;
   
   public class KudosFactoryComposite implements IKudosFactory
   {
      
      private var _disabledKudosFactory:IKudosFactory;
      
      private var _enabledKudosFactory:IKudosFactory;
      
      private var activeKudosFactory:IKudosFactory;
      
      public function KudosFactoryComposite(param1:IKudosFactory, param2:IKudosFactory)
      {
         super();
         this.enabledKudosFactory = param1;
         this.disabledKudosFactory = param2;
         this.activeKudosFactory = this._disabledKudosFactory;
      }
      
      public function getKudosProfileTotalsCache() : IKudosProfileTotalsCache
      {
         return this.activeKudosFactory.getKudosProfileTotalsCache();
      }
      
      public function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton
      {
         return this.activeKudosFactory.getKudosButton(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public function createKudosContextAlertCommand(param1:PendingKudos, param2:Boolean = true) : ICommand
      {
         return this.activeKudosFactory.createKudosContextAlertCommand(param1,param2);
      }
      
      public function getKudosDialog(param1:Boolean, param2:Number, param3:Number, param4:String, param5:Number, param6:Point) : IKudosDialog
      {
         return this.activeKudosFactory.getKudosDialog(param1,param2,param3,param4,param5,param6);
      }
      
      public function getProfilePanel(param1:ISummonerInfoQuickView) : IKudosProfilePanel
      {
         return this.activeKudosFactory.getProfilePanel(param1);
      }
      
      public function createShowReceivedKudosCommand() : ICommand
      {
         return this.activeKudosFactory.createShowReceivedKudosCommand();
      }
      
      public function set enabledKudosFactory(param1:IKudosFactory) : void
      {
         this._enabledKudosFactory = param1;
      }
      
      public function getChampSelectBadgeRenderer() : IKudosChampSelectBadgeRenderer
      {
         return this.activeKudosFactory.getChampSelectBadgeRenderer();
      }
      
      public function createKudosBadgeDialogCommand(param1:int, param2:int) : ICommand
      {
         return this.activeKudosFactory.createKudosBadgeDialogCommand(param1,param2);
      }
      
      public function getServiceProxy() : ServiceProxy
      {
         return this.activeKudosFactory.getServiceProxy();
      }
      
      public function updateKudosState(param1:Boolean, param2:ServiceProxy) : void
      {
         if(param1)
         {
            this.activeKudosFactory = this._enabledKudosFactory;
         }
         else
         {
            this.activeKudosFactory = this._disabledKudosFactory;
         }
         this.activeKudosFactory.updateKudosState(param1,param2);
      }
      
      public function set disabledKudosFactory(param1:IKudosFactory) : void
      {
         this._disabledKudosFactory = param1;
      }
   }
}

